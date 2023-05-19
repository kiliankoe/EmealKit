#if canImport(CoreNFC)
import Foundation
import CoreNFC
import os.log

// Huge thanks to Georg Sieber for a reference implementation of this at https://github.com/schorschii/MensaGuthaben-iOS

public class Emeal: NSObject, NFCTagReaderSessionDelegate {
    private var cardID: Int = 0
    private var readerSession: NFCTagReaderSession?

    private var strings: LocalizedEmealStrings
    public weak var delegate: EmealDelegate?

    public init(localizedStrings: LocalizedEmealStrings) {
        self.strings = localizedStrings
    }

    /// Begin the NFC reading session prompting the user to hold their device to their card.
    public func beginNFCSession() {
        Logger.emealKitNFC.debug("Beginning session")
        readerSession = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
        readerSession?.alertMessage = strings.alertMessage
        readerSession?.begin()
    }

    public func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {}

    public func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        Logger.emealKitNFC.error("Session invalidated with error: \(String(describing: error))")
        readerSession = nil
        DispatchQueue.main.async {
            self.delegate?.invalidate(with: error)
        }
    }

    public func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        guard let tag = tags.first else {
            Logger.emealKitNFC.error("Failed to read tags, no tags found")
            session.invalidate(errorMessage: strings.nfcReadingError)
            return
        }
        Logger.emealKitNFC.debug("Detected NFC tags (first will be used): \(tags)")
        Task {
            do {
                Logger.emealKitNFC.debug("Connecting to NFC tag")
                try await session.connect(to: tag)
            } catch {
                session.invalidate(errorMessage: self.strings.nfcConnectionError)
                Logger.emealKitNFC.error("Failed to connect to NFC tag: \(String(describing: error))")
                return
            }

            do {
                guard let card = GenericNFCTag(tag: tag) else {
                    Logger.emealKitNFC.error("Unexpected tag type: \(String(describing: tag))")
                    self.readerSession?.invalidate(errorMessage: strings.nfcReadingError)
                    return
                }
                Logger.emealKitNFC.info("Detected \(String(describing: card.card)) with ID \(card.id, privacy: .sensitive)")
                let (currentBalance, lastTransaction) = try await card.readTag()
                await MainActor.run {
                    self.delegate?.readData(currentBalance: currentBalance, lastTransaction: lastTransaction)
                    session.invalidate()
                }
            } catch {
                Logger.emealKitNFC.error("Failed to read NFC data from card: \(String(describing: error))")
                await MainActor.run {
                    session.invalidate(errorMessage: self.strings.nfcReadingError)
                }
                return
            }
        }
    }
}

private struct GenericNFCTag {
    enum CardType {
        case miFare(NFCMiFareTag)
        case iso7816(NFCISO7816Tag)
    }
    var card: CardType

    init?(tag: NFCTag) {
        switch tag {
        case .miFare(let emeal):
            self.card = .miFare(emeal)
        case .iso7816(let campuscard):
            self.card = .iso7816(campuscard)
        default:
            return nil
        }
    }

    var id: Int {
        var idData = {
            switch card {
            case .miFare(let tag):
                return tag.identifier
            case .iso7816(let tag):
                return tag.identifier
            }
        }()
        if idData.count == 7 {
            idData.append(UInt8(0))
        }
        return idData.withUnsafeBytes {
            $0.load(as: Int.self)
        }
    }

    private static var APP_ID: Int { 0x5F8415 }
    private static var FILE_ID: UInt8 { 1 }

    func readTag() async throws -> (Double, Double) {
        await selectApp()
        let currentBalance = try await readCurrentBalance()
        Logger.emealKitNFC.info("Read current balance: \(currentBalance, privacy: .sensitive)")
        let lastTransaction = try await readLastTransaction()
        Logger.emealKitNFC.info("Read last transaction: \(lastTransaction, privacy: .sensitive)")
        return (currentBalance, lastTransaction)
    }

    private func send(_ data: Data) async throws -> Data {
        switch card {
        case .miFare(let miFareTag):
            return try await miFareTag.send(data: data)
        case .iso7816(let iso7816Tag):
            return try await iso7816Tag.send(data: data)
        }
    }

    private func selectApp() async {
        var appIdBuffer: [Int] = []
        appIdBuffer.append((Self.APP_ID & 0xFF0000) >> 16)
        appIdBuffer.append((Self.APP_ID & 0xFF00) >> 8)
        appIdBuffer.append(Self.APP_ID & 0xFF)
        let appIdByteArray = [UInt8(appIdBuffer[0]), UInt8(appIdBuffer[1]), UInt8(appIdBuffer[2])]
        let selectAppData = Command.selectApp.wrapped(including: appIdByteArray).data()
        _ = try? await send(selectAppData)
    }

    private func readCurrentBalance() async throws -> Double {
        let readValueData = Command.readValue.wrapped(including: [Self.FILE_ID]).data()
        var currentBalanceData = try await send(readValueData)
        currentBalanceData.removeLast()
        currentBalanceData.removeLast()
        currentBalanceData.reverse()
        let currentBalance = [UInt8](currentBalanceData).byteArrayToInt()
        return currentBalance.intToEuro()
    }

    private func readLastTransaction() async throws -> Double {
        let readLastTransactionData = Command.readLastTransaction.wrapped(including: [Self.FILE_ID]).data()
        let lastTransRawBuf = try await send(readLastTransactionData)
        let lastTransBuf = [UInt8](lastTransRawBuf)
        if lastTransBuf.count > 13 {
            let lastTransaction = [lastTransBuf[13], lastTransBuf[12]].byteArrayToInt()
            return lastTransaction.intToEuro()
        }
        return 0.0
    }
}

private enum Command {
    static let selectApp: UInt8 = 0x5a
    static let readValue: UInt8 = 0x6c
    static let readLastTransaction: UInt8 = 0xf5
}

fileprivate extension UInt8 {
    func wrapped(including parameter: [UInt8]?) -> [UInt8] {
        var buff: [UInt8] = []
        buff.append(0x90)
        buff.append(self)
        buff.append(0x00)
        buff.append(0x00)
        if parameter != nil {
            buff.append(UInt8(parameter!.count))
            for p in parameter! {
                buff.append(p)
            }
        }
        buff.append(0x00)
        return buff
    }
}

fileprivate extension NFCMiFareTag {
    func send(data: Data) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            sendMiFareCommand(commandPacket: data) { result in
                continuation.resume(with: result)
            }
        }
    }
}

fileprivate extension NFCISO7816Tag {
    func send(data: Data) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            sendCommand(apdu: .init(data: data)!) { data, sw1, sw2, error in
                guard error == nil else {
                    continuation.resume(throwing: error!)
                    return
                }
                continuation.resume(returning: data)
            }
        }
    }
}

fileprivate extension Array where Element == UInt8 {
    func byteArrayToInt() -> Int {
        var rawValue = 0
        for byte in self {
            rawValue = rawValue << 8
            rawValue = rawValue | Int(byte)
        }
        return rawValue
    }

    func data() -> Data {
        return Data(_: self)
    }
}

fileprivate extension Int {
    func intToEuro() -> Double {
        (Double(self) / 1000).rounded(toPlaces: 2)
    }
}

fileprivate extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
#endif
