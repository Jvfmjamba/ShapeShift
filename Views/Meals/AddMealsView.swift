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
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var isAnalyzing: Bool = false
    @State private var useAI: Bool = true
    @State private var errorMessage: String? = nil
    @State private var foodItems: [EditableFoodItem] = []

    var totalCalories: Double { foodItems.reduce(0) { $0 + $1.calories } }
    var totalProtein: Double { foodItems.reduce(0) { $0 + $1.protein } }
    var totalCarbs: Double { foodItems.reduce(0) { $0 + $1.carbs } }
    var totalFat: Double { foodItems.reduce(0) { $0 + $1.fat } }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Nome da refeição", text: $mealName)
                }

                Section {
                    Toggle("Usar IA para analisar", isOn: $useAI)
                }

                if useAI {
                    Section(header: Text("Foto e descrição")) {
                        PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
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

                        TextField("Descrição opcional (ex: 150g arroz, frango grelhado)", text: $description, axis: .vertical)
                            .lineLimit(3)

                        Button {
                            Task { await analyzeWithAI() }
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
                        .disabled((selectedImage == nil && description.isEmpty) || isAnalyzing)
                    }
                }

                if !foodItems.isEmpty {
                    Section(header: Text("Alimentos")) {
                        if let error = errorMessage {
                            Text(error).foregroundStyle(.red).font(.caption)
                        }

                        ForEach($foodItems) { $item in
                            VStack(alignment: .leading, spacing: 8) {
                                TextField("Nome", text: $item.name)
                                    .font(.headline)

                                if useAI {
                                    HStack {
                                        Text("Quantidade (g)")
                                        Spacer()
                                        TextField("0", value: $item.weightGrams, format: .number)
                                            .keyboardType(.decimalPad)
                                            .multilineTextAlignment(.trailing)
                                            .frame(width: 80)
                                    }
                                    HStack {
                                        Text("Calorias (kcal)")
                                        Spacer()
                                        Text("\(item.calories, specifier: "%.0f")").foregroundStyle(.secondary)
                                    }
                                    HStack {
                                        Text("Proteína (g)")
                                        Spacer()
                                        Text("\(item.protein, specifier: "%.1f")").foregroundStyle(.secondary)
                                    }
                                    HStack {
                                        Text("Carbo (g)")
                                        Spacer()
                                        Text("\(item.carbs, specifier: "%.1f")").foregroundStyle(.secondary)
                                    }
                                    HStack {
                                        Text("Gordura (g)")
                                        Spacer()
                                        Text("\(item.fat, specifier: "%.1f")").foregroundStyle(.secondary)
                                    }
                                } else {
                                    HStack {
                                        Text("Calorias (kcal)")
                                        Spacer()
                                        TextField("0", value: $item.manualCalories, format: .number)
                                            .keyboardType(.decimalPad)
                                            .multilineTextAlignment(.trailing)
                                            .frame(width: 80)
                                    }
                                    HStack {
                                        Text("Proteína (g)")
                                        Spacer()
                                        TextField("0", value: $item.manualProtein, format: .number)
                                            .keyboardType(.decimalPad)
                                            .multilineTextAlignment(.trailing)
                                            .frame(width: 80)
                                    }
                                    HStack {
                                        Text("Carbo (g)")
                                        Spacer()
                                        TextField("0", value: $item.manualCarbs, format: .number)
                                            .keyboardType(.decimalPad)
                                            .multilineTextAlignment(.trailing)
                                            .frame(width: 80)
                                    }
                                    HStack {
                                        Text("Gordura (g)")
                                        Spacer()
                                        TextField("0", value: $item.manualFat, format: .number)
                                            .keyboardType(.decimalPad)
                                            .multilineTextAlignment(.trailing)
                                            .frame(width: 80)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete { indexSet in
                            foodItems.remove(atOffsets: indexSet)
                        }
                    }

                    Section(header: Text("Total da refeição")) {
                        HStack {
                            VStack {
                                Text("\(totalCalories, specifier: "%.0f")").font(.title2).bold()
                                Text("kcal").font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            VStack {
                                Text("\(totalProtein, specifier: "%.1f")g").font(.title3).bold()
                                Text("Proteína").font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            VStack {
                                Text("\(totalCarbs, specifier: "%.1f")g").font(.title3).bold()
                                Text("Carbo").font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            VStack {
                                Text("\(totalFat, specifier: "%.1f")g").font(.title3).bold()
                                Text("Gordura").font(.caption).foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }

                if !useAI {
                    Section {
                        Button {
                            foodItems.append(EditableFoodItem(
                                name: "",
                                weightGrams: 0,
                                caloriesPer100g: 0,
                                proteinPer100g: 0,
                                carbsPer100g: 0,
                                fatPer100g: 0
                            ))
                        } label: {
                            Label("Adicionar alimento", systemImage: "plus")
                        }
                    }
                }

                Section {
                    Button("Salvar refeição") {
                        saveMeal()
                    }
                    .disabled(mealName.isEmpty || foodItems.isEmpty)
                }
            }
            .navigationTitle("Nova refeição")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") { dismiss() }
                }
            }
        }
    }

    func analyzeWithAI() async {
        isAnalyzing = true
        errorMessage = nil

        let descriptionToSend = description.isEmpty ? "Analise a foto" : description

        let result = await geminiService.analyzeMeal(description: descriptionToSend, image: selectedImage)

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

        struct AIItem: Decodable {
            var name: String
            var weightGrams: Double
            var caloriesPer100g: Double
            var proteinPer100g: Double
            var carbsPer100g: Double
            var fatPer100g: Double
        }

        struct AIResponse: Decodable {
            var mealName: String
            var items: [AIItem]
        }

        do {
            let response = try JSONDecoder().decode(AIResponse.self, from: data)
            if mealName.isEmpty { mealName = response.mealName }
            foodItems = response.items.map { item in
                EditableFoodItem(
                    name: item.name,
                    weightGrams: item.weightGrams,
                    caloriesPer100g: item.caloriesPer100g,
                    proteinPer100g: item.proteinPer100g,
                    carbsPer100g: item.carbsPer100g,
                    fatPer100g: item.fatPer100g
                )
            }
        } catch {
            errorMessage = "A IA retornou um formato inesperado. Tente novamente."
        }
    }

    func saveMeal() {
        let newMeal = Meals(name: mealName)

        for item in foodItems {
            let foodItem = FoodItem(
                name: item.name,
                weightGrams: item.weightGrams,
                caloriesPer100g: item.caloriesPer100g,
                proteinPer100g: item.proteinPer100g,
                carbsPer100g: item.carbsPer100g,
                fatPer100g: item.fatPer100g
            )
            foodItem.meal = newMeal
            newMeal.foodItems.append(foodItem)
            modelContext.insert(foodItem)
        }

        modelContext.insert(newMeal)
        dismiss()
    }
}
