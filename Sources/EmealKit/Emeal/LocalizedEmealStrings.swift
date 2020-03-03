public struct LocalizedEmealStrings {
    let alertMessage: String
    let nfcReadingError: String
    let nfcConnectionError: String

    public init(alertMessage: String, nfcReadingError: String, nfcConnectionError: String) {
        self.alertMessage = alertMessage
        self.nfcReadingError = nfcReadingError
        self.nfcConnectionError = nfcConnectionError
    }
}
