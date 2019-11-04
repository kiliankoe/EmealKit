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
        public let student: Double
        public let employee: Double
    }

    public static func fetch(session: URLSession = .shared,
                             completion: @escaping (Result<[Meal], EKError>) -> Void) {
        // TODO: Use Network instead
        session.dataTask(with: URL.mensaPlan) { data, _, _ in
            guard let data = data else {
                completion(.failure(.network(nil)))
                return
            }
            FeedParser(data: data) { result in
                completion(result)
            }
        }.resume()
    }
    
    public static func fetch(forMensa mensa: Mensa,
                             session: URLSession = .shared,
                             completion: @escaping (Result<[Meal], EKError>) -> Void) {
        Meal.fetch(forMensaName: mensa.name, session: session, completion: completion)
    }

    public static func fetch(forMensaName mensa: String,
                             session: URLSession = .shared,
                             completion: @escaping (Result<[Meal], EKError>) -> Void) {
        Meal.fetch(session: session) { result in
            guard let meals = try? result.get() else {
                completion(result)
                return
            }

            let filteredMeals = meals.filter { $0.mensa == mensa }
            completion(.success(filteredMeals))
        }
    }

    private static let pricesRgx = try! NSRegularExpression(pattern: "(\\d+.\\d+)")
    private static let idRgx = try! NSRegularExpression(pattern: "details-(\\d+).html")

    init?(from dict: [String: String]) {
        guard
            let title = dict["title"],
            let urlStr = dict["link"],
            let url = URL(string: urlStr),
            let mensa = dict["author"]
        else {
            return nil
        }

        self.id = Meal.idRgx.match(in: urlStr) ?? ""

        self.mensa = mensa

        if let _ = title.range(of: " \\(.*\\)", options: .regularExpression) {
            let prices = Meal.pricesRgx.matches(in: title)
                .compactMap(Double.init)

            if prices.count == 1 {
                self.price = Price(student: prices[0], employee: prices[0])
            } else if prices.count == 2 {
                self.price = Price(student: prices[0], employee: prices[1])
            } else {
                self.price = nil
            }

            let titleWithoutPrice = title.replacingOccurrences(of: " \\(.*\\)", with: "", options: .regularExpression)
            self.name = titleWithoutPrice
        } else {
            self.price = nil
            self.name = title
        }

        self.url = url

        if let mensaID = Mensa.id(for: self.mensa) {
            self.imageURL = Meal.imageURL(for: Date(), mensaID: mensaID, mealID: self.id)
        } else {
            self.imageURL = nil
        }

        self.isSoldOut = title.contains("ausverkauft")
    }

    static func imageURL(for date: Date, mensaID: Int, mealID: String) -> URL? {
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        return URL(string: "https://bilderspeiseplan.studentenwerk-dresden.de/m\(mensaID)/\(year)\(month)/thumbs/\(mealID).jpg")
    }
}
