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
            PodiumView (
                user1: !leaderVm.scores.isEmpty ? (leaderVm.scores[0].photoUrl, leaderVm.scores[0].name, Double(leaderVm.scores[0].runScore)) : nil,
                user2: leaderVm.scores.count > 1 ? (leaderVm.scores[1].photoUrl, leaderVm.scores[1].name, Double(leaderVm.scores[1].runScore)) : nil,
                user3: leaderVm.scores.count > 2 ? (leaderVm.scores[2].photoUrl, leaderVm.scores[2].name, Double(leaderVm.scores[2].runScore)) : nil
            )
            if leaderVm.scores.count > 3 {
                ForEach(3 ..< leaderVm.scores.count, id: \.self) { index in
                    ScoreRowView(photoUrl: leaderVm.scores[index].photoUrl, name: leaderVm.scores[index].name, score: Double(leaderVm.scores[index].runScore), rank: index + 1)
                }
            }
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
