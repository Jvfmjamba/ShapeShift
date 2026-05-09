//
//  AppState.swift
//  ShapeShift
//
//  Created by Joáo Vitor Franca on 07/05/26.
//
// AppState.swift
// O gerenciador central do app.
// Todas as telas buscam e salvam dados aqui.

import Foundation
import SwiftData

// Com SwiftData, o AppState não precisa mais salvar/carregar manualmente.
// O banco de dados faz isso sozinho.
// O AppState agora serve só para guardar estado temporário da UI.
@Observable
class AppState {
    // Por enquanto vazio — podemos adicionar estado de UI aqui futuramente
    // como qual aba está ativa, se um modal está aberto, etc.
}
