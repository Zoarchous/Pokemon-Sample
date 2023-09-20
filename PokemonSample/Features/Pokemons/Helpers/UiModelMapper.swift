//
//  UiModelMapper.swift
//  PokemonSample
//
//  Created by user on 20.09.23.
//

import Foundation


class UiModelMapper {
    static let shared = UiModelMapper()
    
    func mapApiModelList(apiModelList: [PokemonDetail]) -> [PokemonUIModel] {
        return apiModelList.map { it in
            mapApiModel(apiModel: it)
        }
    }
    
    func mapDBModelList(dbModelList: [PokemonCoreDetail]) -> [PokemonUIModel] {
        return dbModelList.map { it in
            mapDBModel(dbModel: it)
        }
    }
    
    func mapApiModel(apiModel: PokemonDetail) -> PokemonUIModel {
        let height = {
            let value = Float(apiModel.height) * 10
            return String(format: "%.2f", value)
        }()
        let weight = {
            let value = Float(apiModel.weight) / 100
            return String(format: "%.2f", value)
        }()
        return PokemonUIModel(id: Int16(apiModel.id), name: apiModel.name, image: apiModel.sprites.frontDefault, primaryType: apiModel.types[0].type.name.capitalized, weight: weight, height: height, stats: mapApiStats(stats: apiModel.stats))
    }
    
    func mapDBModel(dbModel: PokemonCoreDetail) -> PokemonUIModel {
        return PokemonUIModel(id: dbModel.id, name: dbModel.name, image: dbModel.image, primaryType: dbModel.primaryType, weight: dbModel.weight, height: dbModel.height, stats: mapDBStats(stats: dbModel.stats))
    }
    
    private func mapDBStats (stats: [StatItem]) -> [UIStatItem] {
        return stats.map { it in
            UIStatItem(statName: it.statName, statValue: it.statValue)
        }
    }
    
    private func mapApiStats(stats: [StatElement]) -> [UIStatItem] {
        return stats.compactMap { it in
            if [NeededStats.Hp.rawValue, NeededStats.Attack.rawValue, NeededStats.Defense.rawValue].contains(it.statName.capitalized) {
                return UIStatItem(statName: it.statName, statValue: it.statValue)
            }
            return nil
        }
    }
}
