//
//  Models.swift
//  PokemonSample
//
//  Created by user on 15.09.23.
//

import Foundation
import SwiftUI

struct Pokemon: Codable, Equatable{
    let name: String
    let url: String
}

struct PokemonDetail: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    private let sprites: Sprites
    var image: String {
        sprites.front_default
    }
    private let types: [Types]
    var type: String {
        types[0].name
    }
    let weight, height: Int
}

extension PokemonDetail {
    
    static var fakes: [PokemonDetail] {
        return [
            PokemonDetail.fake,
            PokemonDetail.fake,
            PokemonDetail.fake,
            PokemonDetail.fake
        ]
    }
    
    static var fake: PokemonDetail {
        PokemonDetail(
            id: 1,
            name: "Bulbsaur",
            sprites: Sprites(front_default: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"),
            types: [Types(name: "grass")],
            weight: 69,
            height: 7)
    }
}

extension PokemonDetail {
    struct Types: Codable, Equatable {
        let name: String
    }
}

extension PokemonDetail {
    struct Sprites: Codable, Equatable{
        let front_default: String
    }
}
