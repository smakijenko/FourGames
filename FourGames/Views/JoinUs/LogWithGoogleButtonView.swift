//
//  LogWithGoogleButtonView.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 14/01/2025.
//

import SwiftUI

struct LogWithGoogleButtonView: View {
    @EnvironmentObject var joinVm: JoinUsViewModel
    @Environment(\.colorScheme) var colorScheme
    @Binding var isGameOn: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .stroke(colorScheme == .dark ? .white : .black, lineWidth: 2)
                .frame(width: joinVm.adjustEmailWinWidth(), height: 50)
                .foregroundStyle(colorScheme == .dark ? .black : .white)
                .overlay(alignment: .center, content: {
                    googleButton
                })
        }
    }
}

#Preview {
    LogWithGoogleButtonView(isGameOn: .constant(true))
        .environmentObject(JoinUsViewModel())
}

extension LogWithGoogleButtonView {
    private var googleButton: some View {
        Button {
            Task{
                do {
                    try await AuthManager.shared.signInWithGoogle()
                    isGameOn = false
                }
                catch {
                    joinVm.alertText = error.localizedDescription
                    joinVm.isAlertOn.toggle()
                }
            }
        } label: {
            HStack {
                Image(colorScheme == .dark ? "googleIconWhite" : "googleIconBlack")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25)
                    .foregroundStyle(.black)
                Text("Sign in with Google")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
            }
            .minimumScaleFactor(0.1)
            .padding(.horizontal, 10)
        }
    }
}
