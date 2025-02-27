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
            if !leaderVm.scores.isEmpty {
                PodiumView (
                    user1: !leaderVm.scores.isEmpty ? (leaderVm.scores[0].photoUrl, leaderVm.scores[0].name, leaderVm.selectedScore(leaderVm.scores[0])) : nil,
                    user2: leaderVm.scores.count > 1 ? (leaderVm.scores[1].photoUrl, leaderVm.scores[1].name, leaderVm.selectedScore(leaderVm.scores[1])) : nil,
                    user3: leaderVm.scores.count > 2 ? (leaderVm.scores[2].photoUrl, leaderVm.scores[2].name, leaderVm.selectedScore(leaderVm.scores[2])) : nil
                )
                if leaderVm.scores.count > 3 {
                    ScrollView {
                        ForEach(3 ..< leaderVm.scores.count, id: \.self) { index in
                            ScoreRowView(photoUrl: leaderVm.scores[index].photoUrl, name: leaderVm.scores[index].name, score: Double(leaderVm.selectedScore(leaderVm.scores[index])), rank: index + 1)
                                .scaleEffect(0.9)
                                .padding(.vertical, 5)
                        }
                    }
                    .padding(.top)
                }
                Spacer()
            }
            else {
                ShimmerPodiumView()
                ShimmerScoreRowView()
                Spacer()
            }
            TabMenuView()
        }
        .environmentObject(leaderVm)
        .onAppear {
            Task {
                do {
                    try? await Task.sleep(for: .seconds(10))
                    if leaderVm.scores.isEmpty {
                        throw MyError.noLeaderboardScores
                    }
                }
                catch {
                    leaderVm.alertText = error.localizedDescription
                    leaderVm.isAlertOn.toggle()
                    isGameOn = false
                }
            }
            Task {
                do {
                    try await leaderVm.loadAllScores()
                    if leaderVm.scores.isEmpty {
                        throw MyError.noLeaderboardScores
                    }
                }
                catch {
                    leaderVm.alertText = error.localizedDescription
                    leaderVm.isAlertOn.toggle()
                    isGameOn = false
                }
            }
        }
        .alert(isPresented: $leaderVm.isAlertOn) {
            Alert(
                title: Text(leaderVm.alertText),
                message: Text("Try again once again."),
                dismissButton: .default(Text("Ok")))
        }
    }
}

#Preview {
    LeaderboardView(isGameOn: .constant(true))
}
