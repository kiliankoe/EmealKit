import XCTest
import EmealKit
import CoreLocation

class CanteenTests: XCTestCase {
    func testFetch() {
        let e = expectation(description: "fetch canteen data")

        Canteen.all(session: MockURLSession(mockData: .canteens)) { result in
            defer { e.fulfill() }
            XCTAssertNotNil(try? result.get(), "Expected canteen data")
        }

        waitForExpectations(timeout: 1)
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
