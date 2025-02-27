//
//  ScoreRowView.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 30/01/2025.
//

import SwiftUI

struct ScoreRowView: View {
    @EnvironmentObject var leaderVm: LeaderboardViewModel
    @Environment(\.colorScheme) var colorScheme
    let photoUrl: String
    let name: String
    let score: Double
    let rank: Int
    var body: some View {
        ZStack {
            bar
            HStack {
                userIcon
                labels
                Spacer()
                ScoreIconView(score: leaderVm.formatNumberForRow(num: score), size: 65, iconColor: colorScheme == .dark ? .black : .white)
                    .offset(y: -leaderVm.scoreRowHeight / 4.1)
            }
            .frame(width: leaderVm.scoreRowWidth + 30)
        }
    }
}

#Preview {
    ScoreRowView(photoUrl: Users().users.first!.photoUrl, name: Users().users.first!.name, score: 35.7, rank: 4)
        .environmentObject(LeaderboardViewModel())
}

extension ScoreRowView {
    private var bar: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(colorScheme == .dark ? .black : .white)
            .frame(width: leaderVm.scoreRowWidth, height: leaderVm.scoreRowHeight)
            .shadow(color: colorScheme == .dark ? .white : .black, radius: 2.5)
    }
    private var userIcon: some View {
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
        .frame(width: 60, height: 60)
        .shadow(color: colorScheme == .dark ? .white : .black, radius: 2.5)
        .offset(y: -leaderVm.scoreRowHeight / 2)
    }
    
    private var labels: some View {
        HStack {
            Text("\(rank). " + name)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(colorScheme == .dark ? .white : .black)
                .lineLimit(1)
                .minimumScaleFactor(0.1)
        }
    }
}
