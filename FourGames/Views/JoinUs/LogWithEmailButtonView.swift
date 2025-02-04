//
//  LogWithEmailButtonView.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 14/01/2025.
//

import SwiftUI
import PhotosUI

struct LogWithEmailButtonView: View {
    @EnvironmentObject var joinVm: JoinUsViewModel
    @Environment(\.colorScheme) var colorScheme
    @Binding var isGameOn: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .stroke(colorScheme == .dark ? .white : .black, lineWidth: 2)
                .frame(width: joinVm.adjustEmailWinWidth(), height: joinVm.isEmailButtonClicked ? 410 : 50)
                .foregroundStyle(colorScheme == .dark ? .black : .white)
                .overlay {
                    VStack {
                        emailButton
                        if joinVm.isEmailButtonClicked {
                            emailSignUpIn
                                .transition(.asymmetric(
                                    insertion: .opacity.animation(.easeInOut.delay(0.15)),
                                    removal: .opacity.animation(.easeInOut)))
                        }
                        Spacer()
                    }
                }
        }    }
}

#Preview {
    LogWithEmailButtonView(isGameOn: .constant(true))
        .environmentObject(JoinUsViewModel())
}

extension LogWithEmailButtonView {
    private var emailButton: some View {
        Button {
            if joinVm.isEmailButtonClicked {joinVm.emailButtonOff()}
            else {joinVm.emailButtonOn()}
        } label: {
            HStack {
                Image(systemName: "envelope")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35)
                    .fontWeight(.bold)
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                Text("Continue with Email")
                    .lineLimit(1)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
            }
            .minimumScaleFactor(0.1)
            .padding(.top, 10)
            .padding(.horizontal, 10)
        }
    }
    
    private var emailSignUpIn: some View {
        VStack {
            HStack {
                Button {
                    joinVm.emailScreen = .signIn
                } label: {
                    Text("Sign In")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                        .opacity(joinVm.emailScreen == .signIn ? 1 : 0.3)
                }
                Spacer()
                Button {
                    joinVm.emailScreen = .signUp
                } label: {
                    Text("Sign Up")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                        .opacity(joinVm.emailScreen == .signUp ? 1 : 0.3)
                }
            }
            if joinVm.emailScreen == .signIn {
                emailSignIn
            }
            else if joinVm.emailScreen == .signUp {
                emailSignUp
            }
        }
        .padding(.horizontal)
    }
    
    private func submitButton(
        task: @escaping () -> Task<Void, Error>
    ) -> some View {
        return ZStack {
            RoundedRectangle(cornerRadius: 24)
                .stroke(colorScheme == .dark ? .white : .black, lineWidth: 2)
                .frame(width: joinVm.adjustEmailWinWidth() * 0.6, height: 50)
                .foregroundStyle(colorScheme == .dark ? .black : .white)
                .overlay {
                    Button {
                        let taskInstance = task()
                    } label: {
                        Text("Submit")
                            .lineLimit(1)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                            .minimumScaleFactor(0.1)
                            .padding(.horizontal, 10)
                    }
                }
        }
    }
    
    // Email sign in
    private var emailSignIn: some View {
        ZStack {
            VStack {
                signInForm
                submitButton(task: signInTask)
                Spacer()
            }
            .padding(.horizontal)
        }
        .frame(width: joinVm.adjustEmailWinWidth())
    }
    
    private var signInForm: some View {
        VStack {
            TextField("Email...", text: $joinVm.email)
                .padding(10)
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            SecureField("Password...", text: $joinVm.password)
                .padding(10)
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
        }
    }
    
    private func signInTask() -> Task<Void, Error> {
        Task {
            do {
                try await AuthManager.shared.signInEmailUser(email: joinVm.email, password: joinVm.password)
            }
            catch {
                joinVm.alertText = error.localizedDescription
                joinVm.isAlertOn.toggle()
            }
            isGameOn = false
        }
    }
    
    // Email sign up
    private var emailSignUp: some View {
        ZStack {
            VStack {
                signUpForm
                submitButton(task: signUpTask)
                Spacer()
            }
            .padding(.horizontal)
        }
        .frame(width: joinVm.adjustEmailWinWidth())
    }
    
    
    private var signUpForm: some View {
        VStack {
            PhotosPicker(selection: $joinVm.imageSelection) {
                Image(uiImage: joinVm.selectedImage ?? UIImage(named: "defaultUserIcon")!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .clipShape(.circle)
            }
            TextField("Name...", text: $joinVm.name)
                .padding(10)
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
                .onChange(of: joinVm.name) { _, newValue in
                    if newValue.count > joinVm.nameCharacterLimit {
                        joinVm.name = String(newValue.prefix(joinVm.nameCharacterLimit))
                    }
                }
            TextField("Email...", text: $joinVm.email)
                .padding(10)
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            SecureField("Password...", text: $joinVm.password)
                .padding(10)
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
        }
    }
    
    private func signUpTask() -> Task<Void, Error> {
        Task {
            do {
                try await AuthManager.shared.signUpEmailUser (
                    selectedImage: joinVm.selectedImage,
                    name: joinVm.name,
                    email: joinVm.email,
                    password: joinVm.password
                )
            }
            catch {
                joinVm.alertText = error.localizedDescription
                joinVm.isAlertOn.toggle()
            }
            isGameOn = false
        }
    }
}
