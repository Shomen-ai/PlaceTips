import CoreLocation
import SwiftUI

struct StringValue: Codable {
    let value: String

    private enum CodingKeys: String, CodingKey {
        case value = "stringValue"
    }
}

struct DoubleValue: Codable {
    let value: Double

    private enum CodingKeys: String, CodingKey {
        case value = "doubleValue"
    }
}

struct IntegerValue: Codable {
    let value: String

    enum CodingKeys: String, CodingKey {
        case value = "integerValue"
    }
}

struct ResponseData: Codable {
    let responseData: [Places]

    enum CodingKeys: String, CodingKey {
        case responseData = "documents"
    }
}

struct Places: Codable {
    var id: String
    var lon: Double
    var lat: Double
    var placeName: String
    var other: String?

    private enum PlacesKeys: String, CodingKey {
        case fields
    }

    private enum FieldKeys: String, CodingKey {
        case id
        case lon
        case lat
        case placeName
        case other
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PlacesKeys.self)
        let filedContainer = try container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        id = try filedContainer.decode(IntegerValue.self, forKey: .id).value
        lon = try filedContainer.decode(DoubleValue.self, forKey: .lon).value
        lat = try filedContainer.decode(DoubleValue.self, forKey: .lat).value
        placeName = try filedContainer.decode(StringValue.self, forKey: .placeName).value
        other = try filedContainer.decode(StringValue.self, forKey: .other).value
    }
}

enum Errors: Error {
    case responseError(_ responseErrorString: String)
}
