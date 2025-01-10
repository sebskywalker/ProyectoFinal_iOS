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
                fatalError("Error al cargar Core Data: \(error), \(error.userInfo)")
            }
        }
    }

    // ✅ Guardar perfil
    func saveProfile(
        name: String,
        gender: String,
        category: String,
        benchPressPR: Double,
        profileImage: UIImage?,
        completion: @escaping (PRank) -> Void
    ) {
        let context = container.viewContext

        // Eliminar perfil previo para sobrescribir
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Profile.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
        } catch {
            print("Error al borrar perfiles antiguos: \(error)")
        }

        let profile = Profile(context: context)
        profile.name = name
        profile.gender = gender
        profile.category = category
        profile.benchPressPR = benchPressPR
        if let imageData = profileImage?.jpegData(compressionQuality: 0.8) {
            profile.profileURL = imageData
        }

        do {
            try context.save()
            print("Perfil guardado correctamente")

            // ✅ Crear PRank para agregarlo al ranking
            let newPRank = PRank(
                id: Int.random(in: 1000...9999),
                name: name,
                nickname: name,
                state: "Activo",
                description: "Usuario registrado",
                isFavorite: false,
                isFeatured: true,
                category: PRank.Category(rawValue: category) ?? .beginner,
                weightKg: 0.0,
                weightLbs: 0.0,
                heightFt: 0.0,
                imageName: "photo.fill",
                coordinates: PRank.Coordinates(latitude: 0.0, longitude: 0.0)
            )

            // ✅ Devolver PRank para agregarlo en tiempo real
            completion(newPRank)

        } catch {
            print("Error al guardar perfil: \(error.localizedDescription)")
        }
    }

    // ✅ Cargar perfil guardado
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
