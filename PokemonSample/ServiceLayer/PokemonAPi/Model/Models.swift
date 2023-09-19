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
    let stats: [StatElement]
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
            stats: [StatElement(base_stat: 45, stat: Stat(name: "hp")), StatElement(base_stat: 35, stat: Stat(name: "Attack")), StatElement(base_stat: 45, stat: Stat(name: "Defense"))],
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

struct StatElement: Codable {
    let base_stat: Int
    var statValue: Float {
        Float(base_stat) / 100.0
    }
    let stat: Stat
}

struct Stat: Codable {
    let name: String
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

