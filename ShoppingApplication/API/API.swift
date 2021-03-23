//
//  API.swift
//  ShoppingApplication
//
//  Created by 大西玲音 on 2021/03/19.
//

import Foundation
import Alamofire

final class API {

    static let shared = API()
    private init() { }

    func request(searchKeyword: String, lat: Double, lng: Double, completion: (([PlaceResults]) -> Void)? = nil) {
        let baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        let apiKey = "AIzaSyA6zhP2dUBGYTQl1dJ8pjSJoyk67KnQil8"
        let urlString = "\(baseURL)?location=\(lat),\(lng)&language=ja&radius=2000&keyword=\(searchKeyword)&key=\(apiKey)"
        guard let encodeUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let request = AF.request(encodeUrlString)
        request.responseJSON { response in
            guard let data = response.data else { return }
            let decoder = JSONDecoder()
            let place = try! decoder.decode(Place.self, from: data)
            completion?(place.results)
        }
    }

}
