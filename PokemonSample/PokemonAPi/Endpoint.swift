//
//  Endpoint.swift
//  PokemonSample
//
//  Created by user on 14.09.23.
//

import Foundation

enum Endpoint {
    case pokemon(offset: Int)
    case detail(name: String)
}

extension Endpoint {
    var path: String {
        switch self {
        case .pokemon:
            return "pokemon"
        case .detail(let name):
            return "pokemon/\(name)"
        }
    }
    
    var queryItems: [String: String]? {
        switch self {
        case .pokemon(let offset):
            return["offset":"\(offset)", "limit":"\(50)"]
        default:
            return nil
        }
    }
}

extension Endpoint {
    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "pokeapi.co/api/v2/"
        urlComponents.path = path
        
        var requestQueryItems = [URLQueryItem]()
        queryItems?.forEach { item in
            requestQueryItems.append(URLQueryItem(name: item.key, value: item.value))
        }
        urlComponents.queryItems = requestQueryItems
        print(urlComponents.url!)
        return urlComponents.url
    }
}
