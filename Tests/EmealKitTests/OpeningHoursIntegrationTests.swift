import XCTest
@testable import EmealKit

/// Integration test for opening hours scraping - compares with actual website
/// Run this manually to validate against https://www.studentenwerk-dresden.de/mensen/oeffnungszeiten.html
final class OpeningHoursIntegrationTests: XCTestCase {
    
    func testFetchAndParseRealOpeningHours() async throws {
        print("\n=== Opening Hours Integration Test ===\n")
        print("Fetching from: https://www.studentenwerk-dresden.de/mensen/oeffnungszeiten.html\n")
        
        let openingHoursList = try await OpeningHoursScraper.fetchOpeningHours()
        
        print("Found opening hours for \(openingHoursList.count) canteens\n")
        
        // Sort by canteen name for easier comparison
        let sortedCanteens = openingHoursList.sorted { $0.canteenName < $1.canteenName }
        
        for canteen in sortedCanteens {
            print("\n📍 \(canteen.canteenName)")
            
            // Show regular hours
            if !canteen.regularHours.isEmpty {
                print("\n   Regular Hours:")
                for timeSlot in canteen.regularHours {
                    print("      \(timeSlot.area):")
                    
                    if !timeSlot.parsedHours.isEmpty {
                        for schedule in timeSlot.parsedHours {
                            let daysStr = formatDays(schedule.days)
                            let timeStr = "\(schedule.openTime.formatted) - \(schedule.closeTime.formatted)"
                            
                            if let label = schedule.label {
                                print("         \(daysStr): \(timeStr) (\(label))")
                            } else {
                                print("         \(daysStr): \(timeStr)")
                            }
                        }
                    } else {
                        print("         \(timeSlot.hoursText)")
                    }
                }
            }
            
            // Show changed hours
            if !canteen.changedHours.isEmpty {
                print("\n   Changed Hours:")
                for timeSlot in canteen.changedHours {
                    print("      \(timeSlot.area):")
                    
                    if let dateRange = timeSlot.dateRange {
                        print("         📅 \(dateRange.text) [\(dateRange.from?.dayMonthYear) -> \(dateRange.to?.dayMonthYear)]")
                    }
                    
                    if !timeSlot.parsedHours.isEmpty {
                        for schedule in timeSlot.parsedHours {
                            let daysStr = formatDays(schedule.days)
                            let timeStr = "\(schedule.openTime.formatted) - \(schedule.closeTime.formatted)"
                            
                            if let label = schedule.label {
                                print("         \(daysStr): \(timeStr) (\(label))")
                            } else {
                                print("         \(daysStr): \(timeStr)")
                            }
                        }
                    } else {
                        print("         \(timeSlot.hoursText)")
                    }
                }
            }
            
            if canteen.regularHours.isEmpty && canteen.changedHours.isEmpty {
                print("   No opening hours data")
            }
        }
        
        print("\n✅ Compare the output above with the website!")
        print("   URL: https://www.studentenwerk-dresden.de/mensen/oeffnungszeiten.html\n")
    }
    
    // MARK: - Helpers
    
    private func formatDays(_ days: Set<OpeningHours.Weekday>) -> String {
        let sorted = days.sorted { $0.rawValue < $1.rawValue }
        
        // Try to detect ranges
        if let range = detectRange(sorted) {
            return range
        }
        
        // Otherwise, comma-separated
        return sorted.map { $0.rawValue }.joined(separator: ", ")
    }
    
    private func detectRange(_ days: [OpeningHours.Weekday]) -> String? {
        guard days.count >= 2 else {
            return days.first?.rawValue
        }
        
        let allDays = OpeningHours.Weekday.allCases
        
        // Check if consecutive
        var indices: [Int] = []
        for day in days {
            if let idx = allDays.firstIndex(of: day) {
                indices.append(idx)
            }
        }
        
        indices.sort()
        
        // Check if consecutive
        var isConsecutive = true
        for i in 1..<indices.count {
            if indices[i] != indices[i-1] + 1 {
                isConsecutive = false
                break
            }
        }
        
        if isConsecutive {
            let first = allDays[indices.first!]
            let last = allDays[indices.last!]
            return "\(first.rawValue) - \(last.rawValue)"
        }
        
        return nil
    }
}
