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

    @State private var selectedMetric: Metric = .benchPress // Cambiado a Bench Press como inicial

    enum Metric: String, CaseIterable {
        case benchPress = "Bench Press"
        case squats = "Squats"
        case globalTop = "Global Top"
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Selector para cambiar entre métricas
                Picker("Metric", selection: $selectedMetric) {
                    ForEach(Metric.allCases, id: \.self) { metric in
                        Text(metric.rawValue).tag(metric)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .padding(.top, 10) // Subir un poco más el selector

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
                                    .frame(width: 30, height: CGFloat(getBarHeight(for: profile, maxHeight: geometry.size.height * 0.5)))

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
            .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height) // Limitar el tamaño de la vista
            .navigationTitle(isForMen ? "Men's Rankings" : "Women's Rankings")
            .navigationBarTitleDisplayMode(.inline)
        }
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
        case .benchPress:
            return profile.prBenchPressKg ?? 0
        case .squats:
            return profile.prBarbellSquatKg ?? 0
        case .globalTop:
            return profile.prBenchPressKg ?? 0 // Global Top usa Bench Press como ejemplo
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

    // Calcular la altura de la barra proporcionalmente al valor máximo
    func getBarHeight(for profile: PRank, maxHeight: Double) -> Double {
        let maxMetricValue = getSortedRankingData().first.map { getMetricValue(for: $0) } ?? 1.0
        let normalizedValue = getMetricValue(for: profile) / maxMetricValue
        return maxHeight * normalizedValue
    }
}
