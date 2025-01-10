//
//  ProfileView.swift
//  PRank
//
//  Created by seb's on 1/7/25.
//
import SwiftUI

struct ProfileView: View {
    @Binding var profileName: String
    @Binding var selectedImage: UIImage?
    @Binding var isProfileSaved: Bool

    @State private var imagePickerPresented: Bool = false

    var body: some View {
        VStack {
            TextField("Nombre", text: $profileName)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)

            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .padding()
            } else {
                Image(systemName: "photo.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding()
            }

            Button("Seleccionar Foto") {
                imagePickerPresented.toggle()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            Button("Guardar Perfil") {
                PersistenceController.shared.saveProfile(name: profileName, profileImage: selectedImage)
                isProfileSaved = true // Cambiar el estado para mostrar la vista de detalles
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .navigationBarTitle("Mi Perfil", displayMode: .inline)
        .sheet(isPresented: $imagePickerPresented) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
}
