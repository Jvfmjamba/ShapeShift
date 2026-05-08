//
//  AppState.swift
//  ShapeShift
//
//  Created by Joáo Vitor Franca on 07/05/26.
//
import Foundation

@Observable //salva e atualiza a tela em temp real
class AppState{
    var userProfile: UserProfile? = nil
    var checklistItems: [ChecklistItem] = []
}
