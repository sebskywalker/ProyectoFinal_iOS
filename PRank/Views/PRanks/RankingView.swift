//
//  RankingView.swift
//  PRank
//
//  Created by seb's on 11/27/24.
//
import SwiftUI

struct RankingView: View {
    @EnvironmentObject var modelData: ModelData
    var isForMen: Bool

    @State private var selectedMetric: Metric = .globalTop

    enum Metric: String, CaseIterable {
        case globalTop = "Global Top"
        case benchPress = "Bench Press"
        case squats = "Squats"
    }

    var body: some View {
        VStack {
            // Selector para cambiar entre métricas
            Picker("Metric", selection: $selectedMetric) {
                ForEach(Metric.allCases, id: \.self) { metric in
                    Text(metric.rawValue).tag(metric)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            // Gráfica
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .bottom, spacing: 15) {
                    ForEach(getSortedRankingData(), id: \.id) { profile in
                        VStack {
                            // Imagen miniatura
                            Image(profile.imageName)
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 40, height: 40)
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .shadow(radius: 5)

                            // Barra
                            Rectangle()
                                .fill(getBarColor(for: profile))
                                .frame(width: 30, height: CGFloat(getBarHeight(for: profile)))

                            // Nombre rotado
                            Text(profile.name)
                                .font(.caption)
                                .rotationEffect(.degrees(-45))
                                .frame(width: 50, height: 20, alignment: .center)
                                .padding(.top, 4)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle(isForMen ? "Men's Rankings" : "Women's Rankings")
        .navigationBarTitleDisplayMode(.inline)
    }

    // Obtener los datos de ranking
    func getRankingData() -> [PRank] {
        return isForMen ? modelData.menPRanks : modelData.womenPRanks
    }

    // Obtener los datos ordenados de mayor a menor
    func getSortedRankingData() -> [PRank] {
        getRankingData().sorted { getMetricValue(for: $0) > getMetricValue(for: $1) }
    }

    // Obtener el valor de la métrica seleccionada
    func getMetricValue(for profile: PRank) -> Double {
        switch selectedMetric {
        case .globalTop:
            return profile.prBenchPressKg ?? 0
        case .benchPress:
            return profile.prBenchPressKg ?? 0
        case .squats:
            return profile.prBarbellSquatKg ?? 0
        }
    }

    // Obtener el color basado en la categoría
    func getBarColor(for profile: PRank) -> Color {
        switch profile.category {
        case .legend:
            return .yellow
        case .topglobal:
            return .blue
        case .professional:
            return .green
        case .elite:
            return .orange
        default:
            return .gray
        }
    }

    // Calcular la altura de la barra
    func getBarHeight(for profile: PRank) -> Double {
        return getMetricValue(for: profile) * 2 // Escalar para visualizar
    }
}

struct RankingView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleData = ModelData()
        exampleData.menPRanks = [
            PRank(
                id: 25,
                name: "George Peterson",
                nickname: "Da Bull",
                state: "New York, USA",
                description: "George Peterson was a celebrated bodybuilder in the Classic Physique and 212 divisions, known for his incredible back development.",
                isFavorite: true,
                isFeatured: true,
                category: .legend,
                trainingSpot: "NYC Power Gym",
                weightKg: 94.0,
                weightLbs: 207.2,
                heightFt: 5.58,
                primeAge: 32,
                prBenchPressKg: 200.0,
                prBenchPressLbs: 440.9,
                prBarbellSquatKg: 240.0,
                prBarbellSquatLbs: 529.1,
                rank: 1,
                imageName: "george_peterson",
                coordinates: PRank.Coordinates(latitude: 40.7128, longitude: -74.006)
            ),
            PRank(
                id: 26,
                name: "Roelly Winklaar",
                nickname: "The Beast",
                state: "Curaçao",
                description: "Roelly Winklaar is a fan-favorite bodybuilder, famous for his massive arms and stage presence.",
                isFavorite: true,
                isFeatured: true,
                category: .professional,
                trainingSpot: "Willemstad Body Gym",
                weightKg: 130.0,
                weightLbs: 286.6,
                heightFt: 5.67,
                primeAge: 34,
                prBenchPressKg: 250.0,
                prBenchPressLbs: 551.2,
                prBarbellSquatKg: 280.0,
                prBarbellSquatLbs: 617.3,
                rank: 2,
                imageName: "roelly_winklaar",
                coordinates: PRank.Coordinates(latitude: 12.1224, longitude: -68.9335)
            )
        ]
        return RankingView(isForMen: true)
            .environmentObject(exampleData)
    }
}
