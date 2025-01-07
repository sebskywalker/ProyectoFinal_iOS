//
//  ProfileView.swift
//  PRank
//
//  Created by seb's on 1/7/25.
//

import SwiftUI

struct ProfileView: View {
    // Variables del perfil del usuario
    @State private var profileData: (nickname: String, benchPressPR: String, squatPR: String, deadliftPR: String, birthdate: Date, name: String, occupation: String)

    var body: some View {
        NavigationView {
            Form {
                // Campos para editar el perfil
                Section(header: Text("Perfil")) {
                    Text("Nombre: \(profileData.name)")
                    Text("Alias: \(profileData.nickname)")
                    Text("Fecha de nacimiento: \(profileData.birthdate, style: .date)")
                    Text("Ocupación: \(profileData.occupation)")
                }

                Section(header: Text("PRs")) {
                    Text("Bench Press: \(profileData.benchPressPR)")
                    Text("Squat: \(profileData.squatPR)")
                    Text("Deadlift: \(profileData.deadliftPR)")
                }

                Button(action: {
                    // Aquí iría la lógica para guardar el perfil
                    saveProfile()
                }) {
                    Text("Guardar Perfil")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Mi Perfil")
        }
    }

    func saveProfile() {
        // Aquí deberías agregar la lógica para guardar el perfil del usuario
        print("Perfil guardado: \(profileData.name), \(profileData.nickname), \(profileData.birthdate), \(profileData.occupation)")
    }
}


