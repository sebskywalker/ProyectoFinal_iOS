//
//  Persistence.swift
//  PRank
//
//  Created by seb's on 11/12/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PRank") // Asegúrate de que "PRank" sea el nombre correcto de tu modelo .xcdatamodeld
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                // Imprime el error en lugar de usar fatalError para evitar crashes en producción
                print("Core Data error: \(error), \(error.userInfo)")
            }
        }
    }
}
