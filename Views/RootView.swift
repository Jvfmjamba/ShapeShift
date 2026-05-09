//
//  RootView.swift
//  ShapeShift
//
//  Created by Joáo Vitor Franca on 07/05/26.
//
import SwiftUI
import SwiftData

struct RootView: View {

    //busca todos os usuários salvos no banco
    @Query private var users: [UserProfile]

    var body: some View {
        if users.isEmpty {
            OnboardingView()
        } else {
            MainTabView()
        }
    }
}
