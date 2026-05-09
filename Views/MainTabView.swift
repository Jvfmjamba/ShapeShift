//
//  MainTabView.swift
//  ShapeShift
//
//  Created by Joáo Vitor Franca on 07/05/26.
//
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            //dashboard
            HomeView()
                .tabItem {
                    Label("Início", systemImage: "house")
                }
            //refeicoes
            MealsView()
                .tabItem {
                    Label("Refeições", systemImage: "fork.knife")
                }
            //checklist
            Text("Checklist de Hábitos")
                .tabItem {
                    Label("Hábitos", systemImage: "checklist")
                }
            
            //config
            Text("Configurações")
                .tabItem {
                    Label("Perfil", systemImage: "person.circle")
                }
        }
        .tint(.orange)
    }
}
