import Foundation
import os.log

internal extension URL {
    enum Mensa {
        static let baseUrl = URL(string: "https://api.studentenwerk-dresden.de/openmensa/v2/")!
        static let canteens = URL(string: "canteens/", relativeTo: Self.baseUrl)!
        static func meals(canteen: Int, date: Date) -> URL {
            URL(string: "\(canteen)/days/\(date.yearMonthDay)/meals", relativeTo: Self.canteens)!
        }
    }
}

// MARK: - Canteens

extension Canteen {
    public static func all(session: URLSessionProtocol = URLSession.shared) async throws(EmealError) -> [Canteen] {
        Logger.emealKit.debug("Fetching all canteens")
        do {
            let (data, _) = try await session.data(from: URL.Mensa.canteens)
            print(String(data: data, encoding: .utf8)!)
            let canteens = try JSONDecoder().decode([Canteen].self, from: data)
            Logger.emealKit.debug("Successfully fetched \(canteens.count) canteens")
            return canteens
        } catch (let error) {
            Logger.emealKit.error("Failed to fetch canteen data: \(String(describing: error))")
            throw .other(error)
        }
    }
}

// MARK: - Meals

extension Meal {
    public static func `for`(canteen: Int, on date: Date, session: URLSessionProtocol = URLSession.shared) async throws(EmealError) -> [Meal] {
        Logger.emealKit.debug("Fetching meals for canteen \(canteen) on \(date)")
        do {
            let (data, _) = try await session.data(from: URL.Mensa.meals(canteen: canteen, date: date))
            let meals = try JSONDecoder().decode([Meal].self, from: data)
            Logger.emealKit.debug("Successfully fetched \(meals.count) meals")
            return meals
        } catch (let error) {
            Logger.emealKit.error("Failed to fetch meal data: \(String(describing: error))")
            throw .other(error)
        }
    }

    public static func `for`(canteen: CanteenId, on date: Date, session: URLSessionProtocol = URLSession.shared) async throws(EmealError) -> [Meal] {
        try await Self.for(canteen: canteen.rawValue, on: date, session: session)
    }
}
