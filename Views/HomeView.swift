//
//  HomeView.swift
//  ShapeShift
//
//  Created by Joáo Vitor Franca on 08/05/26.
//
import SwiftUI
import SwiftData

struct HomeView: View {
    //busca o usuário no banco de dados
    @Query private var users: [UserProfile]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    
                    //header: saudação e meta
                    if let user = users.first {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("E aí, \(user.name)!")
                                .font(.system(.title, design: .rounded))
                                .fontWeight(.bold)
                            
                            let faltam = user.weightkg - user.goalweightkg
                            Text("Faltam **\(String(format: "%.1f", faltam))kg** para sua meta")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    }

                    //dashboard: de dailycal
                    VStack(spacing: 15) {
                        HStack {
                            Text("Calorias de Hoje")
                                .font(.headline)
                            Spacer()
                            Text("Meta: 2200 kcal")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        ProgressView(value: 1200, total: 2200)
                            .tint(.orange)
                            .scaleEffect(x: 1, y: 2, anchor: .center)
                        
                        Text("1200 / 2200 kcal")
                            .font(.system(.title2, design: .rounded))
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(20)
                    .padding(.horizontal)

                    HStack(spacing: 15) {
                        StatusCard(title: "Água", value: "1.5L", icon: "drop.fill", color: .blue)
                        
                        //exibe peso puxado do db
                        let pesoAtual = users.first?.weightkg ?? 0.0
                        StatusCard(title: "Peso", value: "\(String(format: "%.1f", pesoAtual))kg", icon: "scalemass.fill", color: .green)
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
            }
            .navigationTitle("ShapeShift")
        }
    }
}

struct StatusCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(color)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(15)
    }
}
