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
    var body: some View {
        VStack {
            usersOnPodium(users: Users().users)
            podium
        }
    }
}

#Preview {
    PodiumView()
        .environmentObject(LeaderboardViewModel())
}

extension PodiumView {
    private var podium: some View {
        ZStack {
            HStack(alignment: .bottom, spacing: 0) {
                Rectangle()
                    .frame(height: leaderVm.podiumHeight / 2)
                    .clipShape(.rect(cornerRadii: .init(topLeading: 10, bottomLeading: 10)))
                Rectangle()
                    .frame(height: leaderVm.podiumHeight)
                    .clipShape(.rect(cornerRadii: .init(topLeading: 10, topTrailing: 10)))
                Rectangle()
                    .frame(height: leaderVm.podiumHeight / 3)
                    .clipShape(.rect(cornerRadii: .init(bottomTrailing: 10, topTrailing: 10)))
            }
            .foregroundStyle(colorScheme == .dark ? .black : .white)
            .frame(width: leaderVm.adjustLogoWidth() / 1.25)
            .shadow(color: colorScheme == .dark ? .white : .black, radius: 2.5)
            Image(systemName: "trophy")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.yellow)
                .frame(width: 40)
                .shadow(color: colorScheme == .dark ? .white : .black, radius: 2.5)
        }
    }
    
    private func userIcon(user: AuthUserDataModel) -> some View {
        return VStack(spacing: 5) {
            ZStack {
                AsyncImage(url: URL(string: user.photoUrl)) { Image in
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
            Text(user.name)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(colorScheme == .dark ? .white : .black)
                .minimumScaleFactor(0.1)
                .frame(width: leaderVm.adjustLogoWidth() / 4)
        }
    }
    
    private func usersOnPodium(users: [AuthUserDataModel]) -> some View {
        return HStack {
            userIcon(user: users[1])
                .offset(y: leaderVm.podiumHeight / 2)
            userIcon(user: users[0])
            userIcon(user: users[2])
                .offset(y: leaderVm.podiumHeight / 1.5)
        }
    }
    
    private func usersOnPodiumV2(user1: (String, String), user2: (String, String)?, user3: (String, String)?) -> some View {
        return HStack {
//            if let user2 = user2 {
//                userIcon(name: user2.0, photoUrl: user2.1)
//                    .offset(y: leaderVm.podiumHeight / 2)
//            } else {
//                Spacer()
//            }
//            userIcon(name: user1.0, photoUrl: user1.1)
//            if let user3 = user3 {
//                userIcon(name: user3.0, photoUrl: user3.1)
//                    .offset(y: leaderVm.podiumHeight / 2)
//            } else {
//                Spacer()
//            }
        }
    }
}
