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
    @Binding var gender: String
    @Binding var category: String
    @Binding var benchPressPR: Double
    @Environment(\.presentationMode) var presentationMode

    @State private var imagePickerPresented: Bool = false

    let benchPressOptions = Array(stride(from: 0.0, through: 250.0, by: 10.0))

    var body: some View {
        NavigationView {
            VStack {
                TextField("Nombre", text: $profileName)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal)

                Picker("Género", selection: $gender) {
                    Text("Hombre").tag("Men")
                    Text("Mujer").tag("Women")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

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

                Text("Categoría: \(category)")
                    .font(.title3)
                    .padding()

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
                    PersistenceController.shared.saveProfile(
                        name: profileName,
                        gender: gender,
                        category: category,
                        benchPressPR: benchPressPR,
                        profileImage: selectedImage
                    ) { newPRank in  // ✅ Se añadió el parámetro completion
                        // ✅ Actualizar los datos en tiempo real
                        ModelData.shared.addProfile(newPRank, isForMen: gender == "Men")
                        
                        // ✅ Cerrar la vista después de guardar
                        presentationMode.wrappedValue.dismiss()
                    }
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
