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
    private func tab() -> some View {
        return ZStack {
            Rectangle()
                .foregroundStyle(colorScheme == .dark ? .white : .black)
                .frame(width: leaderVm.adjustLogoWidth() / 4.5, height: 40)
        }
    }
    
    private var tabMenu: some View {
        HStack(spacing: 1) {
            tab()
                .clipShape(.rect(cornerRadii: .init(topLeading: 10, bottomLeading: 10)))
            tab()
            tab()
            tab()
                .clipShape(.rect(cornerRadii: .init(bottomTrailing: 10, topTrailing: 10)))
        }
    }
}
