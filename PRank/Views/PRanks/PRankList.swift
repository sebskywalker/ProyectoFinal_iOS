//
//  PRankList.swift
//  PRank
//
//  Created by seb's on 11/14/24.
//

import SwiftUI

struct PRankList: View {
    @EnvironmentObject var modelData: ModelData
    @State private var showFavoriteOnly = false
    
    // Cambiar entre hombres y mujeres según se requiera
    var selectedPRanks: [PRank] {
        modelData.menPRanks // Cambiar a `womenPRanks` si es necesario
    }
    
    var filteredPRanks: [PRank] {
        selectedPRanks.filter { PRank in
            (!showFavoriteOnly || PRank.isFavorite)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $showFavoriteOnly) {
                    Text("Favorite Only")
                }
                
                ForEach(filteredPRanks) { PRank in
                    NavigationLink {
                        PRankDetail(PRank: PRank, isForMen: true) // Pasamos `isForMen`
                    } label: {
                        PRankRowView(PRank: PRank)
                    }
                }
            }
            .navigationBarTitle("PRank")
        }
    }
}

struct PRankList_Previews: PreviewProvider {
    static var modelData = ModelData()
    
    static var previews: some View {
        PRankList()
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
            .environmentObject(modelData)
    }
}
  
