//
//  Profile+CoreDataProperties.swift
//  PRank
//
//  Created by seb's on 1/8/25.
//
//
import CoreData
import Foundation

extension Profile {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }

    @NSManaged public var benchPressPR: Double
    @NSManaged public var birthdate: Date?
    @NSManaged public var deadliftPR: Double
    @NSManaged public var nickname: String?
    @NSManaged public var name: String?
    @NSManaged public var occupation: String?
    @NSManaged public var squatPR: Double
    @NSManaged public var profileURL: Data?  // Cambiado a Data para almacenar la imagen como Binary Data
    
    // Nuevos atributos
       @NSManaged public var gender: String?   // Agregar el atributo `gender`
       @NSManaged public var category: String? // Agregar el atributo `category`
   
}

extension Profile : Identifiable {
}
