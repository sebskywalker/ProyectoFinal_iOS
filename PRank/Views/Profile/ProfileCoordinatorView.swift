//
//  ProfileCoordinatorView.swift
//  PRank
//
//  Created by seb's on 1/9/25.
//

import SwiftUI

struct ProfileCoordinatorView: View {
    @State private var profileName: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var isProfileSaved: Bool = false

    var body: some View {
        NavigationView {
            if isProfileSaved {
                DetailProfileView(profileName: profileName, selectedImage: selectedImage)
            } else {
                ProfileView(profileName: $profileName, selectedImage: $selectedImage, isProfileSaved: $isProfileSaved)
            }
        }
        .onAppear {
            loadSavedProfile()
        }
    }

    private func loadSavedProfile() {
        if let savedProfile = PersistenceController.shared.loadProfile() {
            profileName = savedProfile.name ?? ""
            if let imageData = savedProfile.profileURL {
                selectedImage = UIImage(data: imageData)
            }
            isProfileSaved = true // Si hay un perfil guardado, mostrar la vista de detalles
        }
    }
}
