import Foundation
import HTMLString
import Regex

public struct Meal: Identifiable, Equatable, Decodable {
    public var id: Int
    public var name: String
    public var notes: [String]
    public var prices: Prices?
    public var category: String
    public var image: URL
    public var url: URL

    public var isSoldOut: Bool?

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case notes
        case prices
        case category
        case image
        case url
    }

    public struct Prices: Equatable, Decodable {
        public var students: Double
        public var employees: Double

        private enum CodingKeys: String, CodingKey {
            case students = "Studierende"
            case employees = "Bedienstete"

            // Apparently it can happen that a single canteen (in this case Mensa Johannstadt) has malformed pricing
            // keys. I'm guessing the system behind this is super janky and probably built on aggregated data formatted
            // by each canteen. I wouldn't want to support decoding completely random data, but depending on if this can
            // be fixed in the server API, making this colon-proof kinda makes sense. It's a symbol that makes sense as
            // a separator in the ingested data, so it might occur again.
            case colonStudents = "Studierende:"
            case colonEmployees = "Bedienstete:"
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let expectedStudentsValue = try? container.decodeIfPresent(Double.self, forKey: .students)
            let expectedEmployeesValue = try? container.decodeIfPresent(Double.self, forKey: .employees)

            if let esv = expectedStudentsValue, let eev = expectedEmployeesValue {
                self.students = esv
                self.employees = eev
                return
            }

            self.students = try container.decode(Double.self, forKey: .colonStudents)
            self.employees = try container.decode(Double.self, forKey: .colonEmployees)
        }

        public init(students: Double, employees: Double) {
            self.students = students
            self.employees = employees
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.notes = try container.decode([String].self, forKey: .notes)
            .map { $0.removingHTMLEntities }

        if let prices = try? container.decode(Prices.self, forKey: .prices) {
            self.prices = prices
        } else {
            self.prices = nil
        }

        self.category = try container.decode(String.self, forKey: .category)

        var imageURLString = try container.decode(String.self, forKey: .image)
        if imageURLString.hasPrefix("//") {
            imageURLString = "https:" + imageURLString
        }
        self.image = URL(string: imageURLString) ?? Meal.placeholderImageURL

        self.url = try container.decode(URL.self, forKey: .url)
    }

    public init(id: Int, name: String, notes: [String], prices: Meal.Prices?, category: String, image: URL, url: URL) {
        self.id = id
        self.name = name
        self.notes = notes
        self.prices = prices
        self.category = category
        self.image = image
        self.url = url
    }

    public static var placeholderImageURL: URL {
        return URL(string: "https://static.studentenwerk-dresden.de/bilder/mensen/studentenwerk-dresden-lieber-mensen-gehen.jpg")!
    }

    public var imageIsPlaceholder: Bool {
        image.absoluteString.hasSuffix("studentenwerk-dresden-lieber-mensen-gehen.jpg")
    }

    public var diet: [Diet] {
        self.notes
            .compactMap { Diet(note: $0) }
            .unique
    }

    public var ingredients: [Ingredient] {
        self.notes
            .compactMap { Ingredient(note: $0) }
            .unique
    }

    public var allergens: [Allergen] {
        self.notes
            .compactMap { Allergen(note: $0) }
            .unique
    }

    public func contains(unwantedIngredients: [Ingredient], unwantedAllergens: [Allergen]) -> Bool {
        for ingredient in unwantedIngredients {
            if ingredients.contains(ingredient) {
                return true
            }
        }
        for allergen in unwantedAllergens {
            if allergens.contains(allergen) {
                return true
            }
        }
        return false
    }

    public var isDinner: Bool {
        category.lowercased().contains("abend")
    }
}

public enum Diet {
    case vegan
    case vegetarian

    init?(note: String) {
        let note = note.lowercased()
        if note.contains("vegan") {
            self = .vegan
        } else if note.contains("vegetarisch") || note.contains("nomeat") {
            self = .vegetarian
        } else {
            return nil
        }
    }
}

public enum Ingredient: String, CaseIterable, Equatable {
    case pork
    case beef
    case alcohol
    case garlic

    init?(note: String) {
        let note = note.lowercased()
        if note.contains("schweinefleisch") {
            self = .pork
        } else if note.contains("rindfleisch") {
            self = .beef
        } else if note.contains("alkohol") {
            self = .alcohol
        } else if note.contains("knoblauch") {
            self = .garlic
        } else {
            return nil
        }
    }
}

public enum Allergen: String, CaseIterable {
    case gluten = "A"
    case shellfish = "B"
    case eggs = "C"
    case fish = "D"
    case peanuts = "E"
    case soy = "F"
    case lactose = "G"
    case nuts = "H"
    case celery = "I"
    case mustard = "J"
    case sesame = "K"
    case sulfite = "L"
    case lupin = "M"
    case molluscs = "N"

    init?(note: String) {
        let regex = Regex(#"\(([A-Z])\d?\)"#)
        guard let identifier = regex.firstMatch(in: note)?.captures[0] else {
            return nil
        }
        self.init(rawValue: identifier)
    }
}

extension Array where Element: Hashable {
    fileprivate var unique: Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}
