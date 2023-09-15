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
    var image: AsyncImage<Image> {
        AsyncImage(url: URL(string: sprites.front_default))
    }
    let types: [Types]
    let weight, height: Int
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
