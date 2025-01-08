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
    @Binding var alias: String
    @Binding var birthdate: Date
    @Binding var benchPressPR: Double?
    @Binding var squatPR: Double?
    @Binding var deadliftPR: Double?
    
    @State private var isProfileSaved = false
    @State private var imagePickerPresented = false
    @State private var isEditing = false  // Estado para habilitar la edición de campos
    
    var body: some View {
        VStack {
            Text("Mi Perfil")
                .font(.largeTitle)
                .padding()
            
            // Mostrar la imagen seleccionada
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .padding()
            } else {
                Image(systemName: "photo.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .padding()
            }
            
            // Mostrar datos del perfil guardado o formulario de edición
            if isProfileSaved && !isEditing {
                VStack {
                    Text("Nombre: \(profileName)")
                    Text("Alias: \(alias)")
                    Text("Fecha de nacimiento: \(birthdate, style: .date)")
                    
                    // Mostrar PRs solo si tienen valor
                    Text("Bench Press PR: \(benchPressPR != nil ? "\(benchPressPR!, specifier: "%.2f") kg" : "")")
                    Text("Squat PR: \(squatPR != nil ? "\(squatPR!, specifier: "%.2f") kg" : "")")
                    Text("Deadlift PR: \(deadliftPR != nil ? "\(deadliftPR!, specifier: "%.2f") kg" : "")")
                }
                .padding()
                
                // Botón para editar el perfil
                Button("Editar") {
                    isEditing = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            } else {
                // Si está editando o no ha guardado, mostrar el formulario
                Form {
                    Section(header: Text("Perfil")) {
                        TextField("Nombre", text: $profileName)
                            .foregroundColor(profileName.isEmpty ? .gray : .primary)
                        TextField("Alias", text: $alias)
                            .foregroundColor(alias.isEmpty ? .gray : .primary)
                        DatePicker("Fecha de nacimiento", selection: $birthdate, displayedComponents: .date)
                        TextField("Bench Press PR", value: $benchPressPR, format: .number)
                            .foregroundColor(benchPressPR == nil ? .gray : .primary)
                        TextField("Squat PR", value: $squatPR, format: .number)
                            .foregroundColor(squatPR == nil ? .gray : .primary)
                        TextField("Deadlift PR", value: $deadliftPR, format: .number)
                            .foregroundColor(deadliftPR == nil ? .gray : .primary)
                    }
                    
                    Section {
                        Button(action: {
                            // Guardamos el perfil
                            isProfileSaved = true
                            isEditing = false
                        }) {
                            Text("Guardar Perfil")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    
                    Section {
                        Button("Seleccionar Foto") {
                            imagePickerPresented.toggle()
                        }
                        .sheet(isPresented: $imagePickerPresented) {
                            ImagePicker(selectedImage: $selectedImage)
                        }
                    }
                }
            }
        }
        .padding()
    }
}
