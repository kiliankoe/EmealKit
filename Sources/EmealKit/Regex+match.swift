import Foundation

extension NSRegularExpression {
    func matches(in string: String) -> [String] {
        let results = self.matches(in: string, range: NSRange(string.startIndex..., in: string))
        let matches = results.map { String(string[Range($0.range(at: 1), in: string)!]) }
        return matches
    }

    func match(in string: String) -> String? {
        return self.matches(in: string).first
    }
}
