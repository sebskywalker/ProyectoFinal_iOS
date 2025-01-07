//
//  CategoryHome.swift
//  PRank
//
//  Created by seb's on 11/16/24.
//

import SwiftUI

struct CategoryHome: View {
    @EnvironmentObject var modelData: ModelData
    @State private var currentIndex = 0 // Para manejar el índice del carrusel
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Carrusel de imágenes
                    TabView(selection: $currentIndex) {
                        ForEach(1..<5) { index in
                            Image("Feature\(index)") // Asegúrate de tener imágenes nombradas como "Feature1", "Feature2", etc.
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
                        if let items = modelData.menCategories[key] {
                            UnifiedCategoryRow(
                                categoryName: key,
                                items: items,
                                isForMen: true
                            )
                            .background(Color("Background1"))
                        }
                    }
                }
                .background(Color("Background1")) // Fondo gris para todo el contenido
            }
            .background(Color("Background1")) // Fondo gris completo
            .navigationTitle("Men")
        }
    }
}

struct CategoryHome_Previews: PreviewProvider {
    static var previews: some View {
        CategoryHome()
            .environmentObject(ModelData())
    }
}
