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
        VStack(spacing: 5) {
            tabIdicator
            tabMenu
        }
    }
}

#Preview {
    TabMenuView()
        .environmentObject(LeaderboardViewModel())
}

extension TabMenuView {
    private func tab(gameType: LeaderboardViewModel.GameType) -> some View {
        return ZStack {
            Button {
                leaderVm.selectedGameType = gameType
                leaderVm.setTabIndicatorPos()
            } label: {
                Rectangle()
                    .foregroundStyle(colorScheme == .dark ? .black : .white)
                    .frame(width: leaderVm.adjustLogoWidth() / 4.5, height: leaderVm.tabMenuHeight)
                    .overlay {
                        GameIconView(gameType: gameType.rawValue, size: leaderVm.gameIconSize, strokeWidth: 1, radius: 5)
                    }
            }
        }
    }
    
    private var tabMenu: some View {
        HStack(spacing: 1) {
            tab(gameType: .run)
                .clipShape(.rect(cornerRadii: .init(topLeading: 10, bottomLeading: 10)))
            tab(gameType: .words)
                .clipShape(.rect(cornerRadius: 0))
            tab(gameType: .labyrinth)
                .clipShape(.rect(cornerRadius: 0))
            tab(gameType: .tower)
                .clipShape(.rect(cornerRadii: .init(bottomTrailing: 10, topTrailing: 10)))
        }
        .shadow(color: colorScheme == .dark ? .white : .black, radius: 2.5)
    }
    
    private var tabIdicator: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(colorScheme == .dark ? .white : .black)
                .frame(width: leaderVm.adjustLogoWidth() / 5, height: 3)
                .offset(x: leaderVm.adjustLogoWidth() / leaderVm.tabIndicatorOffset)
        }
    }
}
