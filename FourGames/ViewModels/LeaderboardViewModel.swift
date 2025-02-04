//
//  LeaderboardViewModel.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 27/01/2025.
//

import Foundation
import SwiftUI

class LeaderboardViewModel: ObservableObject {
    @Published var scores: [LeaderboardScoreDataModel] = []
    @Published var selectedGameType: GameType = .run
    @Published var tabIndicatorOffset: CGFloat = -3
    @Published var isAlertOn: Bool = false
    @Published var alertText: String = ""
    enum GameType: String, Identifiable {
        case run, words, labyrinth, tower
        var id: String { rawValue }
    }
    let tabMenuHeight: CGFloat = 40
    let gameIconSize: CGFloat = 30
    let podiumHeight: CGFloat = 100
    let scoreRowHeight: CGFloat = 40
    var scoreRowWidth: CGFloat = 0
    var selectedScore: (LeaderboardScoreDataModel) -> Double = { Double($0.runScore) }
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
                selectedScore = { Double($0.runScore) }
                scores.sort { $0.runScore > $1.runScore }
            case .words:
                tabIndicatorOffset = -8.75
                selectedScore = { Double($0.wordsScore) }
                scores.sort { $0.wordsScore < $1.wordsScore }
                zerosToEnd {$0.wordsScore}
            case .labyrinth:
                tabIndicatorOffset = 8.75
                selectedScore = { Double($0.mazeScore) }
                scores.sort { $0.mazeScore < $1.mazeScore }
                zerosToEnd {$0.mazeScore}
            case .tower:
                tabIndicatorOffset = 3
                selectedScore = { Double($0.towerScore) }
                scores.sort { $0.towerScore > $1.towerScore }
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
        var leaderScores: [LeaderboardScoreDataModel] = []
        scores = try await AuthManager.shared.fetchAllScores()
        for score in scores {
            let authUser = try await AuthManager.shared.getAuthUserDataFromDB(uId: score.uid)
            leaderScores.append(LeaderboardScoreDataModel (
                uId: score.uid,
                photoUrl: authUser.photoUrl,
                name: authUser.name,
                runScore: score.runScore,
                wordsScore: score.wordsScore,
                mazeScore: score.mazeScore,
                towerScore: score.towerScore
            ))
        }
        DispatchQueue.main.sync {
            self.scores = leaderScores
            self.scores.sort { $0.runScore > $1.runScore }
        }
        // Can throw .unableFetchAllScores
    }
    
    private func zerosToEnd(category: (LeaderboardScoreDataModel) -> Double) {
        scores.sort {
            let first = category($0)
            let second = category($1)
            return (first == 0 ? 1 : 0) < (second == 0 ? 1 : 0)
        }
    }
}
