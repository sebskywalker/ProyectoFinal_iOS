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
    @State private var gender: String = "" // Nuevo atributo
    @State private var category: String = "" // Nuevo atributo
    @State private var benchPressPR: Double = 0.0 // Nuevo atributo

    var body: some View {
        NavigationView {
            if isProfileSaved {
                DetailProfileView(
                    profileName: profileName,
                    selectedImage: selectedImage,
                    gender: gender,
                    category: category,
                    benchPressPR: benchPressPR
                )
            } else {
                ProfileView(
                    profileName: $profileName,
                    selectedImage: $selectedImage,
                    gender: $gender,
                    category: $category,
                    benchPressPR: $benchPressPR,
                    isProfileSaved: $isProfileSaved
                )
            }
        }
        .onAppear {
            loadSavedProfile()
        }
    }

    private func loadSavedProfile() {
        if let savedProfile = PersistenceController.shared.loadProfile() {
            profileName = savedProfile.name ?? ""
            gender = savedProfile.gender ?? "No especificado"
            category = savedProfile.category ?? "No especificada"
            benchPressPR = savedProfile.benchPressPR
            if let imageData = savedProfile.profileURL {
                selectedImage = UIImage(data: imageData)
            }
            isProfileSaved = true // Si hay un perfil guardado, mostrar la vista de detalles
        }
    }
}
