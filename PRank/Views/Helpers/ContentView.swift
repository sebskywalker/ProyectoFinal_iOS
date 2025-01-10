//
//  ContentView.swift
//  PRank
//
//  Created by seb's on 11/12/24.

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

    var body: some View {
        TabView(selection: $selection) {
            CategoryHome()
                .tabItem {
                    Label("Men", systemImage: "person")
                }
                .tag(Tab.men)

            WomenCategoryHome()
                .tabItem {
                    Label("Women", systemImage: "person.fill")
                }
                .tag(Tab.women)

            RankingView(isForMen: true)
                .tabItem {
                    Label("Rankings", systemImage: "chart.bar")
                }
                .tag(Tab.rankings)

            GymMapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(Tab.map)

            ProfileCoordinatorView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle.fill")
                }
                .tag(Tab.profile)
        }
    }
}
