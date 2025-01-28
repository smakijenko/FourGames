//
//  TabMenuView.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 28/01/2025.
//

import SwiftUI

struct TabMenuView: View {
    @EnvironmentObject var leaderVm: LeaderboardViewModel
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            tabMenu
        }
    }
}

#Preview {
    TabMenuView()
        .environmentObject(LeaderboardViewModel())
}

extension TabMenuView {
    private func tab(gameType: String) -> some View {
        return ZStack {
            Button {
                
            } label: {
                Rectangle()
                    .foregroundStyle(colorScheme == .dark ? .black : .white)
                    .frame(width: leaderVm.adjustLogoWidth() / 4.5, height: leaderVm.tabMenuHeight)
                    .overlay {
                        GameIconView(gameType: gameType, size: leaderVm.gameIconSize, strokeWidth: 1, radius: 5)
                    }
            }
        }
    }
    
    private var tabMenu: some View {
        HStack(spacing: 1) {
            tab(gameType: "run")
                .clipShape(.rect(cornerRadii: .init(topLeading: 10, bottomLeading: 10)))
            tab(gameType: "words")
                .clipShape(.rect(cornerRadius: 0))
            tab(gameType: "labyrinth")
                .clipShape(.rect(cornerRadius: 0))
            tab(gameType: "tower")
                .clipShape(.rect(cornerRadii: .init(bottomTrailing: 10, topTrailing: 10)))
        }
        .shadow(color: colorScheme == .dark ? .white : .black, radius: 2.5)
    }
}
