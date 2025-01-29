//
//  LeaderboardView.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 27/01/2025.
//

import SwiftUI

struct LeaderboardView: View {
    @StateObject private var leaderVm = LeaderboardViewModel()
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack {
            LogoView(logoName: "leaderboard", size: leaderVm.adjustLogoWidth())
            PodiumView()
            Spacer()
            TabMenuView()
        }
        .environmentObject(leaderVm)
        .onAppear {
            Task {
                do {
                    leaderVm.scores = try await AuthManager.shared.fetchAllScores()
                }
                catch {
                    
                }
            }
        }
    }
}

#Preview {
    LeaderboardView()
}
