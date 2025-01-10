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
    @Binding var gender: String
    @Binding var category: String
    @Binding var benchPressPR: Double
    @Binding var isProfileSaved: Bool

    @State private var imagePickerPresented: Bool = false

    let benchPressOptions = Array(stride(from: 0.0, through: 250.0, by: 10.0))

    var body: some View {
        VStack {
            // ✅ Campo para el nombre
            TextField("Nombre", text: $profileName)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)

            // ✅ Selector de género
            Picker("Género", selection: $gender) {
                Text("Hombre").tag("Men")
                Text("Mujer").tag("Women")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            // ✅ Selector de Bench Press PR
            Picker("Bench Press PR", selection: $benchPressPR) {
                ForEach(benchPressOptions, id: \.self) { weight in
                    Text("\(Int(weight)) kg").tag(weight)
                }
            }
            .onChange(of: benchPressPR) { newValue in
                updateCategory(for: newValue)
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: 150)
            .padding()

            // ✅ Imagen seleccionada o ícono por defecto
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

            // ✅ Botón para seleccionar imagen
            Button("Seleccionar Foto") {
                imagePickerPresented.toggle()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            // ✅ Botón para guardar el perfil
            Button("Guardar Perfil") {
                PersistenceController.shared.saveProfile(
                    name: profileName,
                    gender: gender,
                    category: category,
                    benchPressPR: benchPressPR,
                    profileImage: selectedImage
                ) { newPRank in
                    ModelData.shared.addProfile(newPRank, isForMen: gender == "Men")
                    isProfileSaved = true
                }
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .sheet(isPresented: $imagePickerPresented) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }

    // ✅ Actualiza la categoría automáticamente según el peso ingresado
    private func updateCategory(for weight: Double) {
        switch weight {
        case 200...:
            category = "Legend"
        case 150..<200:
            category = "Top Global"
        case 100..<150:
            category = "Professional"
        case 70..<100:
            category = "Elite"
        case 40..<70:
            category = "Intermediate"
        default:
            category = "Beginner"
        }
    }
}
