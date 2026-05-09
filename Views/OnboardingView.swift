//
//  OnboardingView.swift
//  ShapeShift
//
//  Created by Joáo Vitor Franca on 07/05/26.
//
// OnboardingView.swift
// Tela de cadastro — aparece só na primeira vez que o app abre.
// Quando o usuário salvar, o RootView detecta automaticamente
// e redireciona para o app principal.

import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var name: String = ""
    @State private var age: String = ""
    @State private var weightKg: String = ""
    @State private var heightCm: String = ""
    @State private var goalWeightKg: String = ""
    @State private var isMale: Bool = true

    var body: some View {
        NavigationStack {
            Form {
                Section("Sobre você") {
                    TextField("Nome", text: $name)
                    TextField("Idade", text: $age)
                        .keyboardType(.numberPad)
                }

                Section {
                    Picker("Gênero", selection: $isMale) {
                        Text("Masculino").tag(true)
                        Text("Feminino").tag(false)
                    }
                    .pickerStyle(.segmented)
                }

                Section("Suas medidas") {
                    TextField("Peso atual (kg)", text: $weightKg)
                        .keyboardType(.decimalPad)
                    TextField("Altura (cm)", text: $heightCm)
                        .keyboardType(.decimalPad)
                }

                Section("Meta") {
                    TextField("Meta de peso (kg)", text: $goalWeightKg)
                        .keyboardType(.decimalPad)
                }

                Section {
                    Button("Começar jornada!") {
                        saveProfile()
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.borderedProminent)
                    .disabled(name.isEmpty || weightKg.isEmpty)
                }
            }
            .navigationTitle("ShapeShift")
        }
    }

    private func saveProfile() {
        let newProfile = UserProfile(
            name: name,
            age: Int(age) ?? 0,
            heightCm: Double(heightCm) ?? 0.0,
            weightKg: Double(weightKg) ?? 0.0,
            goalWeightKg: Double(goalWeightKg) ?? 0.0,
            isMale: isMale
        )
        modelContext.insert(newProfile)
        try? modelContext.save()
    }
}
