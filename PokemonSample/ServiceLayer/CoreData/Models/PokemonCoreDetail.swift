//
//  PokemonCoreDetail.swift
//  PokemonSample
//
//  Created by user on 20.09.23.
//

import CoreData

public class PokemonCoreDetail: NSManagedObject {
    @NSManaged var id: Int16
    @NSManaged var name, image, primaryType, weight, height: String
    @NSManaged var stats: [StatItem]
}

public class StatItem: NSManagedObject {
    @NSManaged var statName: String
    @NSManaged var statValue: Float
}
