//
//  PRank.swift
//  PRank
//
//
//  PRank.swift
//  PRank
//
//  Created by seb's on 11/12/24.
//
import Foundation
import SwiftUI
import CoreLocation

struct PRank: Codable, Hashable, Identifiable {
    var id: Int
    var name: String
    var nickname: String
    var state: String
    var description: String
    var isFavorite: Bool
    var isFeatured: Bool
    var category: Category

    // Nuevos atributos
    var trainingSpot: String?
    var weightKg: Double
    var weightLbs: Double
    var heightFt: Double
    var currentAge: Int? // Solo para mujeres
    var primeAge: Int?   // Solo para hombres

    var prBenchPressKg: Double?
    var prBenchPressLbs: Double?
    var prBarbellSquatKg: Double?
    var prBarbellSquatLbs: Double?
    var prHipThrustKg: Double?
    var prHipThrustLbs: Double?
    var prLegPressKg: Double?
    var prLegPressLbs: Double?

    // Nueva propiedad para la posición en el ranking
    var rank: Int?

    public var imageName: String
    var image: Image {
        Image(imageName)
    }

    private var coordinates: Coordinates
    var locationCoordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }

    struct Coordinates: Hashable, Codable {
        var latitude: Double
        var longitude: Double
    }

    enum Category: String, CaseIterable, Codable {
        case legend = "Legend"
        case topglobal = "Top Global"
        case professional = "Professional"
        case elite = "Elite"
        case advanced = "Advanced"
        case intermediate = "Intermediate"
        case beginner = "Beginner"
    }

    // Inicializador manual
    public init(
        id: Int,
        name: String,
        nickname: String,
        state: String,
        description: String,
        isFavorite: Bool,
        isFeatured: Bool,
        category: Category,
        trainingSpot: String? = nil,
        weightKg: Double,
        weightLbs: Double,
        heightFt: Double,
        currentAge: Int? = nil,
        primeAge: Int? = nil,
        prBenchPressKg: Double? = nil,
        prBenchPressLbs: Double? = nil,
        prBarbellSquatKg: Double? = nil,
        prBarbellSquatLbs: Double? = nil,
        prHipThrustKg: Double? = nil,
        prHipThrustLbs: Double? = nil,
        prLegPressKg: Double? = nil,
        prLegPressLbs: Double? = nil,
        rank: Int? = nil,
        imageName: String,
        coordinates: Coordinates
    ) {
        self.id = id
        self.name = name
        self.nickname = nickname
        self.state = state
        self.description = description
        self.isFavorite = isFavorite
        self.isFeatured = isFeatured
        self.category = category
        self.trainingSpot = trainingSpot
        self.weightKg = weightKg
        self.weightLbs = weightLbs
        self.heightFt = heightFt
        self.currentAge = currentAge
        self.primeAge = primeAge
        self.prBenchPressKg = prBenchPressKg
        self.prBenchPressLbs = prBenchPressLbs
        self.prBarbellSquatKg = prBarbellSquatKg
        self.prBarbellSquatLbs = prBarbellSquatLbs
        self.prHipThrustKg = prHipThrustKg
        self.prHipThrustLbs = prHipThrustLbs
        self.prLegPressKg = prLegPressKg
        self.prLegPressLbs = prLegPressLbs
        self.rank = rank
        self.imageName = imageName
        self.coordinates = coordinates
    }
}

// Extensión para convertir números en ordinales
extension Int {
    func ordinal() -> String {
        let suffixes = ["th", "st", "nd", "rd"]
        let index = (self % 100 >= 11 && self % 100 <= 13) ? 0 : Swift.min(self % 10, 3)
        return "\(self)\(suffixes[index])"
    }
}
