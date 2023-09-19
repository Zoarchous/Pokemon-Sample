//
//  PokemonCoreList.swift
//  PokemonSample
//
//  Created by user on 19.09.23.
//

import CoreData

public class PokemonCoreList: NSManagedObject {
    @NSManaged var list: [PokemonCoreDetail]
}
