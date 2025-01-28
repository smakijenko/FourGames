//
//  GameIconView.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 28/01/2025.
//

import SwiftUI

struct GameIconView: View {
    @Environment(\.colorScheme) var colorScheme
    let gameType: String
    let size: CGFloat
    let strokeWidth: CGFloat
    let radius: CGFloat
    var body: some View {
        ZStack {
            Image(colorScheme == .dark ? "\(gameType)ButtonIconWhite" : "\(gameType)ButtonIconBlack")
                .resizable()
                .frame(width: size, height: size)
            RoundedRectangle(cornerRadius: radius)
                .stroke(colorScheme == .dark ? .white : .black, lineWidth: strokeWidth)
                .frame(width: size, height: size)
        }
        .padding(1)
    }
}

#Preview {
    GameIconView(gameType: "words", size: 300, strokeWidth: 4, radius: 10)
}
