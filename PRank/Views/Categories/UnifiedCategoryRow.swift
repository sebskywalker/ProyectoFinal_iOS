//
//  UnifiedCategoryRow.swift
//  PRank
//
//  Created by seb's on 11/25/24.
//

import SwiftUI

struct UnifiedCategoryRow: View {
    var categoryName: String
    var items: [PRank]
    var isForMen: Bool // Agregado el parámetro faltante

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(categoryName)
                .font(.headline)
                .foregroundColor(Color("Light"))
                .padding(.leading, 15)
                .padding(.top, 5)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 15) {
                    ForEach(items) { PRank in
                        NavigationLink(destination: PRankDetail(PRank: PRank, isForMen: true)) {
                            CategoryItem(PRank: PRank)
                        }
                    }
                }
                .padding(.horizontal, 15)
            }
            .frame(height: 200) // Ajusta el tamaño para mantener consistencia
            .background(Color("Background1")) // Fondo consistente
        }
    }
}

struct UnifiedCategoryRow_Previews: PreviewProvider {
    static var modelData = ModelData()

    static var previews: some View {
        UnifiedCategoryRow(
            categoryName: "Legend",
            items: Array(modelData.menPRanks.prefix(3)),
            isForMen: true // Proporciona el valor necesario
        )
        .environmentObject(modelData)
        .previewLayout(.sizeThatFits)
        .background(Color("Background1"))
    }
}
