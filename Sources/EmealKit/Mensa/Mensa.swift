import Foundation

public struct Mensa {
    public let name: String
    public let id: Int?

    public static let alteMensa = Mensa(name: "Alte Mensa", id: 18)
    public static let bruehl = Mensa(name: "Mensa Brühl", id: 34)
    public static let grillCube = Mensa(name: "Grill Cube", id: 46)
    public static let goerlitz = Mensa(name: "Mensa Görlitz", id: 15)
    public static let johannstadt = Mensa(name: "Mensa Johannstadt", id: 32)
    public static let kindertagesstaetten = Mensa(name: "Kindertagesstätten", id: 21)
    public static let kreuzgymnasium = Mensa(name: "Mensa Kreuzgymnasium", id: 20)
    public static let mensologie = Mensa(name: "Mensologie", id: 5)
    public static let paluccaHochschule = Mensa(name: "Mensa Palucca Hochschule", id: 14)
    public static let reichenbachstrasse = Mensa(name: "Mensa Reichenbachstraße", id: 9)
    public static let siedepunkt = Mensa(name: "Mensa Siedepunkt", id: 6)
    public static let sport = Mensa(name: "Mensa Sport", id: 19)
    public static let stimmGabel = Mensa(name: "Mensa Stimm-Gabel", id: 13)
    public static let tellerRandt = Mensa(name: "Mensa TellerRandt", id: 7)
    public static let uBoot = Mensa(name: "BioMensa U-Boot", id: 22)
    public static let wuEins = Mensa(name: "Mensa WUeins", id: 33)
    public static let zeltschloesschen = Mensa(name: "Zeltschlösschen", id: 35)
    public static let zittau = Mensa(name: "Mensa Zittau", id: 1)

    public static let all = [alteMensa, bruehl, grillCube, goerlitz, johannstadt, kindertagesstaetten, kreuzgymnasium, mensologie, paluccaHochschule, reichenbachstrasse, siedepunkt, sport, stimmGabel, tellerRandt, uBoot, wuEins, zeltschloesschen, zittau]

    static func id(for mensa: String) -> Int? {
        return all
            .filter { $0.name.lowercased() == mensa.lowercased() }
            .first?
            .id
    }

    /// Normalize common aliases.
    public static func from(name: String) -> Mensa {
        if let mensa = all.filter({ $0.name.lowercased() == name.lowercased() }).first {
            return mensa
        }

        switch name.lowercased() {
        case "alte", "mensa", "mommsa", "brat2", "bratquadrat":
            return alteMensa
        case "uboot", "bio", "biomensa":
            return uBoot
        case "brühl", "bruehl", "hfbk":
            return bruehl
        case "görlitz", "goerlitz":
            return goerlitz
        case "jotown", "ba", "alte fakultät":
            return johannstadt
        case "palucca", "tanz":
            return paluccaHochschule
        case "reichenbach", "htw", "reiche", "club mensa":
            return reichenbachstrasse
        case "siede", "siedepunkt", "drepunct", "drehpunkt", "siedepunct", "slub":
            return siedepunkt
        case "stimmgabel", "hfm", "musik", "musikhochschule":
            return stimmGabel
        case "tharandt", "tellerrand":
            return tellerRandt
        case "wu", "wu1", "wundtstraße":
            return wuEins
        case "zelt", "zeltmensa", "schlösschen", "feldschlösschen", "neue":
            return zeltschloesschen
        case "grill", "cube", "fresswürfel", "würfel", "wuerfel", "burger", "grillcube":
            return grillCube
        default:
            return Mensa(name: name, id: nil)
        }
    }
}
