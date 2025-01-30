//
//  LeaderboardViewModel.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 27/01/2025.
//

import Foundation
import SwiftUI

class LeaderboardViewModel: ObservableObject {
    @Published var scores: [UserScoresDataModel] = []
    @Published var selectedGameType: GameType = .run
    @Published var tabIndicatorOffset: CGFloat = -3
    enum GameType: String, Identifiable {
        case run, words, labyrinth, tower
        var id: String { rawValue }
    }
    let tabMenuHeight: CGFloat = 40
    let gameIconSize: CGFloat = 30
    let podiumHeight: CGFloat = 100
    let scoreRowHeight: CGFloat = 40
    var scoreRowWidth: CGFloat = 0
    
    init() {
        scoreRowWidth = adjustLogoWidth() * 0.95
    }
    
    func adjustLogoWidth() -> CGFloat {
        let width = screenSize.width * 0.89
        if width > 550 {return 550}
        return width
    }
    
    func setTabIndicatorPos() {
        withAnimation(.easeInOut(duration: 0.25)) {
            switch self.selectedGameType {
            case .run:
                tabIndicatorOffset = -3
            case .words:
                tabIndicatorOffset = -8.75
            case .labyrinth:
                tabIndicatorOffset = 8.75
            case .tower:
                tabIndicatorOffset = 3
            }
        }
    }
    
    func formatNumberForRow(num: Double) -> String {
        if num.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", num)
        } else {
            return String(format: "%.1f", num)
        }
    }
    
    func loadAllScores() async throws {
        var scores: [UserScoresDataModel] = []
        scores = try await AuthManager.shared.fetchAllScores()
        DispatchQueue.main.sync {
            self.scores = scores
        }
        // Can throw .unableFetchAllScores
    }
}
