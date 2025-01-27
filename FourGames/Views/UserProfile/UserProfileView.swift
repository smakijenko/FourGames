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
            logo
            HStack(alignment: .top, spacing: 20) {
                userIcon
                VStack(spacing: 12) {
                    if profileVm.authProvider == .email {
                        submitButton(task: profileVm.resetTask, buttonText: "Reset password", buttonIcon: "key")
                    }
                    submitButton(task: profileVm.signOutTask, buttonText: "Sign out", buttonIcon: "person.slash")
                    submitButton(task: profileVm.deleteTask, buttonText: "Delete account", buttonIcon: "trash")
                }
            }
            if profileVm.chartsOn {
                charts()
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
                }
                catch {
                    if let myError = error as? MyError, myError == .noProvider || myError == .noAuthUser || myError == .unableFetchUserData {
                        // TODO - HANDLE ALERT SAYING THAT IT WAS NOT POSSIBLE TO LOAD USER PROFILE
                        isGameOn = false
                    }
                    else if let myError = error as? MyError, myError == .unableFetchBestScore || myError == .unableFetchUserScore {
                        // TODO - HANDLE ALERT SAYING THAT IT WAS NOT POSSIBLE TO LOAD USER SCORES
                    }
                }
            }
        }
    }
}

#Preview {
    UserProfileView(isGameOn: .constant(true))
}

extension UserProfileView {
    private var logo: some View {
        VStack {
            Image(colorScheme == .dark ? "profileLogoWhite" : "profileLogoBlack")
                .resizable()
                .scaledToFit()
                .frame(width: profileVm.adjustLogoWidth())
        }
    }
    
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
            Text(profileVm.authUser?.name ?? "Jan Kowalski")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(colorScheme == .dark ? .white : .black)
                .minimumScaleFactor(0.1)
        }
    }
    
    private func submitButton(
        task: @escaping () throws -> Task<Void, Error>
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
                            do {
                                _ = try task()
                            }
                            catch {
                                // TODO - Handle alert saying that action was not possible
                            }
                            isGameOn = false
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
}
