//
//  PodiumView.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 29/01/2025.
//

import SwiftUI

struct PodiumView: View {
    @EnvironmentObject var leaderVm: LeaderboardViewModel
    @Environment(\.colorScheme) var colorScheme
            // photoUrl, name, score
    let user1: (String, String, String)
    let user2: (String, String, String)?
    let user3: (String, String, String)?
    var body: some View {
        VStack {
            usersOnPodium()
            podium
        }
        .frame(width: leaderVm.adjustLogoWidth() / 1.25, height: leaderVm.podiumHeight + leaderVm.adjustLogoWidth() / 4)
    }
}

#Preview {
    PodiumView (
        user1: (Users().users[0].photoUrl, Users().users[0].name, "35"),
        user2: (Users().users[1].photoUrl, Users().users[1].name, "33"),
        user3: (Users().users[3].photoUrl, Users().users[3].name, "30")
    )
        .environmentObject(LeaderboardViewModel())
}

extension PodiumView {
    private var podium: some View {
        ZStack {
            HStack(alignment: .bottom, spacing: 0) {
                Rectangle()
                    .frame(height: leaderVm.podiumHeight / 1.3)
                    .clipShape(.rect(cornerRadii: .init(topLeading: 10, bottomLeading: 10)))
                    .shadow(color: colorScheme == .dark ? .white : .black, radius: 2.5)
                    .overlay {
                        if let user2 = user2 {
                            ScoreIconView(score: user2.2, size: leaderVm.podiumHeight / 1.95, iconColor: .lightGray)
                        }
                    }
                Rectangle()
                    .frame(height: leaderVm.podiumHeight)
                    .clipShape(.rect(cornerRadii: .init(topLeading: 10, topTrailing: 10)))
                    .shadow(color: colorScheme == .dark ? .white : .black, radius: 2.5)
                    .overlay {
                        ScoreIconView(score: user1.2, size: leaderVm.podiumHeight / 1.5, iconColor: .yellow)
                    }
                Rectangle()
                    .frame(height: leaderVm.podiumHeight / 1.5)
                    .clipShape(.rect(cornerRadii: .init(bottomTrailing: 10, topTrailing: 10)))
                    .shadow(color: colorScheme == .dark ? .white : .black, radius: 2.5)
                    .overlay {
                        if let user3 = user3 {
                            ScoreIconView(score: user3.2, size: leaderVm.podiumHeight / 2.25, iconColor: .brown)
                        }
                    }

            }
            .foregroundStyle(colorScheme == .dark ? .black : .white)
        }
    }
    
    private func userIcon(photoUrl: String, name: String) -> some View {
        return VStack(spacing: 5) {
            ZStack {
                AsyncImage(url: URL(string: photoUrl)) { Image in
                    Image
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                } placeholder: {
                    Image("defaultUserIcon")
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(width: leaderVm.adjustLogoWidth() / 5.5, height: leaderVm.adjustLogoWidth() / 5.5)
            .shadow(color: colorScheme == .dark ? .white : .black, radius: 3)
            Text(name)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(colorScheme == .dark ? .white : .black)
                .minimumScaleFactor(0.1)
                .frame(width: leaderVm.adjustLogoWidth() / 4)
        }
    }

    private func usersOnPodium() -> some View {
        return HStack {
            if let user2 = user2 {
                userIcon(photoUrl: user2.0, name: user2.1)
                    .offset(y: leaderVm.podiumHeight / 4)
            } else {
                Spacer()
            }
            userIcon(photoUrl: user1.0, name: user1.1)
            if let user3 = user3 {
                userIcon(photoUrl: user3.0, name: user3.1)
                    .offset(y: leaderVm.podiumHeight / 3)
            } else {
                Spacer()
            }
        }
    }
}
