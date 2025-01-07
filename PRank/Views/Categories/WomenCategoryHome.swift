//
//  WomenCategoryHome.swift
//  PRank
//
//  Created by seb's on 11/25/24.
//

import SwiftUI

struct WomenCategoryHome: View {
    @EnvironmentObject var modelData: ModelData
    @State private var currentIndex = 0
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Carrusel de imágenes
                    TabView(selection: $currentIndex) {
                        ForEach(5..<9) { index in
                            Image("Feature\(index)")
                                .resizable()
                                .scaledToFill()
                                .frame(height: 250)
                                .clipped()
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                    }
                    .frame(height: 250)
                    .tabViewStyle(PageTabViewStyle())
                    .onReceive(timer) { _ in
                        withAnimation {
                            currentIndex = (currentIndex + 1) % 4
                        }
                    }

                    // Categorías en orden especificado
                    ForEach(modelData.categoryOrder.map { $0.rawValue }, id: \.self) { key in
                        if let items = modelData.womenCategories[key] {
                            UnifiedCategoryRow(
                                categoryName: key,
                                items: items,
                                isForMen: false
                            )
                            .background(Color("Background1"))
                        }
                    }
                }
            }
            .background(Color("Background1"))
            .navigationTitle("Women")
        }
    }
}

struct WomenCategoryHome_Previews: PreviewProvider {
    static var previews: some View {
        WomenCategoryHome()
            .environmentObject(ModelData())
    }
}
