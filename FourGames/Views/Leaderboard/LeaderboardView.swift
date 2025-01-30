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
    @Binding var isGameOn: Bool
    var body: some View {
        VStack {
            LogoView(logoName: "leaderboard", size: leaderVm.adjustLogoWidth())
            PodiumView()
            ScoreRowView(photoUrl: Users().users[3].photoUrl, name: Users().users[3].name, score: 35.7, rank: 4)
            ScoreRowView(photoUrl: Users().users[4].photoUrl, name: Users().users[4].name, score: 31, rank: 5)
            Spacer()
            TabMenuView()
        }
        .environmentObject(leaderVm)
        .onAppear {
            Task {
                do {
                    try await leaderVm.loadAllScores()
                    if leaderVm.scores.isEmpty {
                        throw MyError.noLeaderboardScores
                    }
                }
                catch {
                    // Handle error saying that leaderboard view cannot be shown
                    isGameOn = false
                }
            }
        }
    }
}

#Preview {
    LeaderboardView(isGameOn: .constant(true))
}
