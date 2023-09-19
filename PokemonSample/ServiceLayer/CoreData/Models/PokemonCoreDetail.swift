//
//  CoreModel.swift
//  PokemonSample
//
//  Created by user on 19.09.23.
//

import CoreData
public class PokemonCoreDetail: NSManagedObject {
    @NSManaged var id: Int
    @NSManaged var name, image, primaryType: String
    @NSManaged var stats: [Dictionary<String, Int>]
    @NSManaged var weight, height: String
}

