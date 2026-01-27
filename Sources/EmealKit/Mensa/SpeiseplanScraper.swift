import Foundation
import SwiftSoup
import os.log

struct SpeiseplanScraper {
    /// Fetches the Speiseplan page and extracts meal IDs that are sold out
    static func fetchSoldOutMealIds(session: URLSessionProtocol = URLSession.shared) async throws -> Set<Int> {
        let speiseplanURL = URL(string: "https://www.studentenwerk-dresden.de/mensen/speiseplan/")!
        
        Logger.emealKit.debug("Fetching Speiseplan page for sold out status")
        
        do {
            let (data, _) = try await session.data(from: speiseplanURL)
            guard let html = String(data: data, encoding: .utf8) else {
                Logger.emealKit.error("Failed to decode Speiseplan HTML")
                return []
            }
            
            return try parseSoldOutMeals(from: html)
        } catch {
            Logger.emealKit.error("Failed to fetch Speiseplan page: \(String(describing: error))")
            throw error
        }
    }
    
    /// Parses HTML content to extract sold out meal IDs
    static func parseSoldOutMeals(from html: String) throws -> Set<Int> {
        let document = try SwiftSoup.parse(html)
        var soldOutIds = Set<Int>()
        
        // Find all links to meal detail pages
        let links = try document.select("a[href*='speiseplan/details-']")
        
        for link in links {
            let href = try link.attr("href")
            
            // Extract meal ID from URL (format: details-329627.html)
            if let range = href.range(of: #"details-(\d+)\.html"#, options: .regularExpression),
               let idString = href[range].components(separatedBy: "-").last?.components(separatedBy: ".").first,
               let mealId = Int(idString) {
                
                // Check if this link's parent contains "ausverkauft"
                if let parent = link.parent() {
                    let parentHtml = try parent.html()
                    if parentHtml.lowercased().contains("ausverkauft") {
                        soldOutIds.insert(mealId)
                        Logger.emealKit.debug("Found sold out meal: \(mealId)")
                    }
                }
            }
        }
        
        Logger.emealKit.debug("Found \(soldOutIds.count) sold out meals")
        return soldOutIds
    }
}
