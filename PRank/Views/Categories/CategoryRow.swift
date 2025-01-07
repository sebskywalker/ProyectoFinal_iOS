//
//  CategoryRow.swift
//  PRank
//
//  Created by seb's on 11/16/24.
//

import SwiftUI

struct CategoryRow: View {
    var categoryName: String
    var items: [PRank] // Se mantiene genérico para hombres y mujeres
    var isForMen: Bool // Nuevo parámetro para identificar si es para hombres o mujeres

    var body: some View {
        VStack(alignment: .leading) {
            Text(categoryName)
                .font(.headline)
                .foregroundColor(Color("Light")) // Letra blanca
                .padding(.leading, 15)
                .padding(.top, 5)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(items) { PRank in
                        NavigationLink {
                            PRankDetail(PRank: PRank, isForMen: isForMen) // Pasamos el parámetro isForMen
                        } label: {
                            CategoryItem(PRank: PRank) // Mostrar cada item
                        }
                    }
                }
            }
            .frame(height: 180) // Altura del scroll horizontal
        }
        .background(Color("Background1")) // Fondo para toda la fila
    }
}

struct CategoryRow_Previews: PreviewProvider {
    static var modelData = ModelData()

    static var previews: some View {
        CategoryRow(
            categoryName: "Legend",
            items: Array(modelData.menPRanks.prefix(3)), // Proporcionamos ejemplo con hombres
            isForMen: true
        )
        .environmentObject(modelData)
        .previewLayout(.sizeThatFits) // Permite visualizarlo correctamente en el preview
        .background(Color("Background")) // Muestra el fondo configurado
    }
}
