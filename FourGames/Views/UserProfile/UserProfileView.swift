//
//  UserProfileView.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 17/01/2025.
//

import SwiftUI
import Charts

struct UserProfileView: View {
    @StateObject private var profileVm = UserProfileViewModel()
    @Environment(\.colorScheme) var colorScheme
    @Binding var isGameOn: Bool
    var body: some View {
        VStack(spacing: 20) {
            LogoView(logoName: "profile", size: profileVm.adjustLogoWidth())
            HStack(alignment: .top, spacing: 20) {
                userIcon
                VStack(spacing: 12) {
                    if profileVm.authProvider == .email {
                        submitButton(function: profileVm.resetTask, buttonText: "Reset password", buttonIcon: "key")
                    }
                    submitButton(function: profileVm.signOutTask, buttonText: "Sign out", buttonIcon: "person.slash")
                    submitButton(function: AuthManager.shared.delete, buttonText: "Delete account", buttonIcon: "trash")
                }
            }
            if profileVm.chartsOn {
                charts()
            }
            else {
                shimmerCharts
            }
            Spacer()
        }
        .padding(.horizontal)
        .environmentObject(profileVm)
        .onAppear {
            Task {
                do {
                    try profileVm.setProvider()
                    try await profileVm.loadAuthUser()
                    try await profileVm.loadScores()
                } catch let myError as MyError {
                    switch myError {
                    case .noProvider, .noAuthUser, .unableFetchUserData:
                        // TODO - HANDLE ALERT SAYING THAT IT WAS NOT POSSIBLE TO LOAD USER PROFILE
                        isGameOn = false
                    case .unableFetchBestScore, .unableFetchUserScore:
                        // TODO - HANDLE ALERT SAYING THAT IT WAS NOT POSSIBLE TO LOAD USER SCORES
                        break
                    default:
                        print("Unexpected error while loading UserProfileView.")
                        // TODO - HANDLE ALERT SAYING THAT IT WAS NOT POSSIBLE TO LOAD USER PROFILE
                        isGameOn = false
                    }
                } catch {
                    print("Unexpected error while loading UserProfileView: \(error.localizedDescription)")
                }
            }
        }
        
    }
}

#Preview {
    UserProfileView(isGameOn: .constant(true))
}

extension UserProfileView {
    private var userIcon: some View {
        VStack {
            AsyncImage(url: URL(string: profileVm.authUser?.photoUrl ?? "")) { Image in
                Image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
            } placeholder: {
                Image("defaultUserIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120)
            }
            Text(profileVm.authUser?.name ?? "")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(colorScheme == .dark ? .white : .black)
                .minimumScaleFactor(0.1)
        }
    }
    
    private func submitButton(
        function: @escaping () async throws -> Void
        , buttonText: String, buttonIcon: String) -> some View {
            return ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .stroke(colorScheme == .dark ? .white : .black, lineWidth: 2)
                    .frame(minWidth: 210)
                    .frame(maxWidth: 375)
                    .frame(height: 40)
                    .foregroundStyle(colorScheme == .dark ? .black : .white)
                    .overlay {
                        Button {
                            Task {
                                do {
                                    try await function()
                                    isGameOn = false
                                }
                                catch {
                                    // Handle alert saying that it was not possible to do an action
                                }
                            }
                        } label: {
                            HStack(spacing: 5) {
                                Image(systemName: buttonIcon)
                                Text(buttonText)
                            }
                            .lineLimit(1)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                            .minimumScaleFactor(0.1)
                            .padding(.horizontal, 5)
                        }
                    }
            }
        }
    
    private func charts() -> some View {
        guard
            let playerStats = profileVm.authUserScores,
            let bestStats = profileVm.bestScores
        else {
            return AnyView(EmptyView())
        }
        return AnyView (
            HStack(alignment: .bottom, spacing: 10) {
                NumberChartView(gameType: "run", playerScore: playerStats.runScore, bestScore: bestStats.runScore)
                TimeChartView(gameType: "words", playerScore: playerStats.wordsScore, bestScore: bestStats.wordsScore)
                TimeChartView(gameType: "labyrinth", playerScore: playerStats.mazeScore, bestScore: bestStats.mazeScore)
                NumberChartView(gameType: "tower", playerScore: playerStats.towerScore, bestScore: bestStats.towerScore)
            }
            .frame(height: 400 * profileVm.adjustChartSize())
            .scaleEffect(profileVm.adjustChartSize())
        )
    }
    
    private var shimmerCharts: some View {
        HStack(alignment: .bottom, spacing: 10) {
            ForEach(0 ..< 4) { _ in
                ShimmerChartView()
            }
        }
        .frame(height: 400 * profileVm.adjustChartSize())
        .scaleEffect(profileVm.adjustChartSize())
    }
}
