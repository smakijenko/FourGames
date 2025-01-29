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
        ZStack {
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
                .foregroundStyle(colorScheme == .dark ? .black : .white)
                .frame(width: 40)
                .shadow(color: colorScheme == .dark ? .white : .black, radius: 2.5)
        }
    }
}
