//
//  PRankDetail.swift
//  PRank
//
//  Created by seb's on 11/14/24.
//
//
import SwiftUI

struct PRankDetail: View {
    @EnvironmentObject var modelData: ModelData
    var PRank: PRank
    var isForMen: Bool

    var PRankIndex: Int {
        if isForMen {
            return modelData.menPRanks.firstIndex(where: { $0.id == PRank.id }) ?? 0
        } else {
            return modelData.womenPRanks.firstIndex(where: { $0.id == PRank.id }) ?? 0
        }
    }

    var rankPosition: Int? {
        modelData.rankPosition(for: PRank, isForMen: isForMen)
    }

    var body: some View {
        ScrollView {
            // Mapa
            MapView(coordinate: PRank.locationCoordinates)
                .ignoresSafeArea(edges: .top)
                .frame(height: 300)

            // Imagen circular
            CircleImage(image: PRank.image)
                .frame(width: 250, height: 250)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10)
                .offset(y: -125)
                .padding(.bottom, -125)

            // Información detallada
            VStack(alignment: .leading, spacing: 10) {
                // Título y botón de favorito
                HStack {
                    Text(PRank.name)
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    FavoriteButton(isSet: isForMen
                        ? $modelData.menPRanks[PRankIndex].isFavorite
                        : $modelData.womenPRanks[PRankIndex].isFavorite
                    )
                }

                // Subtítulo y ubicación
                HStack {
                    Text(PRank.nickname)
                        .font(.subheadline)
                        .italic()
                    Spacer()
                    Text(PRank.state)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Divider()

                // Mostrar ranking destacado
                if let rank = rankPosition {
                    Text(rank <= 10
                         ? "\(rank.ordinal()) place in the global top"
                         : "Rank: \(rank)")
                        .font(.headline)
                        .fontWeight(rank <= 10 ? .bold : .regular)
                        .foregroundColor(rank <= 10 ? .yellow : .blue)
                } else {
                    Text("Unranked")
                        .font(.headline)
                        .foregroundColor(.gray)
                }

                Divider()

                // Sección "About"
                Text("About \(PRank.name)")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text(PRank.description)

                Divider()

                // Información básica
                Text("Basic Information")
                    .font(.headline)
                VStack(alignment: .leading, spacing: 8) {
                    if let trainingSpot = PRank.trainingSpot {
                        Text("Training Spot: \(trainingSpot)")
                    }
                    // Usar `primeAge` como fallback si no hay `currentAge`
                    if let age = isForMen ? PRank.primeAge : PRank.primeAge ?? PRank.currentAge {
                        Text("Age: \(age)")
                    }
                    Text("Weight: \(PRank.weightKg, specifier: "%.1f") kg (\(PRank.weightLbs, specifier: "%.1f") lbs)")
                    Text("Height: \(PRank.heightFt, specifier: "%.2f") ft")
                }

                Divider()

                // Records personales
                Text("Personal Records (PRs)")
                    .font(.headline)
                VStack(alignment: .leading, spacing: 8) {
                    if isForMen {
                        if let benchPressKg = PRank.prBenchPressKg, let benchPressLbs = PRank.prBenchPressLbs {
                            Text("Bench Press: \(benchPressKg, specifier: "%.1f") kg (\(benchPressLbs, specifier: "%.1f") lbs)")
                        }
                    }
                    if let hipThrustKg = PRank.prHipThrustKg, let hipThrustLbs = PRank.prHipThrustLbs {
                        Text("Hip Thrust: \(hipThrustKg, specifier: "%.1f") kg (\(hipThrustLbs, specifier: "%.1f") lbs)")
                    }
                    if let squatKg = PRank.prBarbellSquatKg, let squatLbs = PRank.prBarbellSquatLbs {
                        Text("Barbell Squat: \(squatKg, specifier: "%.1f") kg (\(squatLbs, specifier: "%.1f") lbs)")
                    }
                    if let legPressKg = PRank.prLegPressKg, let legPressLbs = PRank.prLegPressLbs {
                        Text("Leg Press: \(legPressKg, specifier: "%.1f") kg (\(legPressLbs, specifier: "%.1f") lbs)")
                    }
                }
            }
            .padding()
        }
        .navigationTitle(PRank.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
