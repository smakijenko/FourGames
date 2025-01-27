//
//  NumberChartView.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 24/01/2025.
//

import SwiftUI

struct NumberChartView: View {
    @EnvironmentObject var profileVm: UserProfileViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var height: CGFloat = 0
    let maxHeight: CGFloat = 320
    let iconOffset: CGFloat = 36
    let gameType: String
    let playerScore: Int
    let bestScore: Int
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
            height = CGFloat(playerScore) / CGFloat(bestScore) * maxHeight
        }
    }
}

#Preview {
    NumberChartView(gameType: "run", playerScore: 20, bestScore: 113)
        .environmentObject(UserProfileViewModel())
}

extension NumberChartView {
    private func gameIcon(gameName: String) -> some View {
        return ZStack {
            Image(colorScheme == .dark ? "\(gameName)ButtonIconWhite" : "\(gameName)ButtonIconBlack")
                .resizable()
            RoundedRectangle(cornerRadius: 10)
                .stroke(colorScheme == .dark ? .white : .black, lineWidth: 2)
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
                    .frame(width: 29, height: height)
            }
        }
        .frame(width: 29)
    }
    
    private func labels() -> some View {
        return HStack {
            VStack {
                scoreLabel(score: String(bestScore), label: "Best:")
                Spacer()
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
