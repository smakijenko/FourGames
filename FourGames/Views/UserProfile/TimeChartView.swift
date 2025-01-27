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
    let maxHeight: CGFloat = 320
    let iconOffset: CGFloat = 40
    let bestMidOffset: CGFloat = 17
    let gameType: String
    let playerScore: Double
    let bestScore: Double
    var body: some View {
        ZStack {
            VStack {
                bar()
                gameIcon(gameName: gameType)
            }
            labels()
        }
        .frame(width: 125, height: 400)
        .onAppear {
            height = (playerScore / (2*bestScore)) * maxHeight
            if height > maxHeight {
                height = maxHeight
            }
        }
    }
}

#Preview {
    TimeChartView(gameType: "labyrinth", playerScore: 200, bestScore: 47.1)
        .environmentObject(UserProfileViewModel())
}

extension TimeChartView {
    private func gameIcon(gameName: String) -> some View {
        return ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(colorScheme == .dark ? .white : .black, lineWidth: 2)
            Image(colorScheme == .dark ? "\(gameName)ButtonIconWhite" : "\(gameName)ButtonIconBlack")
                .resizable()
        }
        .frame(width: profileVm.chartWidth, height: profileVm.chartWidth)
    }
    
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
                    .frame(width: 29, height: maxHeight)
            }
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.lightGray)
                    .opacity(0.6)
                    .frame(width: 29, height: 160)
            }
        }
        .frame(width: 29)
    }
    
    private func labels() -> some View {
        return HStack {
            VStack {
                scoreLabel(score: String(bestScore), label: "Best:")
                    .offset(y: -bestMidOffset)
            }
            Spacer()
            VStack {
                Spacer()
                scoreLabel(score: String(playerScore), label: "My:")
                    .offset(y: -height - iconOffset)
            }
        }
        .frame(width: 125)
    }
}
