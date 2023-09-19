//
//  PokemonsResponse.swift
//  PokemonSample
//
//  Created by user on 15.09.23.
//

import Foundation
struct PokemonsResponse: Codable, Equatable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Pokemon]
}


