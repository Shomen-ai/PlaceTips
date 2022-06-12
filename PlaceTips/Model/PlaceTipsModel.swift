import CoreLocation
import Firebase
import SwiftUI

enum Errors: Error {
    case responseError(_ responseErrorString: String)
    case failToLoadUserData(_ error: String)
}

struct Place {
    var id: String
    var lon: Double
    var lat: Double
    var placeName: String
    var other: String?
}

struct User {
    var email: String = ""
    var favoriets: [String: Any] = [:]
    var imageURL: String = ""
    var image: UIImage = .init()
    var login: String = ""
    var password: String = ""
}
