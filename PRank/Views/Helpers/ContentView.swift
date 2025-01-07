//
//  ContentView.swift
//  PRank
//
//  Created by seb's on 11/12/24.
//
import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .men
    
    enum Tab {
        case men
        case women
        case rankings
        case map
        case profile
    }
    
    // Aquí definimos los datos de perfil, aunque puedes llenarlo con datos predeterminados o vacíos
    @State private var profileData = (nickname: "", benchPressPR: "", squatPR: "", deadliftPR: "", birthdate: Date(), name: "", occupation: "")

    var body: some View {
        TabView(selection: $selection) {
            // Vista de hombres
            CategoryHome()
                .tabItem {
                    Label("Men", systemImage: "person")
                }
                .tag(Tab.men)
            
            // Vista de mujeres
            WomenCategoryHome()
                .tabItem {
                    Label("Women", systemImage: "person.fill")
                }
                .tag(Tab.women)
            
            // Vista de rankings
            RankingView(isForMen: true)
                .tabItem {
                    Label("Rankings", systemImage: "chart.bar")
                }
                .tag(Tab.rankings)
            
            // Nueva vista de mapa
            GymMapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(Tab.map)
            
            // Vista de perfil
            ProfileFormView(profileData: $profileData) // Aquí pasamos el parámetro profileData
                .tabItem {
                    Label("Profile", systemImage: "person.circle.fill")
                }
                .tag(Tab.profile)
        }
        .background(Color("Dark"))
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor(named: "Dark")
            UITabBar.appearance().barTintColor = UIColor(named: "Dark")
            UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
        }
    }
}
