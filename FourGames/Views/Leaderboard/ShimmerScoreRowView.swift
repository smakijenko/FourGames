//
//  ShimmerScoreRowView.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 03/02/2025.
//

import SwiftUI
import Shimmer

struct ShimmerScoreRowView: View {
    @EnvironmentObject var leaderVm: LeaderboardViewModel
    var body: some View {
        VStack {
            ForEach(0 ..< 5) { _ in
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: leaderVm.scoreRowWidth * 0.9, height: leaderVm.scoreRowHeight * 1.25)
                    .shimmering(bandSize: 1)
                    .padding(.vertical, 10)
            }
        }
        .foregroundStyle(.lightGray)
    }
}

#Preview {
    ShimmerScoreRowView()
        .environmentObject(LeaderboardViewModel())
}
