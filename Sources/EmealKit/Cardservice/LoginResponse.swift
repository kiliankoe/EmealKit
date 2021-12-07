import Foundation

struct LoginResponse: Decodable {
    let authToken: String
    let karteNr: String
    // The rest here is seemingly unecessary
}
