#if canImport(CoreNFC)
import Foundation
import CoreNFC

// Huge thanks to Georg Sieber for a reference implementation of this at https://github.com/schorschii/MensaGuthaben-iOS

public class Emeal: NSObject, NFCTagReaderSessionDelegate {
    private static var APP_ID: Int = 0x5F8415
    private static var FILE_ID: UInt8 = 1

    private var cardID: Int = 0
    private var readerSession: NFCTagReaderSession?

    private var strings: LocalizedEmealStrings
    public weak var delegate: EmealDelegate?

    public init(localizedStrings: LocalizedEmealStrings) {
        self.strings = localizedStrings
    }

    /// Begin the NFC reading session prompting the user to hold their device to their card.
    public func beginNFCSession() {
        readerSession = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
        readerSession?.alertMessage = strings.alertMessage
        readerSession?.begin()
    }

    public func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {}

    public func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        readerSession = nil
        DispatchQueue.main.async {
            self.delegate?.invalidate(with: error)
        }
    }

    public func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        guard let tag = tags.first else {
            session.invalidate(errorMessage: strings.nfcReadingError)
            return
        }
        Task {
            do {
                try await session.connect(to: tag)
            } catch {
                session.invalidate(errorMessage: self.strings.nfcConnectionError)
                print("Failed to connect to NFC tag: \(error)")
                return
            }
            guard case .miFare(let miFareTag) = tag else {
                session.invalidate(errorMessage: self.strings.nfcConnectionError)
                print("NFC tag is not a miFareTag")
                return
            }

            var appIdBuffer: [Int] = []
            appIdBuffer.append ((Self.APP_ID & 0xFF0000) >> 16)
            appIdBuffer.append ((Self.APP_ID & 0xFF00) >> 8)
            appIdBuffer.append (Self.APP_ID & 0xFF)
            let appIdByteArray = [UInt8(appIdBuffer[0]), UInt8(appIdBuffer[1]), UInt8(appIdBuffer[2])]
            let selectAppData = Command.selectApp.wrapped(including: appIdByteArray).data()
            _ = try? await miFareTag.send(data: selectAppData)

            var currentBalanceData: Data
            do {
                let readValueData = Command.readValue.wrapped(including: [Self.FILE_ID]).data()
                currentBalanceData = try await miFareTag.send(data: readValueData)
            } catch {
                session.invalidate(errorMessage: self.strings.nfcReadingError)
                print("Failed to read data from result on readValueData: \(error)")
                return
            }
            currentBalanceData.removeLast()
            currentBalanceData.removeLast()
            currentBalanceData.reverse()
            let currentBalanceRaw = [UInt8](currentBalanceData).byteArrayToInt()
            let currentBalance = currentBalanceRaw.intToEuro()

            var lastTransRawBuf: Data
            do {
                let readLastTransactionData = Command.readLastTransaction.wrapped(including: [Self.FILE_ID]).data()
                lastTransRawBuf = try await miFareTag.send(data: readLastTransactionData)
            } catch {
                session.invalidate(errorMessage: self.strings.nfcReadingError)
                print("Failed to read data from result on readLastTransactionData: \(error)")
                return
            }
            let lastTransBuf = [UInt8](lastTransRawBuf)
            if lastTransBuf.count > 13 {
                let lastTransRaw = [lastTransBuf[13], lastTransBuf[12]].byteArrayToInt()
                let lastTransaction = lastTransRaw.intToEuro()
                await MainActor.run {
                    self.delegate?.readData(currentBalance: currentBalance, lastTransaction: lastTransaction)
                }
            }
            session.invalidate()
        }
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
    @available(iOS 15.0, *)
    func send(data: Data) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            sendMiFareCommand(commandPacket: data) { result in
                continuation.resume(with: result)
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
