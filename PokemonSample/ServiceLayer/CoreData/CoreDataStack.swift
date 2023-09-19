//
//  CoreDataStack.swift
//  PokemonSample
//
//  Created by user on 19.09.23.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    let persistentContainer: NSPersistentContainer
    let mainContext: NSManagedObjectContext
    
    private init() {
        self.persistentContainer = NSPersistentContainer(name: "PokemonDetails")
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = NSSQLiteStoreType
        
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("Load failed. Error: \(error!)")
            }
        }
        self.mainContext = persistentContainer.viewContext
    }
}
