//
//  ProfileFormView.swift .swift
//  PRank
//
//  Created by seb's on 1/7/25.
//

import SwiftUI

struct ProfileFormView: View {
    @Binding var profileData: (nickname: String, benchPressPR: String, squatPR: String, deadliftPR: String, birthdate: Date, name: String, occupation: String)
    @State private var profileSaved: Bool = false // Nueva variable para saber si el perfil ha sido guardado

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Perfil")) {
                    TextField("Nombre", text: $profileData.name)
                    TextField("Alias", text: $profileData.nickname)
                    DatePicker("Fecha de nacimiento", selection: $profileData.birthdate, displayedComponents: .date)
                    TextField("Ocupación", text: $profileData.occupation)
                }

                Section(header: Text("PRs")) {
                    TextField("Bench Press PR", text: $profileData.benchPressPR)
                        .keyboardType(.decimalPad)
                    TextField("Squat PR", text: $profileData.squatPR)
                        .keyboardType(.decimalPad)
                    TextField("Deadlift PR", text: $profileData.deadliftPR)
                        .keyboardType(.decimalPad)
                }

                Button(action: {
                    // Guardar perfil
                    if let benchPress = Double(profileData.benchPressPR), let squat = Double(profileData.squatPR), let deadlift = Double(profileData.deadliftPR) {
                        PersistenceController.shared.saveProfile(nickname: profileData.nickname, benchPressPR: benchPress, deadliftPR: deadlift, birthdate: profileData.birthdate, name: profileData.name, occupation: profileData.occupation, squatPR: squat)
                        profileSaved = true // Cambiar el estado al guardar
                    }
                }) {
                    Text("Guardar Perfil")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                }
                .background(
                    NavigationLink(destination: ProfileDetailView(profileData: profileData), isActive: $profileSaved) {
                        EmptyView()
                    }
                )
                .navigationBarTitle("Crear Perfil")
            }
        }
    }
}
