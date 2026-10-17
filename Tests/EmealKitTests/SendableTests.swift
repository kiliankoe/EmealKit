import XCTest
import EmealKit

/// Fails to compile if a public model type loses its `Sendable` conformance.
class SendableTests: XCTestCase {
    private func assertSendable<T: Sendable>(_: T.Type) {}

    func testModelTypesAreSendable() {
        assertSendable(Meal.self)
        assertSendable(Meal.Prices.self)
        assertSendable(Diet.self)
        assertSendable(Ingredient.self)
        assertSendable(Allergen.self)
        assertSendable(Canteen.self)
        assertSendable(CanteenId.self)
        assertSendable(OpeningHours.self)
        assertSendable(OpeningHours.TimeSlot.self)
        assertSendable(OpeningHours.DateRange.self)
        assertSendable(OpeningHours.WeekdayHours.self)
        assertSendable(OpeningHours.TimeOfDay.self)
        assertSendable(OpeningHours.ServiceStatus.self)
        assertSendable(OpeningHours.Weekday.self)
        assertSendable(Cardservice.self)
        assertSendable(CardData.self)
        assertSendable(Transaction.self)
        assertSendable(Transaction.Position.self)
        assertSendable(Transaction.Kind.self)
        assertSendable(LocalizedEmealStrings.self)
    }
}
