import Foundation

#if canImport(CoreLocation)
import CoreLocation
#endif

public struct Canteen: Identifiable, Decodable {
    public var id: Int
    public var name: String
    public var city: String
    public var address: String
    public var coordinates: [Double]
    public var url: URL
    public var menu: URL

    #if canImport(CoreLocation)
    public var coordinate: CLLocationCoordinate2D? {
        guard self.coordinates.count == 2 else { return nil }
        return CLLocationCoordinate2D(latitude: coordinates[0], longitude: coordinates[1])
    }

    public var location: CLLocation? {
        guard let coordinate = self.coordinate else { return nil }
        return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    #endif

    public init(id: Int, name: String, city: String, address: String, coordinates: [Double], url: URL, menu: URL) {
        self.id = id
        self.name = name
        self.city = city
        self.address = address
        self.coordinates = coordinates
        self.url = url
        self.menu = menu
    }
}

public enum CanteenId: Int, CaseIterable {
    case alteMensa = 4
    case mensaReichenbachstraße = 6
    case mensologie = 8
    case mensaSiedepunkt = 9
    case mensaTellerRandt = 10
    case mensaPaluccaHochschule = 11
    case mensaStimmGabel = 13
    case mensaZittau = 24
    case mensaMahlwerk = 25
    case mensaGörlitz = 28
    case bioMensaUBoot = 29
    case mensaSport = 30
    case mensaJohannstadt = 32
    case mensaWUeinsSportsbar = 33
    case mensaBrühl = 34
    case zeltschlösschen = 35
    case grillCube = 36
    case pastaMobil = 37
    case mensaRothenburg = 38
    case mensaBautzenPolizeihochschule = 39
    case mensaBautzenStudienakademie = 42

    /// Normalize some common aliases.
    public static func from(name: String) -> CanteenId? {
        let name = name
            .lowercased()
            .replacingAll(matching: "mensa", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        switch name {
        case "alte", "mommsa", "brat2", "bratquadrat":
            return .alteMensa
        case "uboot", "bio":
            return .bioMensaUBoot
        case "brühl", "bruehl", "hfbk":
            return .mensaBrühl
        case "görlitz", "goerlitz":
            return .mensaGörlitz
        case "jotown", "ba", "alte fakultät":
            return .mensaJohannstadt
        case "palucca", "tanz":
            return .mensaPaluccaHochschule
        case "reichenbach", "htw", "reiche", "club":
            return .mensaReichenbachstraße
        case "siede", "siedepunkt", "drepunct", "drehpunkt", "siedepunct", "slub":
            return .mensaSiedepunkt
        case "stimmgabel", "hfm", "musik", "musikhochschule":
            return .mensaStimmGabel
        case "tharandt", "tellerrand":
            return .mensaTellerRandt
        case "wu", "wu1", "wundtstraße":
            return .mensaWUeinsSportsbar
        case "zelt", "schlösschen", "feldschlösschen":
            return .zeltschlösschen
        case "grill", "cube", "fresswürfel", "würfel", "wuerfel", "burger", "grillcube":
            return .grillCube
        default:
            return nil
        }
    }
}
