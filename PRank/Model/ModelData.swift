//
//  ModelData.swift
//  PRank
//
//  Created by seb's on 11/12/24.
//
//
//  ModelData.swift
//  PRank
//
//  Created by seb's on 11/12/24.
//
import Foundation
import Combine

final class ModelData: ObservableObject {
    // Datos separados para hombres y mujeres
    @Published var womenPRanks: [PRank] = load("WomenPRankData.json")
    @Published var menPRanks: [PRank] = load("PRankData.json")
    
    // Orden deseado para las categorías
    let categoryOrder: [PRank.Category] = [
        .legend,       // Primero las Leyendas
        .topglobal,    // Luego los Top Globales
        .professional, // Profesionales
        .elite,        // Luego los Elite
        .advanced,     // Luego los Avanzados
        .intermediate, // Luego los Intermedios
        .beginner      // Por último los Principiantes
    ]
    
    // Categorías ordenadas para hombres
    var menCategories: [String: [PRank]] {
        orderCategories(data: menPRanks)
    }
    
    // Categorías ordenadas para mujeres
    var womenCategories: [String: [PRank]] {
        orderCategories(data: womenPRanks)
    }
    
    // Filtrar destacados (hombres y mujeres)
    var menFeatured: [PRank] {
        menPRanks.filter { $0.isFeatured }
    }
    
    var womenFeatured: [PRank] {
        womenPRanks.filter { $0.isFeatured }
    }
    
    // Función para ordenar las categorías
    private func orderCategories(data: [PRank]) -> [String: [PRank]] {
        let grouped = Dictionary(
            grouping: data,
            by: { $0.category.rawValue }
        )
        
        return grouped.sorted { lhs, rhs in
            guard
                let lhsIndex = categoryOrder.firstIndex(where: { $0.rawValue == lhs.key }),
                let rhsIndex = categoryOrder.firstIndex(where: { $0.rawValue == rhs.key })
            else {
                return false
            }
            return lhsIndex < rhsIndex
        }
        .reduce(into: [String: [PRank]]()) { result, pair in
            result[pair.key] = pair.value
        }
    }
    
    // Función para calcular el Strength Score
    private func calculateStrengthScore(for profiles: [PRank], isForMen: Bool) -> [(PRank, Double)] {
        var scores: [(PRank, Double)] = []

        for profile in profiles {
            var score: Double = 0.0
            
            if isForMen {
                // Métrica para hombres
                if let benchPressKg = profile.prBenchPressKg,
                   let squatKg = profile.prBarbellSquatKg,
                   let legPressKg = profile.prLegPressKg {
                    score += benchPressKg * 1.5 + squatKg * 2.0 + legPressKg
                }
            } else {
                // Métrica para mujeres
                let hipThrustKg = profile.prHipThrustKg ?? 0
                let squatKg = profile.prBarbellSquatKg ?? 0
                let legPressKg = profile.prLegPressKg ?? 0
                score += (hipThrustKg * 1.5) + (squatKg * 1.2) + (legPressKg * 0.8)
            }

            // Validar y dividir por el peso corporal
            if profile.weightKg > 0 {
                score /= profile.weightKg
            } else {
                print("Advertencia: Perfil con peso inválido o cero - \(profile.name)")
                score = 0.0
            }

            scores.append((profile, score))
        }

        // Ordenar de mayor a menor puntaje
        scores.sort { $0.1 > $1.1 }

        return scores
    }
    
    // Función para actualizar los rankings
    func updateRankings() {
        // Calcular rankings para hombres
        let menRankings = calculateStrengthScore(for: menPRanks, isForMen: true)
        menPRanks = menRankings.map { $0.0 }
        
        // Calcular rankings para mujeres
        let womenRankings = calculateStrengthScore(for: womenPRanks, isForMen: false)
        womenPRanks = womenRankings.map { $0.0 }
    }
    
    // Función para agregar un nuevo perfil y actualizar rankings
    func addProfile(_ profile: PRank, isForMen: Bool) {
        if isForMen {
            menPRanks.append(profile)
        } else {
            womenPRanks.append(profile)
        }
        updateRankings()
    }
    
    // Función para obtener la posición en el Top Rank
    func rankPosition(for profile: PRank, isForMen: Bool) -> Int? {
        if isForMen {
            return menPRanks.firstIndex(where: { $0.id == profile.id }).map { $0 + 1 }
        } else {
            return womenPRanks.firstIndex(where: { $0.id == profile.id }).map { $0 + 1 }
        }
    }
}

// Función para cargar archivos JSON
func load<T: Decodable>(_ fileName: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: fileName, withExtension: nil) else {
        fatalError("Couldn't find \(fileName) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(fileName) from main bundle: \(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't decode \(T.self): \(error)")
    }
}
