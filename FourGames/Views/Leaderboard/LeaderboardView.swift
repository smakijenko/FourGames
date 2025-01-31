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
            PodiumView(user1: (Users().users[0].photoUrl, Users().users[0].name, "35"), user2: nil, user3: nil)
            ScoreRowView(photoUrl: Users().users[3].photoUrl, name: Users().users[3].name, score: 35.7, rank: 4)
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
