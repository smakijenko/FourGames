//
//  ScoreIconView.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 31/01/2025.
//

import SwiftUI

struct ScoreIconView: View {
    @Environment(\.colorScheme) var colorScheme
    let score: String
    let size: CGFloat
    let iconColor: Color
    var body: some View {
        ZStack {
            Image("rowScoreIcon")
                .resizable()
                .scaledToFit()
                .frame(width: size)
                .foregroundStyle(iconColor)
                .shadow(color: colorScheme == .dark ? .white : .black, radius: 2.5)
            Circle()
                .foregroundStyle(.clear)
                .frame(width: size * 0.77)
                .overlay {
                    Text(score)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                }
                .offset(y: -size * 0.16)
        }
    }
}

#Preview {
    ScoreIconView(score: "35", size: 65, iconColor: .red)
}
