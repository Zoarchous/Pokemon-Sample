//
//  PokemonViewModel.swift
//  PokemonSample
//
//  Created by user on 19.09.23.
//

import Foundation

struct PokemonUiModel: Codable, Identifiable {
    var id: Int
    var name, image, primaryType: String
    var stats: [Dictionary<String, Int>]
    var weight, height: Int
}

extension PokemonUiModel {
//    func mapApiPokemonList(pokemons: [PokemonDetail]) -> [PokemonUiModel] {
//        return pokemons.map { it in
//            PokemonUiModel(id: it.id, name: it.name, image: it.image, primaryType: it.primaryType, stats: [Dic], weight: <#T##Int#>, height: <#T##Int#>)
//        }
//    }
}
