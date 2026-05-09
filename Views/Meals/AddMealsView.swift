//
//  MealsView.swift
//  ShapeShift
//
//  Created by Joáo Vitor Franca on 07/05/26.
//
// AddMealView.swift
// Essa é a tela onde o usuário registra uma nova refeição.
// Ela tem dois caminhos:
// 1. Usar a IA: manda foto e/ou descrição, a IA preenche os macros
// 2. Manual: o usuário preenche tudo na mão

import SwiftUI
import PhotosUI

struct AddMealView: View {

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var geminiService = GeminiService()

    @State private var mealName: String = ""

    @State private var description: String = ""

    @State private var calories: String = ""
    @State private var protein: String = ""
    @State private var carbs: String = ""
    @State private var fat: String = ""

    @State private var selectedPhotoItem: PhotosPickerItem? = nil

    @State private var selectedImage: UIImage? = nil

    @State private var isAnalyzing: Bool = false

    @State private var useAI: Bool = true

    @State private var errorMessage: String? = nil

    var body: some View {

        NavigationStack {

            Form {

                Section(header: Text("Refeição")) {
                    TextField("Nome da refeição", text: $mealName)
                }

                Section {
                    Toggle("Usar IA para analisar", isOn: $useAI)
                }

                if useAI {

                    Section(header: Text("Foto e descrição")) {

                        PhotosPicker(
                            selection: $selectedPhotoItem,
                            matching: .images
                        ) {

                            if let image = selectedImage {

                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 200)
                                    .cornerRadius(10)

                            } else {

                                Label("Escolher foto", systemImage: "photo")
                            }
                        }
                        .onChange(of: selectedPhotoItem) {
                            Task {
                                if let item = selectedPhotoItem,
                                   let data = try? await item.loadTransferable(type: Data.self),
                                   let image = UIImage(data: data) {
                                    selectedImage = image
                                }
                            }
                        }

                        TextField(
                            "Descrição opcional (ex: frango grelhado com arroz)",
                            text: $description,
                            axis: .vertical
                        )
                        .lineLimit(3)

                        Button {
                            Task {
                                await analyzeWithAI()
                            }
                        } label: {
                            if isAnalyzing {
                                HStack {
                                    ProgressView()
                                    Text("Analisando...")
                                }
                            } else {
                                Text("Analisar com IA")
                            }
                        }
                        .disabled(selectedImage == nil && description.isEmpty || isAnalyzing)
                    }
                }

                Section(header: Text("Informações nutricionais")) {
                    if let error = errorMessage {
                        Text(error)
                            .foregroundStyle(.red)
                            .font(.caption)
                    }

                    HStack {
                        Text("Calorias (kcal)")
                        Spacer()
                        TextField("0", text: $calories)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }

                    HStack {
                        Text("Proteína (g)")
                        Spacer()
                        TextField("0", text: $protein)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }

                    HStack {
                        Text("Carboidrato (g)")
                        Spacer()
                        TextField("0", text: $carbs)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }

                    HStack {
                        Text("Gordura (g)")
                        Spacer()
                        TextField("0", text: $fat)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }

                Section {
                    Button("Salvar refeição") {
                        saveMeal()
                    }
                    .disabled(mealName.isEmpty)
                }
            }
            .navigationTitle("Nova refeição")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
        }
    }

    func analyzeWithAI() async {

        isAnalyzing = true
        errorMessage = nil

        let descriptionToSend = description.isEmpty ? "Refeição sem descrição" : description


        let result = await geminiService.analyzeMeal(
            description: descriptionToSend,
            image: selectedImage
        )

        isAnalyzing = false

        if let jsonString = result {
            parseAIResponse(jsonString)
        } else {
            errorMessage = "Não foi possível analisar. Tente novamente."
        }
    }

    func parseAIResponse(_ jsonString: String) {

        
        guard let data = jsonString.data(using: .utf8) else {
            errorMessage = "Erro ao ler a resposta da IA."
            return
        }

        
        struct AIResponse: Decodable {
            var name: String
            var calories: Double
            var protein: Double
            var carbs: Double
            var fat: Double
        }

        do {
            let response = try JSONDecoder().decode(AIResponse.self, from: data)

            if mealName.isEmpty {
                mealName = response.name
            }

            calories = String(format: "%.0f", response.calories)
            protein = String(format: "%.1f", response.protein)
            carbs = String(format: "%.1f", response.carbs)
            fat = String(format: "%.1f", response.fat)

        } catch {
            errorMessage = "A IA retornou um formato inesperado. Preencha manualmente."
        }
    }
    
    func saveMeal() {
        let caloriesValue = Double(calories) ?? 0
        let proteinValue = Double(protein) ?? 0
        let carbsValue = Double(carbs) ?? 0
        let fatValue = Double(fat) ?? 0

        let newMeal = Meals(
            name: mealName,
            calories: caloriesValue,
            protein: proteinValue,
            carbs: carbsValue,
            fat: fatValue
        )

        
        modelContext.insert(newMeal)

        dismiss()
    }
}
