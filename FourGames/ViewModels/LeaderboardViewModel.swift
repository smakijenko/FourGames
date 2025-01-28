//
//  LeaderboardViewModel.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 27/01/2025.
//

import Foundation
import SwiftUI

class LeaderboardViewModel: ObservableObject {
    @Published var selectedGameType: GameType = .run
    @Published var tabIndicatorOffset: CGFloat = -3
    enum GameType: String, Identifiable {
        case run, words, labyrinth, tower
        var id: String { rawValue }
    }
    let tabMenuHeight: CGFloat = 40
    let gameIconSize: CGFloat = 30
    
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
}
