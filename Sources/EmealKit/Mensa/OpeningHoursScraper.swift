import Foundation
import SwiftSoup
import os.log

struct OpeningHoursScraper {
    
    /// Fetches and parses opening hours from the official page
    static func fetchOpeningHours(session: URLSessionProtocol = URLSession.shared) async throws -> [OpeningHours] {
        let url = URL(string: "https://www.studentenwerk-dresden.de/mensen/oeffnungszeiten.html")!
        
        Logger.emealKit.debug("Fetching opening hours page")
        
        do {
            let (data, _) = try await session.data(from: url)
            guard let html = String(data: data, encoding: .utf8) else {
                Logger.emealKit.error("Failed to decode opening hours HTML")
                throw EmealError.unknown
            }
            
            return try parseOpeningHours(from: html)
        } catch {
            Logger.emealKit.error("Failed to fetch opening hours: \(String(describing: error))")
            throw error
        }
    }
    
    /// Parses HTML content to extract opening hours for all canteens
    static func parseOpeningHours(from html: String) throws -> [OpeningHours] {
        let document = try SwiftSoup.parse(html)
        var result: [OpeningHours] = []
        
        // Find all canteen cards
        let cards = try document.select("div.card")
        Logger.emealKit.debug("Found \(cards.count) canteen cards")
        
        for card in cards {
            if let openingHours = try? parseCanteenCard(card) {
                result.append(openingHours)
            }
        }
        
        Logger.emealKit.debug("Successfully parsed opening hours for \(result.count) canteens")
        return result
    }
    
    /// Parses a single canteen card
    private static func parseCanteenCard(_ card: Element) throws -> OpeningHours? {
        // Extract canteen name from header
        guard let headerElement = try card.select("h5.card-header").first(),
              let canteenName = try? headerElement.text().trimmingCharacters(in: .whitespaces),
              !canteenName.isEmpty else {
            Logger.emealKit.debug("Skipping card without valid header")
            return nil
        }
        
        Logger.emealKit.debug("Parsing opening hours for: \(canteenName)")
        
        var regularHours: [OpeningHours.TimeSlot] = []
        var changedHours: [OpeningHours.TimeSlot] = []
        
        // Find all h6 sections (could be regular or changed hours)
        let sections = try card.select("h6.h5")
        
        for section in sections {
            let sectionTitle = try section.text().lowercased()
            let isRegular = sectionTitle.contains("reguläre")
            
            // Find the table following this section
            guard let table = try section.nextElementSibling(),
                  table.tagName() == "table" else {
                Logger.emealKit.debug("No table found for section: \(sectionTitle)")
                continue
            }
            
            // Parse table rows
            let rows = try table.select("tr")
            for row in rows {
                let cells = try row.select("th, td")
                guard cells.count >= 3 else { continue }
                
                // Extract cell contents
                let area = try cells[0].text().trimmingCharacters(in: .whitespaces)
                let dateRangeText = try cells[1].text().trimmingCharacters(in: .whitespaces)
                let hoursText = try cells[2].text()
                    .replacingOccurrences(of: "\n", with: " ")
                    .replacingOccurrences(of: "  ", with: " ")
                    .trimmingCharacters(in: .whitespaces)
                
                // Parse date range if present
                var dateRange = dateRangeText.isEmpty ? nil : OpeningHoursParser.parseDateRange(dateRangeText)
                
                // Special handling for "Geschlossen vom..." cases where the date range might be in the area column
                // or split between columns.
                if (dateRange == nil || dateRange?.from == nil) {
                    // Try to parse from area text if it looks like a date range
                    if let areaRange = OpeningHoursParser.parseDateRange(area) {
                        // If area provided a full range (from & to), prefer it
                        if areaRange.from != nil && areaRange.to != nil {
                            dateRange = areaRange
                        }
                        // If area provided a start date (from) and we only had an end date (to), merge them?
                        // E.g. Area: "vom 02.02.", DateCol: "bis 03.02.26"
                        else if let areaFrom = areaRange.from, let existingTo = dateRange?.to, dateRange?.from == nil {
                            // Re-infer year since we're merging separate parses
                            let (fixedFrom, fixedTo) = OpeningHoursParser.inferYear(start: areaFrom, end: existingTo)
                            dateRange = OpeningHours.DateRange(from: fixedFrom, to: fixedTo, text: area + " " + dateRangeText)
                        }
                    }
                }
                
                // Parse hours text into structured data
                let parsedHours = OpeningHoursParser.parseHoursText(hoursText, label: area)
                
                // Create time slot
                let timeSlot = OpeningHours.TimeSlot(
                    area: area,
                    dateRange: dateRange,
                    hoursText: hoursText,
                    isRegular: isRegular,
                    parsedHours: parsedHours
                )
                
                if isRegular {
                    regularHours.append(timeSlot)
                } else {
                    changedHours.append(timeSlot)
                }
                
                Logger.emealKit.debug("  \(isRegular ? "Regular" : "Changed"): \(area) - \(parsedHours.count) parsed slots")
            }
        }
        
        return OpeningHours(
            canteenName: canteenName,
            regularHours: regularHours,
            changedHours: changedHours
        )
    }
}
