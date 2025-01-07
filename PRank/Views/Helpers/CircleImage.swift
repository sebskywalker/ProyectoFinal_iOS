//
//  CircleImage.swift
//  PRank
//
//  Created by seb's on 11/12/24.
//

import SwiftUI

struct CircleImage: View {
    
    var image: Image
    
    var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fill) // Asegura que se llene el círculo sin distorsión
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.white, lineWidth: 7)
            )
            .shadow(radius: 7)
    }
}

#Preview {
    CircleImage(image: Image("samsulek"))
}

