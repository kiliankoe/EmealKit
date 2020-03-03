public protocol EmealDelegate: class {
    func invalidate(with error: Error)
    func readData(currentBalance: Double, lastTransaction: Double)
}
