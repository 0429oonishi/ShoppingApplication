
import Foundation

class Place: Decodable {
    let results: [PlaceResults]
}

class PlaceResults: Decodable {
    let geometry: Geometry
    let name: String
    let vicinity: String
}

class Geometry: Decodable {
    let location: Location
}

class Location: Decodable {
    let lat: Double
    let lng: Double
}
