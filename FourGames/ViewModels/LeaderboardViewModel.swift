//
//  LeaderboardViewModel.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 27/01/2025.
//

import Foundation

class LeaderboardViewModel: ObservableObject {
    func adjustLogoWidth() -> CGFloat {
        let width = screenSize.width * 0.89
        if width > 550 {return 550}
        return width
    }
}
