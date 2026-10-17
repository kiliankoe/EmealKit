#if canImport(CoreNFC) && canImport(Observation)
import Observation

@available(iOS 17, macOS 14, watchOS 10, tvOS 17, *)
@MainActor
@Observable
public final class ObservableEmeal: EmealDelegate {
    public private(set) var currentBalance: Double?
    public private(set) var lastTransaction: Double?
    public private(set) var error: Error?

    public func readData(currentBalance: Double, lastTransaction: Double) {
        self.currentBalance = currentBalance
        self.lastTransaction = lastTransaction
        self.error = nil
    }

    public func invalidate(with error: Error) {
        self.error = error
    }

    @ObservationIgnored private let emeal: Emeal

    public init(localizedStrings: LocalizedEmealStrings) {
        emeal = Emeal(localizedStrings: localizedStrings)
        emeal.delegate = self
    }

    /// Begin the NFC reading session prompting the user to hold their device to their card.
    public func beginNFCSession() {
        emeal.beginNFCSession()
    }
}
#endif
