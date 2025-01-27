//
//  JoinUsViewModel.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 11/01/2025.
//

import Foundation
import SwiftUI
import PhotosUI
import FirebaseStorage
import FirebaseFirestore

class JoinUsViewModel: ObservableObject {
    enum emailScreenType {
        case signIn
        case signUp
    }
    
    @Published var isEmailButtonClicked = false {
        didSet {
            resetEmailView()
        }
    }
    @Published var emailScreen: emailScreenType = .signIn
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var selectedImage: UIImage? = nil
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            convertIntoImage(selection: imageSelection)
        }
    }
    
    func adjustLogoWidth() -> CGFloat{
        let width = screenSize.width * 0.89
        if width > 550 {return 550}
        return width
    }
    
    func adjustEmailWinWidth() -> CGFloat {
        return adjustLogoWidth() * 0.8
    }
    
    func emailButtonOn() {
        withAnimation(.easeInOut) {
            isEmailButtonClicked = true
        }
    }
    
    func emailButtonOff() {
        withAnimation(.easeInOut.delay(0.15)) {
            isEmailButtonClicked = false
        }
    }
    
    private func convertIntoImage(selection: PhotosPickerItem?) {
        guard let selection else { return }
        Task {
            if let data = try? await selection.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    DispatchQueue.main.sync {
                        self.selectedImage = uiImage
                    }
                    return
                }
            }
        }
    }
    
    private func resetEmailView() {
        DispatchQueue.main.async {
            self.selectedImage = nil
            self.emailScreen = .signIn
        }
    }
}
