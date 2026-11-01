//
//  HomeView.swift
//  ShapeShift
//
//  Created by Joáo Vitor Franca on 08/05/26.
//
import SwiftUI
import SwiftData

struct HomeView: View {
    // acessa db
    @Environment(\.modelContext) private var modelContext
    
    //busca perfil
    @Query private var users: [UserProfile]
    
    // busca log diario
    @Query(sort: \DailyLog.date, order: .reverse) private var allLogs: [DailyLog]
    
    // busca/cria log do dia
    private var todayLog: DailyLog {
        let today = Calendar.current.startOfDay(for: Date())
        if let log = allLogs.first(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            return log
        } else {
            let newLog = DailyLog()
            modelContext.insert(newLog)
            return newLog
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {

                    if let user = users.first {
                        VStack {
                            Text("Calorias de Hoje")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                            
                            //progrsso
                            ZStack {
                                Circle()
                                    .stroke(lineWidth: 20)
                                    .opacity(0.2)
                                    .foregroundStyle(.orange)
                                
                                Circle()
                                    .trim(from: 0.0, to: CGFloat(min(todayLog.calConsumed / user.metaCaloricaFinal, 1.0)))
                                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                                    .foregroundStyle(.orange)
                                    .rotationEffect(Angle(degrees: 270))
                                    .animation(.spring, value: todayLog.calConsumed)
                                
                                VStack {
                                    Text("\(Int(todayLog.calConsumed))")
                                        .font(.system(size: 40, weight: .bold, design: .rounded))
                                    Text("de \(Int(user.metaCaloricaFinal)) kcal")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .frame(width: 200, height: 200)
                            .padding()
                        }
                    } else {
                        ContentUnavailableView("Perfil não encontrado", systemImage: "person.fill.questionmark")
                    }
                    
                    // agua
                    VStack(alignment: .leading) {
                        Text("Hidratação")
                            .font(.headline)
                        
                        HStack {
                            Image(systemName: "drop.fill")
                                .foregroundStyle(.blue)
                                .font(.title)
                            
                            ProgressView(value: todayLog.waterConsumed, total: 3.0)
                                .tint(.blue)
                            
                            Text(String(format: "%.1f L", todayLog.waterConsumed))
                                .font(.caption.monospacedDigit())
                        }
                        
                        Button(action: { todayLog.waterConsumed += 0.25 }) {
                            Text("Adicionar 250ml")
                                .frame(maxWidth: .infinity)
                                .padding(10)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(15)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("ShapeShift")
        }
    }
}

//botao reutilizavel
struct QuickAddButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: icon)
                Text(title)
                    .font(.footnote)
                    .bold()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(color.opacity(0.1))
            .foregroundStyle(color)
            .cornerRadius(12)
        }
    }
}

#Preview {
    HomeView()
}
