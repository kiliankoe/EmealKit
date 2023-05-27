import Foundation
import os.log

#if canImport(Combine)
import Combine
#endif

internal extension URL {
    enum Mensa {
        static let baseUrl = URL(string: "https://api.studentenwerk-dresden.de/openmensa/v2/")!
        static let canteens = URL(string: "canteens/", relativeTo: Self.baseUrl)!
        static func meals(canteen: Int, date: Date) -> URL {
            URL(string: "\(canteen)/days/\(date.yearMonthDay)/meals", relativeTo: Self.canteens)!
        }
    }
}

extension URLSession {
    fileprivate func emealDataTask(with url: URL, completion: @escaping (Result<Data, EmealError>) -> Void) {
        let task = self.dataTask(with: url) { data, response, error in
            guard
                let data = data,
                error == nil
            else {
                if let urlError = error {
                    completion(.failure(.other(urlError)))
                    return
                }
                completion(.failure(.unknown))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}

// MARK: - Canteens

extension Canteen {
    public static func all(session: URLSession = .shared,
                           completion: @escaping (Result<[Canteen], EmealError>) -> Void) {
        Logger.emealKit.debug("Creating data task for all canteens")
        session.emealDataTask(with: URL.Mensa.canteens) { result in
            switch result {
            case .failure(let error):
                Logger.emealKit.error("Failed to fetch canteen data: \(String(describing: error))")
                completion(.failure(error))
            case .success(let data):
                do {
                    let canteens = try JSONDecoder().decode([Canteen].self, from: data)
                    Logger.emealKit.debug("Successfully fetched \(canteens.count) canteens")
                    completion(.success(canteens))
                } catch let error {
                    Logger.emealKit.error("Failed to decode Canteen data: \(String(describing: error))")
                    completion(.failure(.other(error)))
                }
            }
        }
    }

    @available(macOS 12.0, iOS 15.0, *)
    public static func all(session: URLSession = .shared) async throws -> [Canteen] {
        try await withCheckedThrowingContinuation { continuation in
            Self.all(session: session) { result in
                continuation.resume(with: result)
            }
        }
    }
}

#if canImport(Combine)
extension Canteen {
    public static func allPublisher(session: URLSession = .shared) -> AnyPublisher<[Canteen], EmealError> {
        session.dataTaskPublisher(for: URL.Mensa.canteens)
            .map { $0.data }
            .decode(type: [Canteen].self, decoder: JSONDecoder())
            .mapError { EmealError.other($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
#endif

// MARK: - Meals

extension Meal {
    public static func `for`(canteen: CanteenId,
                             on date: Date,
                             session: URLSession = .shared,
                             completion: @escaping (Result<[Meal], EmealError>) -> Void) {
        Self.for(canteen: canteen.rawValue, on: date, session: session, completion: completion)
    }

    public static func `for`(canteen: Int,
                             on date: Date,
                             session: URLSession = .shared,
                             completion: @escaping (Result<[Meal], EmealError>) -> Void) {
        Logger.emealKit.debug("Creating data task for canteen \(canteen) on \(date)")
        session.emealDataTask(with: URL.Mensa.meals(canteen: canteen, date: date)) { result in
            switch result {
            case .failure(let error):
                Logger.emealKit.error("Failed to fetch meal data: \(String(describing: error))")
                completion(.failure(error))
            case .success(let data):
                do {
                    let meals = try JSONDecoder().decode([Meal].self, from: data)
                    Logger.emealKit.debug("Successfully fetched \(meals.count) meals")
                    completion(.success(meals))
                } catch let error {
                    Logger.emealKit.error("Failed to decode meal data: \(String(describing: error))")
                    completion(.failure(.other(error)))
                }
            }
        }
    }

    @available(macOS 12.0, iOS 15.0, *)
    public static func `for`(canteen: CanteenId, on date: Date, session: URLSession = .shared) async throws -> [Meal] {
        try await Self.for(canteen: canteen.rawValue, on: date, session: session)
    }

    @available(macOS 12.0, iOS 15.0, *)
    public static func `for`(canteen: Int, on date: Date, session: URLSession = .shared) async throws -> [Meal] {
        try await withCheckedThrowingContinuation { continuation in
            Self.for(canteen: canteen, on: date, session: session) { result in
                continuation.resume(with: result)
            }
        }
    }
}

#if canImport(Combine)
extension Meal {
    public static func publisherFor(canteen: Int,
                                    on date: Date,
                                    session: URLSession = .shared) -> AnyPublisher<[Meal], EmealError> {
        session.dataTaskPublisher(for: URL.Mensa.meals(canteen: canteen, date: date))
            .map { $0.data }
            .decode(type: [Meal].self, decoder: JSONDecoder())
            .mapError { EmealError.other($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    public static func publisherFor(canteen: CanteenId,
                                    on date: Date,
                                    session: URLSession = .shared) -> AnyPublisher<[Meal], EmealError> {
        Self.publisherFor(canteen: canteen.rawValue, on: date, session: session)
    }
}
#endif
