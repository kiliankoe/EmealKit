/// `Emeal` calls its delegate on the main actor.
@MainActor
public protocol EmealDelegate: AnyObject {
    func invalidate(with error: Error)
    func readData(currentBalance: Double, lastTransaction: Double)
}
