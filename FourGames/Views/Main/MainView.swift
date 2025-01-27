//
//  MainView.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 16/11/2024.
//

import SwiftUI

struct MainView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var mainVm = MainViewModel()
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 55) {
                HStack{
                    Spacer()
                    userIcon
                }
                logo
                gameButtons
                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $mainVm.isGameOn) {
                switch mainVm.viewType {
                case .run:
                    RunView()
                case .words:
                    WordsView()
                case .labyrinth:
                    MazeView()
                case .tower:
                    TowerView()
                case .joinUs:
                    JoinUsView(isGameOn: $mainVm.isGameOn)
                case .userProfile:
                    UserProfileView(isGameOn: $mainVm.isGameOn)
                default:
                    MainView()
                }
            }
        }
        .tint(.primary)
    }
}

#Preview {
    MainView()
}

extension MainView{
    
    // User image
    private var userIcon: some View {
        ZStack {
            Button {
                Task {
                    do {
                        _ = try AuthManager.shared.getAuthenticatedUser()
                        mainVm.isGameOn.toggle()
                        mainVm.viewType = .userProfile
                    }
                    catch {
                        mainVm.isGameOn.toggle()
                        mainVm.viewType = .joinUs
                    }
                }
            } label: {
                AsyncImage(url: URL(string: mainVm.authUser?.photoUrl ?? "")) { Image in
                    Image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                } placeholder: {
                    Image("defaultUserIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60)
                }
            }
        }
    }
    
    // Logo
    private var logo: some View {
        ZStack{
            Image(colorScheme == .dark ? "mainLogoWhite" : "mainLogoBlack")
                .resizable()
                .scaledToFit()
                .frame(width: mainVm.adjustLogoWidth())
                .scaleEffect(mainVm.isLogoAnimating ? 1.15 : 1)
        }
        .onAppear {
            mainVm.isGameOn = false
            mainVm.viewType = .noGame
            withAnimation(.linear(duration: 0.75).repeatForever()){
                mainVm.isLogoAnimating = true
            }
        }
    }
    
    // Buttons
    private var gameButtons: some View {
        VStack{
            ForEach(mainVm.buttons, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { view in
                        gameSquare(size: mainVm.adjustButtonSize(), view: view)
                    }
                }
            }
        }
    }
    
    // Game Button
    private func gameSquare(size: CGFloat, view: MainViewModel.ViewType) -> some View {
        Button {
            mainVm.viewType = view
            mainVm.isGameOn.toggle()
        } label: {
            ZStack {
                Image(colorScheme == .dark ? "\(view)ButtonIconWhite" : "\(view)ButtonIconBlack")
                    .resizable()
                    .frame(width: size, height: size)
                RoundedRectangle(cornerRadius: 10)
                    .stroke(colorScheme == .dark ? .white : .black, lineWidth: 5)
                    .frame(width: size, height: size)
            }
            .padding(1)
        }
    }
}
