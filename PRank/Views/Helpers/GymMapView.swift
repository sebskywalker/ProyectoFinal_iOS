//
//  GymMapView.swift
//  PRank
//
//  Created by seb's on 11/27/24.
//
import SwiftUI
import MapKit

struct GymMapView: View {
    @State private var searchText: String = ""
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 19.323621, longitude: -99.228773), // Ubicación de Smart Fit San Jerónimo
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) // Zoom cercano
    )
    @State private var gyms: [Gym] = [
        Gym(name: "Smart Fit San Jerónimo", leader: "CBUM", location: CLLocationCoordinate2D(latitude: 19.323621, longitude: -99.228773)),
        Gym(name: "Gym Independencia", leader: "Ronnie Coleman", location: CLLocationCoordinate2D(latitude: 19.3365, longitude: -99.2130)),
        Gym(name: "Fitness Pro", leader: "Arnold Schwarzenegger", location: CLLocationCoordinate2D(latitude: 19.3345, longitude: -99.2150)),
        Gym(name: "Olympus Gym Santa Úrsula", leader: "Fernando Guzman", location: CLLocationCoordinate2D(latitude: 19.2925, longitude: -99.1714)) // Coordenadas actualizadas
    ]
    @State private var selectedGym: Gym? = nil // Gimnasio seleccionado
    @State private var showLeaderView = false // Controla la vista emergente

    var filteredGyms: [Gym] {
        if searchText.isEmpty {
            return gyms
        } else {
            return gyms.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            // Mapa
            Map(coordinateRegion: $region, annotationItems: filteredGyms) { gym in
                MapAnnotation(coordinate: gym.location) {
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            selectedGym = gym
                            showLeaderView = true
                        }
                        // Cierra la vista emergente automáticamente después de 5 segundos
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            if selectedGym == gym {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    showLeaderView = false
                                }
                            }
                        }
                    }) {
                        VStack {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title)
                                .foregroundColor(.red)
                            Text(gym.name)
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .ignoresSafeArea()

            // Barra de búsqueda
            VStack(spacing: 0) {
                HStack {
                    TextField("Search gyms or leaders...", text: $searchText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing)
                        }
                    }
                }
                .padding(.top, 10)

                // Vista emergente para mostrar al líder del gimnasio
                if showLeaderView, let gym = selectedGym {
                    GymLeaderView(gym: gym, showLeaderView: $showLeaderView)
                        .transition(.asymmetric(insertion: .move(edge: .top), removal: .opacity)) // Animación al aparecer/desaparecer
                        .animation(.easeInOut, value: showLeaderView)
                }

                Spacer()
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all)) // Fondo negro
    }
}

struct Gym: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let leader: String
    let location: CLLocationCoordinate2D

    static func ==(lhs: Gym, rhs: Gym) -> Bool {
        lhs.id == rhs.id
    }
}

struct GymLeaderView: View {
    let gym: Gym
    @Binding var showLeaderView: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("🏆 Gym Leader")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        showLeaderView = false
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
            Divider().background(Color.white)

            VStack(alignment: .leading, spacing: 4) {
                Text(gym.leader)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("\(gym.leader) is the leader of \(gym.name)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemGray5).opacity(0.9))
        .cornerRadius(15)
        .padding(.horizontal)
        .shadow(radius: 10)
    }
}

struct GymMapView_Previews: PreviewProvider {
    static var previews: some View {
        GymMapView()
    }
}
