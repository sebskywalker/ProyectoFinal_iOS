//
//  CategoryItem.swift
//  PRank
//
//  Created by seb's on 11/16/24.
//

import SwiftUI

struct CategoryItem: View {
    var PRank: PRank // Elemento individual

    var body: some View {
        VStack(alignment: .leading) {
            PRank.image
                .renderingMode(.original)
                .resizable()
                .scaledToFill()
                .frame(width: 155, height: 155)
                .cornerRadius(10)
            Text(PRank.name)
                .font(.caption)
                .foregroundColor(Color("Light")) // Ajustar color dinámicamente
        }
        .padding(.leading, 15)
    }
}

struct CategoryItem_Previews: PreviewProvider {
    static var previews: some View {
        let modelData = ModelData()
        return Group {
            // Previsualización para hombres
            CategoryItem(PRank: modelData.menPRanks.first!)
                .environmentObject(modelData)

            // Previsualización para mujeres
            CategoryItem(PRank: modelData.womenPRanks.first!)
                .environmentObject(modelData)
        }
        .previewLayout(.sizeThatFits)
    }
}

