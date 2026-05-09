//
//  MealsViews.swift
//  ShapeShift
//
//  Created by Joáo Vitor Franca on 08/05/26.
//
// MealsView.swift
// Essa é a tela principal da aba de refeições.
// Ela mostra o resumo do dia e a lista de refeições registradas.

import SwiftUI
import SwiftData

struct MealsView: View {

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Meals.registeredAt, order: .reverse) private var allMeals: [Meals]

    @State private var showingAddMeal: Bool = false
    @State private var selectedDate: Date = Date()

    var mealsForSelectedDate: [Meals] {
        return allMeals.filter { meal in
            Calendar.current.isDate(meal.registeredAt, inSameDayAs: selectedDate)
        }
    }

    var totalCalories: Double { mealsForSelectedDate.reduce(0) { $0 + $1.totalCalories } }
    var totalProtein: Double { mealsForSelectedDate.reduce(0) { $0 + $1.totalProtein } }
    var totalCarbs: Double { mealsForSelectedDate.reduce(0) { $0 + $1.totalCarbs } }
    var totalFat: Double { mealsForSelectedDate.reduce(0) { $0 + $1.totalFat } }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    DatePicker("Data", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                }

                Section(header: Text("Resumo do dia")) {
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

                Section(header: Text("Refeições")) {
                    if mealsForSelectedDate.isEmpty {
                        Text("Nenhuma refeição registrada nesse dia.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(mealsForSelectedDate) { meal in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(meal.name).font(.headline)
                                Text("\(meal.totalCalories, specifier: "%.0f") kcal · \(meal.totalProtein, specifier: "%.1f")g prot · \(meal.totalCarbs, specifier: "%.1f")g carbo · \(meal.totalFat, specifier: "%.1f")g gord")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                if !meal.foodItems.isEmpty {
                                    Text(meal.foodItems.map { $0.name }.joined(separator: ", "))
                                        .font(.caption2)
                                        .foregroundStyle(.tertiary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                modelContext.delete(mealsForSelectedDate[index])
                            }
                        }
                    }
                }
            }
            .navigationTitle("Refeições")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddMeal = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddMeal) {
                AddMealView()
            }
        }
    }
}
