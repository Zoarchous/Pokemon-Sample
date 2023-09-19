//
//  CoreDataManager.swift
//  PokemonSample
//
//  Created by user on 19.09.23.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.viewContext = viewContext
    }
    
    func add<T: NSManagedObject>(type: T.Type) -> T? {
        guard let entityName = T.entity().name else { return nil }
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: viewContext) else { return nil }
        let object = T(entity: entity, insertInto: viewContext)
        return object
    }
    
    func fetch<T: NSManagedObject>(type: T.Type) -> [T] {
        let request = T.fetchRequest()
        do {
            let result = try viewContext.fetch(request)
            return result as! [T]
        } catch {
            print(error.localizedDescription)
            return[]
        }
    }
    
    func save() {
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func resetAllRecords(in entityName: String) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest:  deleteFetch)
        
        do {
            try viewContext.execute(deleteRequest)
            try viewContext.save()
        } catch {
            print("An error occured")
        }
    }
}
