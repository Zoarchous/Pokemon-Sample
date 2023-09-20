//
//  ApiModelMapperHelper.swift
//  PokemonSample
//
//  Created by user on 20.09.23.
//

import Foundation

class ApiModelMapperHelper {
    static let shared = ApiModelMapperHelper()
    
    init() {}
    private static let database = CoreDataManager.shared
    
    func mapAndSaveApiModel(apiModel: PokemonDetail) {
        guard let pokemonInfo = Self.database.add(type: PokemonCoreDetail.self) else { return }
        pokemonInfo.name = apiModel.name
        pokemonInfo.id = Int16(apiModel.id)
        pokemonInfo.height = {
            let value = Float(apiModel.height) * 10
            return String(format: "%.2f", value)
        }()
        pokemonInfo.weight = {
            let value = Float(apiModel.weight) / 100
            return String(format: "%.2f", value)
        }()
        pokemonInfo.primaryType = apiModel.types[0].type.name
        pokemonInfo.image = apiModel.sprites.frontDefault
        pokemonInfo.stats = mapStats(stats: apiModel.stats)
        Self.database.save()
    }
    
    private func mapStats(stats: [StatElement]) -> [StatItem] {
        guard let pokemonStat = Self.database.add(type: StatItem.self) else { return [] }
        let c = stats.compactMap { it in
            if [NeededStats.Hp.rawValue, NeededStats.Attack.rawValue, NeededStats.Defense.rawValue].contains(it.statName.capitalized) {
                pokemonStat.statName = it.statName
                pokemonStat.statValue = it.statValue
                return pokemonStat
            }
            return nil
        }
        return c
    }
}

enum NeededStats: String, CaseIterable {
    case Hp
    case Attack
    case Defense
}
