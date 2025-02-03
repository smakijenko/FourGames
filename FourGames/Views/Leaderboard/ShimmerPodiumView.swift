//
//  ShimmerPodiumView.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 03/02/2025.
//

import SwiftUI
import Shimmer

struct ShimmerPodiumView: View {
    @EnvironmentObject var leaderVm: LeaderboardViewModel
    var body: some View {
        VStack {
            usersOnPodium
            podium
        }
        .frame(width: leaderVm.adjustLogoWidth() / 1.25, height: leaderVm.podiumHeight + leaderVm.adjustLogoWidth() / 4)
    }
}

#Preview {
    ShimmerPodiumView()
        .environmentObject(LeaderboardViewModel())
}

extension ShimmerPodiumView {
    private var podium: some View {
        ZStack {
            HStack(alignment: .bottom, spacing: 0) {
                Rectangle()
                    .frame(height: leaderVm.podiumHeight / 1.3)
                    .clipShape(.rect(cornerRadii: .init(topLeading: 10, bottomLeading: 10)))
                Rectangle()
                    .frame(height: leaderVm.podiumHeight)
                    .clipShape(.rect(cornerRadii: .init(topLeading: 10, topTrailing: 10)))
                Rectangle()
                    .frame(height: leaderVm.podiumHeight / 1.5)
                    .clipShape(.rect(cornerRadii: .init(bottomTrailing: 10, topTrailing: 10)))
            }
        }
        .foregroundStyle(.lightGray)
        .shimmering(bandSize: 1)
    }
    
    private var usersOnPodium: some View {
        HStack {
            Circle()
                .frame(width: leaderVm.adjustLogoWidth() / 5.5)
                .shimmering(bandSize: 1)
                .offset(y: leaderVm.podiumHeight / 4)
            Spacer()
            Circle()
                .frame(width: leaderVm.adjustLogoWidth() / 5.5)
                .shimmering(bandSize: 1)
            Spacer()
            Circle()
                .frame(width: leaderVm.adjustLogoWidth() / 5.5)
                .shimmering(bandSize: 1)
                .offset(y: leaderVm.podiumHeight / 3)
        }
        .foregroundStyle(.lightGray)
        .padding(.horizontal)
    }
}
