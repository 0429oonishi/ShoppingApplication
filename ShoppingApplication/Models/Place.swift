//
//  Place.swift
//  ShoppingApplication
//
//  Created by 大西玲音 on 2021/04/29.
//

import Foundation

struct Place: Decodable {
    let results: [PlaceResults]
}

struct PlaceResults: Decodable {
    let geometry: Geometry
    let name: String
    let vicinity: String
}

struct Geometry: Decodable {
    let location: Location
}

struct Location: Decodable {
    let lat: Double
    let lng: Double
}
