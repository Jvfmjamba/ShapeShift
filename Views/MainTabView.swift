//
//  MainTabView.swift
//  ShapeShift
//
//  Created by Joáo Vitor Franca on 07/05/26.
//
import Foundation
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView{//cria a barra inferior
            HomeView()
                .tabItem{
                    Label("Início", systemImage: "house")
                }
        }
    }
}
