//
//  GymMapView.swift
//  PRank
//
//  Created by seb's on 11/27/24.
//
import SwiftUI
import MapKit

struct GymMapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 19.323621, longitude: -99.228773), // Ubicación de Smart Fit San Jerónimo
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) // Zoom cercano
    )
    @State private var gyms: [Gym] = [
        Gym(name: "Smart Fit San Jerónimo", leader: "CBUM", location: CLLocationCoordinate2D(latitude: 19.323621, longitude: -99.228773)),
        Gym(name: "Gym Independencia", leader: "Ronnie Coleman", location: CLLocationCoordinate2D(latitude: 19.3365, longitude: -99.2130)),
        Gym(name: "Fitness Pro", leader: "Arnold Schwarzenegger", location: CLLocationCoordinate2D(latitude: 19.3345, longitude: -99.2150)),
        Gym(name: "Olympus Gym Santa Úrsula", leader: "Fernando Guzman", location: CLLocationCoordinate2D(latitude: 19.2925, longitude: -99.1714)),
        Gym(name: "Powerhouse Gym", leader: "Jay Cutler", location: CLLocationCoordinate2D(latitude: 19.2830, longitude: -99.1800)),
        Gym(name: "Gold's Gym", leader: "Dorian Yates", location: CLLocationCoordinate2D(latitude: 19.2855, longitude: -99.1900)),
        Gym(name: "Beast Mode Fitness", leader: "Kai Greene", location: CLLocationCoordinate2D(latitude: 19.3000, longitude: -99.2000)),
        Gym(name: "Iron Paradise", leader: "The Rock", location: CLLocationCoordinate2D(latitude: 19.3100, longitude: -99.2100)),
        Gym(name: "Titan Gym", leader: "Phil Heath", location: CLLocationCoordinate2D(latitude: 19.3200, longitude: -99.2200))
    ]
    @State private var selectedGym: Gym? = nil // Gimnasio seleccionado
    @State private var showLeaderView = false // Controla la vista emergente

    var body: some View {
        ZStack(alignment: .top) {
            // Mapa
            Map(coordinateRegion: $region, annotationItems: gyms) { gym in
                MapAnnotation(coordinate: gym.location) {
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            selectedGym = gym
                            showLeaderView = true
                        }
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

            // Barra de selección tipo scroll
            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(gyms) { gym in
                            Button(action: {
                                withAnimation {
                                    selectedGym = gym
                                    region.center = gym.location // Actualiza la ubicación en el mapa
                                }
                            }) {
                                Text(gym.name)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(selectedGym == gym ? Color.blue : Color.gray.opacity(0.7))
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                    .font(.caption)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.8))

                // Vista emergente para mostrar al líder del gimnasio
                if showLeaderView, let gym = selectedGym {
                    GymLeaderView(gym: gym, showLeaderView: $showLeaderView)
                        .transition(.asymmetric(insertion: .move(edge: .top), removal: .opacity))
                        .animation(.easeInOut, value: showLeaderView)
                }

                Spacer()
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
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
