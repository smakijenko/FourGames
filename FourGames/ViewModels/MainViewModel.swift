//
//  MainViewModel.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 16/11/2024.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    @Published var isGameOn: Bool = false
    @Published var viewType: ViewType = .noGame {
        didSet {
            Task {
                try await loadAuthUser()
            }
        }
    }
    @Published var isLogoAnimating: Bool = false
    @Published var iconsAnimating: Bool = false
    @Published var authUser: AuthUserDataModel?
    
    enum ViewType: String, Identifiable {
        case run, words, labyrinth, tower, joinUs, userProfile, leaderboard, noGame
        var id: String { rawValue }
    }
    
    let buttons: [[ViewType]] = [
        [.run, .words],
        [.labyrinth, .tower]
    ]
    
    func adjustLogoWidth() -> CGFloat {
        return adjustButtonSize() * 3.05
    }
    
    func adjustButtonSize() -> CGFloat {
        let scale = screenSize.width / 393
        if 115 * scale > 160 {return 160}
        return 115 * scale
    }
    
    func loadAuthUser() async throws {
        var user: AuthUserDataModel?
            let uId = try AuthManager.shared.getAuthenticatedUser().uid
            user = try await AuthManager.shared.getAuthUserDataFromDB(uId: uId)
            DispatchQueue.main.sync {
                self.authUser = user
            }
        // Can throw .noAuthUser and .unableFetchUserData
    }
}
