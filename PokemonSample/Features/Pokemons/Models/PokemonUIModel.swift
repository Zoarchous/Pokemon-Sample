//
//  PokemonUIModel.swift
//  PokemonSample
//
//  Created by user on 20.09.23.
//

import Foundation
import SwiftUI

struct PokemonUIModel: Codable, Identifiable {
    let id: Int16
    let name, image, primaryType, weight, height: String
    let stats: [UIStatItem]
}

struct UIStatItem: Codable {
    let statName: String
    let statValue: Float
}

extension PokemonUIModel {
    func backgroundColor(forType type: String) -> Color {
        switch type {
        case "Fire": return Color.red
        case "Grass", "Poison", "Bug": return Color.green
        case "Water", "Flying": return Color.blue
        case "Electric": return Color.yellow
        case "Ground": return Color.brown
        case "Normal": return Color.gray
        case "Fairy": return Color.pink
        case "Psychic": return Color.purple
        default: return Color.indigo
        }
    }
}

extension PokemonUIModel {
    static var fakes: [PokemonUIModel] {
        return [
            PokemonUIModel.fake,
            PokemonUIModel.fake,
            PokemonUIModel.fake,
            PokemonUIModel.fake
        ]
    }
    
    static var fake: PokemonUIModel {
        PokemonUIModel(
            id: 1,
            name: "Bulbasaur",
            image: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
            primaryType: "grass",
            weight: "5.5",
            height: "111",
            stats: [UIStatItem.init(statName: "hp", statValue: 0.13), UIStatItem.init(statName: "attack", statValue: 0.13), UIStatItem.init(statName: "defense", statValue: 0.13)]
        )
    }
}
