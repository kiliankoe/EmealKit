import Foundation

public enum Mensa {
    public static let alteMensa = "Alte Mensa"
    public static let bruehl = "Mensa Brühl"
    public static let grillCube = "Grill Cube"
    public static let goerlitz = "Mensa Görlitz"
    public static let johannstadt = "Mensa Johannstadt"
    public static let kindertagesstaetten = "Kindertagesstätten"
    public static let kreuzgymnasium = "Mensa Kreuzgymnasium"
    public static let mensologie = "Mensologie"
    public static let paluccaHochschule = "Mensa Palucca Hochschule"
    public static let reichenbachstrasse = "Mensa Reichenbachstraße"
    public static let siedepunkt = "Mensa Siedepunkt"
    public static let sport = "Mensa Sport"
    public static let stimmGabel = "Mensa Stimm-Gabel"
    public static let tellerRandt = "Mensa TellerRandt"
    public static let uBoot = "BioMensa U-Boot"
    public static let wuEins = "Mensa WUeins"
    public static let zeltschloesschen = "Zeltschlösschen"
    public static let zittau = "Mensa Zittau"

    static func id(for mensa: String) -> Int? {
        switch mensa {
        case Mensa.alteMensa: return 18
        case Mensa.bruehl: return 34
        case Mensa.grillCube: return 46
        case Mensa.goerlitz: return 15
        case Mensa.johannstadt: return 32
        case Mensa.kindertagesstaetten: return 21
        case Mensa.kreuzgymnasium: return 20
        case Mensa.mensologie: return 5
        case Mensa.paluccaHochschule: return 14
        case Mensa.reichenbachstrasse: return 9
        case Mensa.siedepunkt: return 6
        case Mensa.sport: return 19
        case Mensa.stimmGabel: return 13
        case Mensa.tellerRandt: return 7
        case Mensa.uBoot: return 22
        case Mensa.wuEins: return 33
        case Mensa.zeltschloesschen: return 35
        case Mensa.zittau: return 1
        default: return nil
        }
    }

    /// Normalize common aliases.
    public static func from(name: String) -> String {
        switch name.lowercased() {
        case "alte", "mensa", "mommsa", "brat2", "bratquadrat":
            return Mensa.alteMensa
        case "uboot", "bio", "biomensa":
            return Mensa.uBoot
        case "brühl", "hfbk":
            return Mensa.bruehl
        case "görlitz":
            return Mensa.goerlitz
        case "jotown", "ba", "alte fakultät":
            return Mensa.johannstadt
        case "palucca", "tanz":
            return Mensa.paluccaHochschule
        case "reichenbach", "htw", "reiche", "club mensa":
            return Mensa.reichenbachstrasse
        case "siede", "siedepunkt", "drepunct", "drehpunkt", "siedepunct", "slub":
            return Mensa.siedepunkt
        case "stimmgabel", "hfm", "musik", "musikhochschule":
            return Mensa.stimmGabel
        case "tharandt", "tellerrand":
            return Mensa.tellerRandt
        case "wu", "wu1", "wundtstraße":
            return Mensa.wuEins
        case "zelt", "zeltmensa", "schlösschen", "feldschlösschen", "neue":
            return Mensa.zeltschloesschen
        case "grill", "cube", "fresswürfel", "würfel", "burger", "grillcube":
            return Mensa.grillCube
        default:
            return name
        }
    }
}
