//
//  LogoView.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 27/01/2025.
//

import SwiftUI

struct LogoView: View {
    @Environment(\.colorScheme) var colorScheme
    let logoName: String
    let size: CGFloat
    var body: some View {
        Image(colorScheme == .dark ? logoName + "LogoWhite" : logoName + "LogoBlack")
            .resizable()
            .scaledToFit()
            .frame(width: size)
    }
}

#Preview {
    LogoView(logoName: "kangRun", size: 300)
}
