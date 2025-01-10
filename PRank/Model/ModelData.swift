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
    static let shared = ModelData()

    @Published var womenPRanks: [PRank] = []
    @Published var menPRanks: [PRank] = []

    let categoryOrder: [PRank.Category] = [
        .legend, .topglobal, .professional, .elite, .advanced, .intermediate, .beginner
    ]

    init() {
        loadData()
        loadSavedProfile()
    }

    // ✅ Cargar datos desde JSON
    private func loadData() {
        self.menPRanks = load("PRankData.json")
        self.womenPRanks = load("WomenPRankData.json")
    }

    // ✅ Cargar perfil guardado desde Core Data
    private func loadSavedProfile() {
        if let savedProfile = PersistenceController.shared.loadProfile() {
            let userPRank = PRank(
                id: Int.random(in: 1000...9999),
                name: savedProfile.name ?? "Usuario",
                nickname: savedProfile.name ?? "Usuario",
                state: "Activo",
                description: "Perfil creado por el usuario",
                isFavorite: false,
                isFeatured: true,
                category: PRank.Category(rawValue: savedProfile.category ?? "Beginner") ?? .beginner,
                weightKg: 0.0,
                weightLbs: 0.0,
                heightFt: 0.0,
                prBenchPressKg: savedProfile.benchPressPR,
                imageName: "photo.fill",
                coordinates: PRank.Coordinates(latitude: 0.0, longitude: 0.0)
            )

            if savedProfile.gender == "Men" {
                self.menPRanks.append(userPRank)
            } else {
                self.womenPRanks.append(userPRank)
            }

            // ✅ Se actualiza el ranking después de cargar el perfil
            self.updateRankings()
        }
    }

    // ✅ Categorías para hombres
    var menCategories: [String: [PRank]] {
        orderCategories(data: menPRanks)
    }

    // ✅ Categorías para mujeres
    var womenCategories: [String: [PRank]] {
        orderCategories(data: womenPRanks)
    }

    // ✅ Ordenar categorías
    private func orderCategories(data: [PRank]) -> [String: [PRank]] {
        let grouped = Dictionary(grouping: data, by: { $0.category.rawValue })
        return grouped.sorted { lhs, rhs in
            guard let lhsIndex = categoryOrder.firstIndex(where: { $0.rawValue == lhs.key }),
                  let rhsIndex = categoryOrder.firstIndex(where: { $0.rawValue == rhs.key }) else { return false }
            return lhsIndex < rhsIndex
        }
        .reduce(into: [String: [PRank]]()) { result, pair in
            result[pair.key] = pair.value
        }
    }

    // ✅ Método para agregar perfiles en tiempo real
    func addProfile(_ profile: PRank, isForMen: Bool) {
        DispatchQueue.main.async {
            if isForMen {
                self.menPRanks.append(profile)
            } else {
                self.womenPRanks.append(profile)
            }
            self.updateRankings()
        }
    }

    // ✅ Método para actualizar rankings
    func updateRankings() {
        self.menPRanks.sort { $0.prBenchPressKg ?? 0 > $1.prBenchPressKg ?? 0 }
        self.womenPRanks.sort { $0.prBenchPressKg ?? 0 > $1.prBenchPressKg ?? 0 }
    }

    // ✅ Método para obtener la posición en el ranking
    func getRankPosition(for profile: PRank, isForMen: Bool) -> Int? {
        if isForMen {
            return menPRanks.firstIndex(where: { $0.id == profile.id }).map { $0 + 1 }
        } else {
            return womenPRanks.firstIndex(where: { $0.id == profile.id }).map { $0 + 1 }
        }
    }
}

// ✅ Función para cargar archivos JSON
func load<T: Decodable>(_ fileName: String) -> T {
    let data: Data
    guard let file = Bundle.main.url(forResource: fileName, withExtension: nil) else {
        fatalError("No se encontró \(fileName) en el bundle principal.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Error al cargar \(fileName): \(error.localizedDescription)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Error al decodificar \(fileName): \(error.localizedDescription)")
    }
}
