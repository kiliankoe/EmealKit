#if canImport(CoreNFC)
#if canImport(Combine)
import Combine

public class ObservableEmeal: ObservableObject, EmealDelegate {
    @Published public var currentBalance: Double?
    @Published public var lastTransaction: Double?

    public func readData(currentBalance: Double, lastTransaction: Double) {
        self.currentBalance = currentBalance
        self.lastTransaction = lastTransaction
    }

    @Published var error: Error?

    public func invalidate(with error: Error) {
        self.error = error
    }

    private var emeal: Emeal

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
#endif
