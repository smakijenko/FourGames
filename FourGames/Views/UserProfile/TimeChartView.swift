//
//  TimeChartView.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 27/01/2025.
//

import SwiftUI

struct TimeChartView: View {
    @EnvironmentObject var profileVm: UserProfileViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var height: CGFloat = 0
    let gameType: String
    let playerScore: Double
    let bestScore: Double
    var body: some View {
        ZStack {
            VStack {
                bar()
                GameIconView(gameType: gameType, size: profileVm.chartIconWidth, strokeWidth: 2, radius: 7)
            }
            labels()
        }
        .frame(width: 125, height: 400)
        .onAppear {
            height = (playerScore / (2*bestScore)) * profileVm.maxChartHeight
            if height > profileVm.maxChartHeight {
                height = profileVm.maxChartHeight
            }
        }
    }
}

#Preview {
    TimeChartView(gameType: "labyrinth", playerScore: 47.1, bestScore: 47.1)
        .environmentObject(UserProfileViewModel())
}

extension TimeChartView {
    private func scoreLabel(score: String, label: String) -> some View {
        return VStack(spacing: 1) {
            Text(label)
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 2)
            Text(score)
        }
        .font(.caption)
        .foregroundStyle(colorScheme == .dark ? .white : .black)
        .minimumScaleFactor(0.1)
        .frame(width: 40)
    }
        
    private func bar() -> some View {
        return ZStack {
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.darkGray)
                    .frame(width: 29, height: profileVm.maxChartHeight)
            }
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.lightGray)
                    .opacity(0.6)
                    .frame(width: 29, height: height)
            }
        }
        .frame(width: 29)
    }
    
    private func labels() -> some View {
        return HStack {
            VStack {
                scoreLabel(score: String(bestScore), label: "Best:")
                    .offset(y: -profileVm.timeChartBestMidOffset)
            }
            Spacer()
            VStack {
                Spacer()
                scoreLabel(score: String(playerScore), label: "My:")
                    .offset(y: -height - profileVm.timeChartIconOffset)
            }
        }
        .frame(width: 125)
    }
}
