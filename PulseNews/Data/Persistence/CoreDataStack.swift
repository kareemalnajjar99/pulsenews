//
//  CoreDataStack.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 19/05/2026.
//

import CoreData

final class CoreDataStack {

    static let shared = CoreDataStack()

    let persistentContainer: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    private init() {

        persistentContainer = NSPersistentContainer(
            name: "PulseNewsDataModel"
        )

        let description = persistentContainer.persistentStoreDescriptions.first

        description?.setOption(
            true as NSNumber,
            forKey: NSMigratePersistentStoresAutomaticallyOption
        )

        description?.setOption(
            true as NSNumber,
            forKey: NSInferMappingModelAutomaticallyOption
        )

        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load Core Data store: \(error)")
            }
        }

        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    func newBackgroundContext() -> NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()

        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        return context
    }
}
