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
            LogoView(logoName: "joinUs", size: joinVm.adjustLogoWidth())
                .padding(.bottom, 40)
            LogWithGoogleButtonView(isGameOn: $isGameOn)
            LogWithEmailButtonView(isGameOn: $isGameOn)
            Spacer()
        }
        .environmentObject(joinVm)
        .alert(isPresented: $joinVm.isAlertOn) {
            Alert(
                title: Text(joinVm.alertText),
                message: Text("Try again once again."),
                dismissButton: .default(Text("Ok")))
        }
    }
}

#Preview {
    JoinUsView(isGameOn: .constant(true))
}
