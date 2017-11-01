import Foundation

public struct Meal {
    public let id: String
    public let name: String
    public let mensa: String
    public let price: Price?

    public let url: URL
    public let imageURL: URL?

    public let isSoldOut: Bool

    public struct Price {
        let student: Double?
        let employee: Double?
    }

    init?(from dict: [String: String]) {
        guard
            let title = dict["title"],
            let urlStr = dict["link"],
            let url = URL(string: urlStr),
            let mensa = dict["author"]
        else {
            return nil
        }

        self.id = ""
        self.name = title
        self.mensa = mensa
        self.price = nil
        self.url = url
        self.imageURL = nil
        self.isSoldOut = false
    }
}
