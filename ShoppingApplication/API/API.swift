//
//  API.swift
//  ShoppingApplication
//
//  Created by 大西玲音 on 2021/03/19.
//

import Foundation
import Alamofire

typealias ResultHandler<T> = (Result<T, Error>) -> Void

final class API {

    static let shared = API()
    private init() { }

    func request(searchKeyword: String, lat: Double, lng: Double, handler: @escaping ResultHandler<[PlaceResults]>) {
        let baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        let apiKey = "AIzaSyA6zhP2dUBGYTQl1dJ8pjSJoyk67KnQil8"
        let urlString = "\(baseURL)?location=\(lat),\(lng)&language=ja&radius=2000&keyword=\(searchKeyword)&key=\(apiKey)"
        guard let encodeUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            handler(.failure(NetworkError.invalidURL))
            return
        }
        let request = AF.request(encodeUrlString)
        request.responseJSON { response in
            guard let data = response.data else {
                handler(.failure(NetworkError.invalidResponse))
                return
            }
            let decoder = JSONDecoder()
            let place = try! decoder.decode(Place.self, from: data)
            handler(.success(place.results))
        }
    }

}
