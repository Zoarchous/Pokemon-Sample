//
//  Models.swift
//  PokemonSample
//
//  Created by user on 15.09.23.
//

import Foundation
import SwiftUI
import CoreData

struct Pokemon: Codable, Equatable{
    let name: String
    let url: String
}

struct PokemonDetail: Codable, Identifiable {
    let id: Int
    let name: String
    let sprites: Sprites
    let types: [TypeElement]
    let stats: [StatElement]
    let weight: Int
    let height: Int
    
    func store() {
        ApiModelMapperHelper.shared.mapAndSaveApiModel(apiModel: self)
    }
}

struct StatElement: Codable {
    let base_stat: Int
    var statValue: Float {
        Float(base_stat) / 100.0
    }
    let stat: Stat
    var statName: String {
        stat.name
    }
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

