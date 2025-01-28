//
//  MainView.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 16/11/2024.
//

import SwiftUI

struct MainView: View {
    @Environment(\.openURL) var openURL
    @Environment(\.colorScheme) var colorScheme
    @StateObject var mainVm = MainViewModel()
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 55) {
                HStack{
                    leaderboardsIcon
                    Spacer()
                    userIcon
                }
                logo
                gameButtons
                Spacer()
                HStack {
                    Spacer()
                    infoIcon
                }
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
                case .leaderboard:
                    LeaderboardView()
                default:
                    MainView()
                }
            }
        }
        .tint(.primary)
        .onAppear {
            mainVm.isGameOn = false
            mainVm.viewType = .noGame
            withAnimation(.linear(duration: 0.75).repeatForever()){
                mainVm.isLogoAnimating = true
                mainVm.iconsAnimating = true
            }
        }
    }
}

#Preview {
    MainView()
}

extension MainView{
    // User profile icon
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
                        .opacity(mainVm.iconsAnimating ? 0.8 : 1)
                }
                
            }
        }
    }
    // Leaderboards icon
    private var leaderboardsIcon: some View {
        ZStack {
            Button {
                mainVm.isGameOn.toggle()
                mainVm.viewType = .leaderboard
            } label: {
                ZStack {
                    Circle()
                        .foregroundStyle(.lightGray)
                        .frame(width: 60)
                    Image("leaderboardsIconWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 55)
                }
                .opacity(mainVm.iconsAnimating ? 0.8 : 1)
            }
        }
    }
    
    // Info icon
    private var infoIcon: some View {
        ZStack {
            Button {
                openURL(URL(string: "https://github.com/smakijenko/FourGames")!)
            } label: {
                ZStack {
                    Image(systemName: "info.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                }
                .opacity(mainVm.iconsAnimating ? 0.75 : 1)
            }
        }
    }
    
    // Logo
    private var logo: some View {
        LogoView(logoName: "main", size: mainVm.adjustLogoWidth())
            .scaleEffect(mainVm.isLogoAnimating ? 1.15 : 1)
    }
    
    // Buttons
    private var gameButtons: some View {
        VStack{
            ForEach(mainVm.buttons, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { view in
                        gameSquare(size: mainVm.adjustButtonSize(), view: view)
                            .opacity(mainVm.iconsAnimating ? 0.8 : 1)
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
            GameIconView(gameType: view.id, size: size, strokeWidth: 4, radius: 10)
        }
    }
}
