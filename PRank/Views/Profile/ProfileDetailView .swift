//
//  ProfileDetailView .swift
//  PRank
//
//  Created by seb's on 1/7/25.
//

import SwiftUI

struct ProfileDetailView: View {
    // Cambiar a 'public' o 'internal' para que sea accesible
    @State var profileData: (nickname: String, benchPressPR: String, squatPR: String, deadliftPR: String, birthdate: Date, name: String, occupation: String)
    @State private var isEditing: Bool = false // Estado para saber si estamos en edición

    var body: some View {
        VStack(alignment: .leading) {
            Text("Perfil Guardado")
                .font(.title)
                .padding()

            Text("Nombre: \(profileData.name)")
            Text("Alias: \(profileData.nickname)")
            Text("Fecha de nacimiento: \(profileData.birthdate, style: .date)")
            Text("Ocupación: \(profileData.occupation)")

            Text("PRs:")
            Text("Bench Press: \(profileData.benchPressPR)")
            Text("Squat: \(profileData.squatPR)")
            Text("Deadlift: \(profileData.deadliftPR)")

            Button(action: {
                // Lógica para agregar foto
            }) {
                Text("Agregar Foto")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationBarTitle("Mi Perfil", displayMode: .inline)
        .navigationBarItems(leading: Button(action: {
            // Cambiar estado de edición
            isEditing.toggle()
        }) {
            Text("Editar")
                .foregroundColor(.blue)
        })
        .navigationBarBackButtonHidden(true) // Elimina el botón de retroceso
        .sheet(isPresented: $isEditing) {
            // Navega al formulario de edición
            ProfileFormView(profileData: $profileData)  // Se usa un enlace para pasar los datos
        }
    }
}
