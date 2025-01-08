//
//  DetailProfileView.swift
//  PRank
//
//  Created by seb's on 1/8/25.
//

import Foundation
import SwiftUI

struct DetailProfileView: View {
    var profileName: String
    var selectedImage: UIImage?
    
    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .clipShape(Circle())
                    .padding()
            } else {
                Image(systemName: "photo.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .padding()
            }
            
            Text(profileName)
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            Spacer()
        }
        .navigationBarTitle("Perfil Guardado", displayMode: .inline)
    }
}
