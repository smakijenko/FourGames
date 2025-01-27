//
//  UserProfileViewModel.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 17/01/2025.
//

import Foundation

class UserProfileViewModel: ObservableObject {
    @Published var authUser: AuthUserDataModel?
    @Published var authProvider: AuthProviderOption = .google
    @Published var authUserScores: UserScoresDataModel?
    @Published var bestScores: UserScoresDataModel?
    @Published var chartsOn: Bool = false
    let chartWidth: CGFloat = 50
    
    func setProvider() throws {
        let provider = try AuthManager.shared.getProviders().first
        guard let provider = provider else { return }
        authProvider = provider
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
    
    func loadScores() async throws {
        var userScores: UserScoresDataModel?
        var bestScores: UserScoresDataModel?
        do {
            let uId = try AuthManager.shared.getAuthenticatedUser().uid
            userScores = try await AuthManager.shared.fetchUserScore(uId: uId)
            bestScores = try await AuthManager.shared.fetchBestScore()
            DispatchQueue.main.sync {
                self.authUserScores = userScores
                self.bestScores = bestScores
                chartsOn = true
            }
        }
        catch {
            DispatchQueue.main.sync {
                self.authUserScores = nil
                self.bestScores = nil
            }
        }
    }
    
    func adjustLogoWidth() -> CGFloat {
        let width = screenSize.width * 0.89
        if width > 550 {return 550}
        return width
    }
    
    func adjustChartSize() -> CGFloat {
        let scale = screenSize.width / 540
        if scale > 1 { return 1 }
        return scale
    }
    
    func signOutTask() throws -> Task<Void, Error> {
        Task {
            try AuthManager.shared.signOut()
        }
    }
    
    func deleteTask() throws -> Task<Void, Error> {
        Task {
            try await AuthManager.shared.delete()
        }
    }
    
    func resetTask() throws -> Task<Void, Error> {
        Task {
            guard let email = authUser?.email else { return }
            try await AuthManager.shared.resetPassword(email: email)
        }
    }
}
