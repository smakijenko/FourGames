//
//  JoinUsView.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 11/01/2025.
//

import SwiftUI

struct JoinUsView: View {
    @StateObject private var joinVm = JoinUsViewModel()
    @Environment(\.colorScheme) var colorScheme
    @Binding var isGameOn: Bool
    var body: some View {
        VStack(spacing: 20) {
            logo
                .padding(.bottom, 40)
            LogWithGoogleButtonView(isGameOn: $isGameOn)
            LogWithEmailButtonView(isGameOn: $isGameOn)
            Spacer()
        }
        .environmentObject(joinVm)
    }
}

#Preview {
    JoinUsView(isGameOn: .constant(true))
}

extension JoinUsView {
    private var logo: some View{
        Image(colorScheme == .dark ? "joinUsLogoWhite" : "joinUsLogoBlack")
            .resizable()
            .scaledToFit()
            .frame(width: joinVm.adjustLogoWidth())
    }
}
