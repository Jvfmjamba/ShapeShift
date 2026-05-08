//
//  OnboardingView.swift
//  ShapeShift
//
//  Created by Joáo Vitor Franca on 07/05/26.
//
import SwiftData
import SwiftUI

struct OnboardingView: View {
    //aponta pro banco de dados
    @Environment(\.modelContext) private var modelContext
    //salva oque é digitado em tempo real
    @State private var name: String = ""
    @State private var weightkg: String = ""
    @State private var heightcm: String = ""
    @State private var age: String = ""
    @State private var goalweightkg: String = ""
    
    var body: some View {
        NavigationStack{
            Form{
                Section("Sobre você"){
                    TextField("Nome", text: $name)
                    TextField("Idade", text: $age)
                }
                Section("Suas medidas"){
                    TextField("Peso atual (kg)", text: $weightkg)
                    TextField("Altura (cm)", text: $heightcm)
                }
                Section("Meta"){
                    TextField("Meta de peso", text: $goalweightkg)
                }
                Button("Começar jornada!"){
                    saveProfile()
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(.borderedProminent)
                .disabled(name.isEmpty || weightkg.isEmpty)
            }
            .navigationTitle("ShapeShift")
        }
    }
    private func saveProfile(){//converte as entradas para os tipos certos
        let weightkgDouble = Double(weightkg) ?? 0.0
        let heightcmDouble = Double(heightcm) ?? 0.0
        let ageInt = Int(age) ?? 0
        let goalwheightkgDouble = Double(goalweightkg) ?? 0.0
        
        let newProfile = UserProfile(//cria o perfil com base na conversao
            name: name,
            age: ageInt,
            heightcm: heightcmDouble,
            weightkg: weightkgDouble,
            goalweightkg: goalwheightkgDouble
        )
        modelContext.insert(newProfile)
    }
}
