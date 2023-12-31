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
        guard let pokemonInfo = ApiModelMapperHelper.database.add(type: PokemonCoreDetail.self) else { return }
        mapStats(relatedId: Int16(apiModel.id), stats: apiModel.stats)
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
        ApiModelMapperHelper.database.save()
    }
    
    private func mapStats(relatedId: Int16, stats: [StatElement]) {
        stats.forEach { it in
            if [NeededStats.Hp.rawValue, NeededStats.Attack.rawValue, NeededStats.Defense.rawValue].contains(it.statName.capitalized) {
                guard let pokemonStat = ApiModelMapperHelper.database.add(type: StatItem.self) else { return }
                pokemonStat.statName = it.statName
                pokemonStat.statValue = it.statValue
                pokemonStat.relatedId = relatedId
                ApiModelMapperHelper.database.save()
            }
        }
    }
}

enum NeededStats: String, CaseIterable {
    case Hp
    case Attack
    case Defense
}
