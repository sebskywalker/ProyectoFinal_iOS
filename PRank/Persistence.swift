//
//  Persistence.swift
//  PRank
//
//  Created by seb's on 11/12/24.
import CoreData
import UIKit

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PRank")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Core Data error: \(error), \(error.userInfo)")
            }
        }
    }

    // Guardar el perfil
    func saveProfile(name: String, profileImage: UIImage?) {
        let context = container.viewContext

        // Borrar el perfil anterior (opcional si solo se permite un perfil)
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Profile.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Error al borrar perfiles antiguos: \(error)")
        }

        // Crear un nuevo perfil
        let profile = Profile(context: context)
        profile.name = name
        if let imageData = profileImage?.jpegData(compressionQuality: 0.8) {
            profile.profileURL = imageData
        }

        do {
            try context.save()
            print("Perfil guardado correctamente")
        } catch {
            print("Error al guardar perfil: \(error.localizedDescription)")
        }
    }

    // Cargar el perfil guardado
    func loadProfile() -> Profile? {
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        do {
            let profiles = try container.viewContext.fetch(fetchRequest)
            return profiles.first
        } catch {
            print("Error al cargar perfil: \(error.localizedDescription)")
            return nil
        }
    }
}
