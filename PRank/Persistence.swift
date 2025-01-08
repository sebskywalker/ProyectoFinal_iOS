//
//  Persistence.swift
//  PRank
//
//  Created by seb's on 11/12/24.
//

import CoreData
import SwiftUI

// PersistenceController.swift
struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PRank") // Este nombre debe coincidir con el nombre del archivo del modelo .xcdatamodeld

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null") // Para usar en memoria en vez de guardar en disco
        }

        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                // Manejo del error en producción
                print("Core Data error: \(error), \(error.userInfo)")
            }
        }
    }

    // Función para guardar datos de perfil
    func saveProfile(nickname: String, benchPressPR: Double, deadliftPR: Double, birthdate: Date, name: String, occupation: String, squatPR: Double, profileImage: UIImage) {
        let context = container.viewContext

        // Crear un nuevo perfil
        let profile = Profile(context: context)
        profile.nickname = nickname
        profile.benchPressPR = benchPressPR
        profile.deadliftPR = deadliftPR
        profile.birthdate = birthdate
        profile.name = name
        profile.occupation = occupation
        profile.squatPR = squatPR

        // Convertir la imagen a datos binarios
        if let imageData = profileImage.jpegData(compressionQuality: 0.8) {
            profile.profileURL = imageData // Guardamos la imagen como datos binarios
        }

        // Guardar el contexto
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
