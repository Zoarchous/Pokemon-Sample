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

struct PokemonDetail: Codable, Identifiable {
    let id: Int
    let name: String
    let sprites: Sprites
    var image: String {
        sprites.frontDefault
    }
    let types: [TypeElement]
    var primaryType: String {
        types[0].type.name
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
            sprites: Sprites(frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"),
            types: [TypeElement(type: Species(name: "grass"))],
            weight: 69,
            height: 7)
    }
}

extension PokemonDetail {
    func backgroundColor(forType type: String) -> Color {
        switch type {
        case "fire": return Color.red
        case "grass", "poison", "bug": return Color.green
        case "water", "flying": return Color.blue
        case "electric": return Color.yellow
        case "ground": return Color.brown
        case "normal": return Color.gray
        case "fairy": return Color.pink
        case "psychic": return Color.purple
        default: return Color.indigo
        }
    }
}

struct TypeElement: Codable {
    let type: Species
}


struct Species: Codable {
    let name: String
}


class Sprites: Codable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
    
    init(frontDefault: String) {
        self.frontDefault = frontDefault
    }
}

