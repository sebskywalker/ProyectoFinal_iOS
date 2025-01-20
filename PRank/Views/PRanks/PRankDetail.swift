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

    // Obtener el índice del PRank en la lista correspondiente
    var PRankIndex: Int {
        if isForMen {
            return modelData.menPRanks.firstIndex(where: { $0.id == PRank.id }) ?? 0
        } else {
            return modelData.womenPRanks.firstIndex(where: { $0.id == PRank.id }) ?? 0
        }
    }

    // Calcular la posición en el ranking
    var rankPosition: Int? {
        modelData.getRankPosition(for: PRank, isForMen: isForMen)
    }

    var body: some View {
        ScrollView {
            // Mapa con ubicación
            MapView(coordinate: PRank.locationCoordinates)
                .ignoresSafeArea(edges: .top)
                .frame(height: 300)

            // Imagen circular del atleta
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
                    
                    // Botón para marcar como favorito
                    FavoriteButton(isSet: isForMen
                        ? $modelData.menPRanks[PRankIndex].isFavorite
                        : $modelData.womenPRanks[PRankIndex].isFavorite
                    )
                }

                // Apodo y ubicación
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

                // Mostrar ranking global
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
                    if let age = isForMen ? PRank.primeAge : PRank.primeAge ?? PRank.currentAge {
                        Text("Age: \(age)")
                    }
                    Text("Weight: \(PRank.weightKg, specifier: "%.1f") kg (\(PRank.weightLbs, specifier: "%.1f") lbs)")
                    Text("Height: \(PRank.heightFt, specifier: "%.2f") ft")
                }

                Divider()

                // Sección de Personal Records (PRs)
                Text("Personal Records (PRs)")
                    .font(.headline)
                VStack(alignment: .leading, spacing: 8) {
                    if let benchPR = PRank.prBenchPressKg {
                        Text("Bench Press: \(benchPR, specifier: "%.1f") kg (\(PRank.prBenchPressLbs ?? 0, specifier: "%.1f") lbs)")
                    }
                    if let squatPR = PRank.prBarbellSquatKg {
                        Text("Barbell Squat: \(squatPR, specifier: "%.1f") kg (\(PRank.prBarbellSquatLbs ?? 0, specifier: "%.1f") lbs)")
                    }
                    if let hipThrustPR = PRank.prHipThrustKg {
                        Text("Hip Thrust: \(hipThrustPR, specifier: "%.1f") kg (\(PRank.prHipThrustLbs ?? 0, specifier: "%.1f") lbs)")
                    }
                    if let legPressPR = PRank.prLegPressKg {
                        Text("Leg Press: \(legPressPR, specifier: "%.1f") kg (\(PRank.prLegPressLbs ?? 0, specifier: "%.1f") lbs)")
                    }
                }
            }
            .padding()
        }
        .navigationTitle(PRank.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
