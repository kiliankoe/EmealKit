import Foundation

#if canImport(CoreLocation)
import CoreLocation
#endif

public struct Canteen: Identifiable, Equatable, Decodable {
    public var id: Int
    public var name: String
    public var city: String
    public var address: String
    public var coordinates: [Double]
    public var url: URL
    public var menu: URL
    public var openingHours: OpeningHours?

    #if canImport(CoreLocation)
    public var location: CLLocation? {
        guard self.coordinates.count == 2 else { return nil }
        let coordinate = CLLocationCoordinate2D(latitude: coordinates[0], longitude: coordinates[1])
        return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    #endif

    public init(id: Int, name: String, city: String, address: String, coordinates: [Double], url: URL, menu: URL, openingHours: OpeningHours? = nil) {
        self.id = id
        self.name = name
        self.city = city
        self.address = address
        self.coordinates = coordinates
        self.url = url
        self.menu = menu
        self.openingHours = openingHours
    }
    
    // MARK: - Opening Hours Convenience Methods
    
    /// Check if the canteen is currently open
    public func isOpen(at date: Date = Date()) -> Bool {
        openingHours?.isOpen(at: date) ?? false
    }
    
    /// Get the time when the canteen closes (if currently open)
    public func closingTime(from date: Date = Date()) -> (Date?, String?)? {
        openingHours?.closingTime(from: date)
    }
    
    /// Get the time when the canteen opens next (if currently closed)
    public func openingTime(from date: Date = Date()) -> (Date?, String?)? {
        openingHours?.openingTime(from: date)
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
        case "uboot", "bio", "u-boot":
            return .bioMensaUBoot
        case "brühl", "bruehl", "hfbk":
            return .mensaBrühl
        case "görlitz", "goerlitz", "mio - mensa im osten", "im osten", "mio -  im osten", "mio":
            return .mensaGörlitz
        case "jotown", "ba", "alte fakultät", "johanna", "johannstadt":
            return .mensaJohannstadt
        case "palucca", "tanz", "palucca hochschule":
            return .mensaPaluccaHochschule
        case "reichenbach", "htw", "reiche", "club", "matrix":
            return .mensaReichenbachstraße
        case "siede", "siedepunkt", "drepunct", "drehpunkt", "siedepunct", "slub":
            return .mensaSiedepunkt
        case "stimmgabel", "stimm-gabel", "hfm", "musik", "musikhochschule":
            return .mensaStimmGabel
        case "tharandt", "tellerrand", "tellerrandt":
            return .mensaTellerRandt
        case "wu", "wu1", "wundtstraße", "wueins":
            return .mensaWUeinsSportsbar
        case "zelt", "schlösschen", "feldschlösschen", "zeltschlösschen":
            return .zeltschlösschen
        case "grill", "cube", "fresswürfel", "würfel", "wuerfel", "burger", "grillcube":
            return .grillCube
        case "mensologie":
            return .mensologie
        case "mahlwerk":
            return .mensaMahlwerk
        case "kraatschn":
            return .mensaZittau
        default:
            return nil
        }
    }
}
