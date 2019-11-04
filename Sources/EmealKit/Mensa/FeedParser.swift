import Foundation

class FeedParser: NSObject, XMLParserDelegate {
    let parser: XMLParser

    var currentItem: [String: String]?
    var currentAttribute: String?

    var meals: [Meal] = []
    var completion: (Result<[Meal], EKError>) -> Void

    @discardableResult
    init(data: Data, completion: @escaping (Result<[Meal], EKError>) -> Void) {
        self.parser = XMLParser(data: data)
        self.completion = completion
        super.init()

        self.parser.delegate = self
        self.parser.parse()
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "item" {
            self.currentItem = [:]
            return
        }

        guard self.currentItem != nil else { return }
        self.currentAttribute = elementName
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let meal = Meal(from: self.currentItem!)!
            self.meals.append(meal)
            self.currentItem = nil
        } else {
            self.currentAttribute = nil
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard self.currentItem != nil, let attr = self.currentAttribute else { return }
        self.currentItem?[attr, default: ""].append(string)
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        completion(.success(self.meals))
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Swift.Error) {
        completion(.failure(EKError.feed(error: parseError)))
    }
}
