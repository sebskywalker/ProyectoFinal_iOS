//
//  DetailProfileView.swift
//  PRank
//
//  Created by seb's on 1/8/25.
//

import SwiftUI

struct DetailProfileView: View {
    @State private var isEditing: Bool = false // Estado para activar la edición

    @State var profileName: String
    @State var selectedImage: UIImage?
    @State var gender: String // Nuevo atributo
    @State var category: String // Nuevo atributo
    @State var benchPressPR: Double // Nuevo atributo

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

            Text("Género: \(gender)")
                .font(.body)
                .padding()

            Text("Categoría: \(category)")
                .font(.body)
                .padding()

            Text("Bench Press PR: \(benchPressPR, specifier: "%.2f") kg")
                .font(.body)
                .padding()

            Spacer()

            // Botón para editar el perfil
            Button("Editar Perfil") {
                isEditing = true
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .sheet(isPresented: $isEditing, onDismiss: {
                refreshProfileData() // Actualizamos los datos al salir de la edición
            }) {
                ProfileEditView(
                    profileName: $profileName,
                    selectedImage: $selectedImage,
                    gender: $gender,
                    category: $category,
                    benchPressPR: $benchPressPR
                )
            }
        }
        .navigationBarTitle("Perfil Guardado", displayMode: .inline)
    }

    // Método para actualizar los datos desde Core Data
    private func refreshProfileData() {
        if let savedProfile = PersistenceController.shared.loadProfile() {
            profileName = savedProfile.name ?? ""
            gender = savedProfile.gender ?? "No especificado"
            category = savedProfile.category ?? "No especificada"
            benchPressPR = savedProfile.benchPressPR
            if let imageData = savedProfile.profileURL {
                selectedImage = UIImage(data: imageData)
            }
        }
    }
}
