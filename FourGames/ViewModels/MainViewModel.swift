//
//  MainViewModel.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 16/11/2024.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    @Published var isGameOn: Bool = false {
       didSet {
           Task {
               try await loadAuthUser()
           }
       }
   }
    @Published var authUser: AuthUserDataModel?
    @Published var viewType: ViewType = .noGame
    @Published var isLogoAnimating: Bool = false
    @Published var iconsAnimating: Bool = false
    @Published var entryAnimation: Bool = false
    
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
        do {
            let uId = try AuthManager.shared.getAuthenticatedUser().uid
            user = try await AuthManager.shared.getAuthUserDataFromDB(uId: uId)
            DispatchQueue.main.sync {
                self.authUser = user
            }
        }
        catch {
            DispatchQueue.main.sync {
                self.authUser = nil
            }
        }
    }
}
