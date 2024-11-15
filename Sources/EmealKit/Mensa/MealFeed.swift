import Foundation
import FeedKit
import os.log

extension Meal {
    public struct RSSMeal {
        public let title: String
        public let description: String
        public let guid: String
        public let link: String
        public let author: String

        func matches(meal: Meal) -> Bool {
            return link.contains(String(meal.id))
        }

        var isSoldOut: Bool {
            title.lowercased().contains("ausverkauft")
        }
    }

    public static func rssData() async throws -> [RSSMeal] {
        let feedURL = URL(string: "https://www.studentenwerk-dresden.de/feeds/speiseplan.rss")!
        let parser = FeedParser(URL: feedURL)
        return try await withCheckedThrowingContinuation { continuation in
            parser.parseAsync { result in
                switch result {
                case .success(let feed):
                    guard (feed.rssFeed?.title?.contains("von heute") ?? false) else {
                        Logger.emealKit.error("Wrong feed?")
                        continuation.resume(returning: [])
                        return
                    }
                    guard let items = feed.rssFeed?.items else {
                        Logger.emealKit.error("No feed items found")
                        continuation.resume(returning: [])
                        return
                    }
                    let meals = items.compactMap { item -> RSSMeal? in
                        guard let title = item.title,
                              let description = item.description,
                              let guid = item.guid?.value,
                              let link = item.link,
                              let author = item.author
                        else {
                            return nil
                        }
                        return RSSMeal(
                            title: title,
                            description: description,
                            guid: guid,
                            link: link,
                            author: author
                        )
                    }
                    continuation.resume(returning: meals)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
