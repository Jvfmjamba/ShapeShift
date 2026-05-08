//
//  RootView.swift
//  ShapeShift
//
//  Created by Joáo Vitor Franca on 07/05/26.
//
import Foundation
import SwiftData
import SwiftUI

struct RootView: View{
    @Query private var users: [UserProfile] //busca no db se ja existe user
    
    var body: some View{//se nao tem usuario, mostra a tela de chegada
        if users.isEmpty{
            OnboardingView()
        } else{ //se ja tem usuario ele vai pra tela inicial
            MainTabView()}
    }
}
