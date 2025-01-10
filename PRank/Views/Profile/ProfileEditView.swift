//
//  ProfileEditView.swift
//  PRank
//
//  Created by seb's on 1/9/25.
//

import SwiftUI

struct ProfileEditView: View {
    @Binding var profileName: String
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode

    @State private var imagePickerPresented: Bool = false

    var body: some View {
        NavigationView {
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

                Button("Guardar Cambios") {
                    // Guardar los cambios
                    PersistenceController.shared.saveProfile(name: profileName, profileImage: selectedImage)
                    
                    // Actualizar directamente los bindings
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .navigationBarTitle("Editar Perfil", displayMode: .inline)
            .sheet(isPresented: $imagePickerPresented) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }
}
