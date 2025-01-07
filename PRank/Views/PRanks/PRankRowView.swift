//
//  PRankRow.swift
//  PRank
//
//  Created by seb's on 11/13/24.
//

import SwiftUI

struct PRankRowView: View {
    var PRank: PRank

    var body: some View {
        HStack {
            PRank.image
                .resizable()
                .frame(width: 50, height: 50)
            Text(PRank.name)
            
            Spacer()
            
            if PRank.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
        }
    }
}

struct PRankRowView_Previews: PreviewProvider {
    static var previews: some View {
        let modelData = ModelData()
        return Group {
            // Previsualización para hombres
            PRankRowView(PRank: modelData.menPRanks.first!)
                .previewLayout(.fixed(width: 300, height: 70))
            
            // Previsualización para mujeres
            PRankRowView(PRank: modelData.womenPRanks.first!)
                .previewLayout(.fixed(width: 300, height: 70))
        }
    }
}
//}
