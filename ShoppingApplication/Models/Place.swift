
import Foundation

final class Place: Decodable {
    let results: [PlaceResults]
}

final class PlaceResults: Decodable {
    let geometry: Geometry
    let name: String
    let vicinity: String
}

final class Geometry: Decodable {
    let location: Location
}

final class Location: Decodable {
    let lat: Double
    let lng: Double
}
