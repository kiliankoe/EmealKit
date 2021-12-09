import XCTest
import EmealKit
import CoreLocation

class CanteenTests: XCTestCase {
    @available(macOS 12.0, iOS 15.0, *)
    func testMockFetchAndDecode() async throws {
        let canteens = try await Canteen.all(session: MockURLSession(mockData: .canteens))
        XCTAssertEqual(canteens.count, 21)
    }

    func testLocation() {
        let noCoordinates = Canteen(id: 0, name: "", city: "", address: "",
                                    coordinates: [], url: URL(string: "q")!, menu: URL(string: "q")!)
        XCTAssertNil(noCoordinates.location)

        let alteMensa = Canteen(id: 0, name: "", city: "", address: "",
                                coordinates: [51.026, 13.724],
                                url: URL(string: "q")!, menu: URL(string: "q")!)
        XCTAssertEqual(alteMensa.location?.coordinate.latitude, 51.026)
        XCTAssertEqual(alteMensa.location?.coordinate.longitude, 13.724)
    }
}
