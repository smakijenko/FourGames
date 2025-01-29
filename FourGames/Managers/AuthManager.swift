//
//  AuthManager.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 21/01/2025.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class AuthManager {
    static let shared = AuthManager()
    private init() { }
    
    func getProviders() throws -> [AuthProviderOption] {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            print("\(MyError.noProvider.localizedDescription)")
            throw MyError.noProvider
        }
        
        var providers: [AuthProviderOption] = []
        for provider in providerData {
            if let option = AuthProviderOption(rawValue: provider.providerID) {
                providers.append(option)
            } else {
                throw MyError.noProvider
            }
        }
        return providers
    }
    
    func getAuthenticatedUser() throws -> AuthUserDataModel {
        guard let user = Auth.auth().currentUser else {
            print("\(MyError.noAuthUser.localizedDescription)")
            throw MyError.noAuthUser
        }
        return AuthUserDataModel (
            uid: user.uid,
            email: user.email ?? "",
            photoUrl: user.photoURL?.absoluteString ?? "",
            name: user.displayName ?? ""
        )
    }
    
    func getAuthUserDataFromDB(uId: String) async throws -> AuthUserDataModel {
        let db = Firestore.firestore()
        let documentRef = db.collection("users").document(uId)
        let document = try await documentRef.getDocument()
        guard document.exists, let data = document.data() else {
            print("\(MyError.unableFetchUserData.localizedDescription)")
            throw MyError.unableFetchUserData
        }
        return AuthUserDataModel (
            uid: data["uId"] as! String,
            email: data["email"] as! String,
            photoUrl: data["photoUrl"] as! String,
            name: data["name"] as! String
        )
    }
}
// Signing in with google
extension AuthManager {
    func signInWithGoogle() async throws {
        let helper = SignInGoogleHelper()
        do {
            let tokens = try await helper.signIn()
            let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
            let authDataResult = try await Auth.auth().signIn(with: credential)
            let user = AuthUserDataModel (
                uid: authDataResult.user.uid,
                email: authDataResult.user.email ?? "",
                photoUrl: authDataResult.user.photoURL?.absoluteString ?? "",
                name: authDataResult.user.displayName ?? ""
            )
            if await !checkIfUserExistsInDB(uId: user.uid) {
                try await addNewUser (
                    uId: user.uid,
                    email: user.email,
                    photoUrl: user.photoUrl,
                    name: user.name
                )
                try await addNewUserScores(uId: user.uid)
            }
        }
        catch {
            print("\(MyError.unableSignInWithGoogle.localizedDescription)")
            throw MyError.unableSignInWithGoogle
        }
    }
    
    private func checkIfUserExistsInDB(uId: String) async -> Bool {
        guard !uId.isEmpty else { return false }
        let docRef = Firestore.firestore().collection("users").document(uId)
        do {
            let doc = try await docRef.getDocument()
            return doc.exists
        }
        catch {
            return false
        }
    }
}

// Signing in with email
extension AuthManager {
    func signInEmailUser(email: String, password: String) async throws {
        guard !email.isEmpty && !password.isEmpty else { return }
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
        }
        catch {
            print("\(MyError.unableSignInWithEmail.localizedDescription)")
            throw MyError.unableSignInWithEmail
        }
    }
}

// Signing up with Email
extension AuthManager {
    func signUpEmailUser(selectedImage: UIImage?, name: String, email: String, password: String) async throws {
        guard let selectedImage = selectedImage else { return }
        guard !name.isEmpty && !email.isEmpty && !password.isEmpty else { return }
        do {
            let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let imageURL = try await uploadImage(selectedImage: selectedImage)
            let uId = authDataResult.user.uid
            try await addNewUser(uId: uId, email: email, photoUrl: imageURL, name: name)
            try await addNewUserScores(uId: uId)
        }
        catch {
            if let myError = error as? MyError, myError == .unableDownloadImgUrl || myError == .unableUploadImgToStorage {
                // TODO -> DELETE AUTH USER
            }
            else if let myError = error as? MyError, myError == .unableAddUser {
                // TODO -> DELETE AUTH USER AND UPLOADED IMAGE
            }
            else if let myError = error as? MyError, myError == .unableAddUserScore {
                // TODO -> DELETE AUTH USER, UPLOADED IMAGE AND DB USER
            }
            print("\(MyError.unableSignUpWithEmail.localizedDescription)")
            throw MyError.unableSignUpWithEmail
        }
    }
    
    private func uploadImage(selectedImage: UIImage) async throws -> String {
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child("profileImages/\(UUID().uuidString).jpg")
        var imageURL = ""
        if let imageData = selectedImage.jpegData(compressionQuality: 0.75) {
            do {
                _ = try await fileRef.putDataAsync(imageData)
                guard let iURL = try? await fileRef.downloadURL() else {
                    print("\(MyError.unableDownloadImgUrl.localizedDescription)")
                    throw MyError.unableDownloadImgUrl
                }
                imageURL = iURL.absoluteString
            }
            catch {
                print("\(MyError.unableUploadImgToStorage.localizedDescription)")
                throw MyError.unableUploadImgToStorage
            }
        }
        return imageURL
    }
    
    private func addNewUser(uId: String, email: String, photoUrl: String, name: String) async throws {
        let db = Firestore.firestore()
        do {
            try await db.collection("users").document(uId).setData([
                "uId" : uId,
                "email" : email,
                "photoUrl" : photoUrl,
                "name" : name
            ])
        } catch {
            print("\(MyError.unableAddUser.localizedDescription)")
            throw MyError.unableAddUser
        }
    }
    
    private func addNewUserScores(uId: String) async throws {
        let db = Firestore.firestore()
        do {
            try await db.collection("scores").document(uId).setData([
                "uId" : uId,
                "runScore" : 0,
                "wordsScore" : 0,
                "mazeScore" : 0,
                "towerScore" : 0
            ])
        } catch {
            print("\(MyError.unableAddUserScore.localizedDescription)")
            throw MyError.unableAddUserScore
        }
    }
}

// User profile methods
extension AuthManager {
    func fetchUserScore(uId: String) async throws -> UserScoresDataModel {
        let db = Firestore.firestore()
        let documentRef = db.collection("scores").document(uId)
        let document = try await documentRef.getDocument()
        guard document.exists, let data = document.data() else {
            print("\(MyError.unableFetchUserScore.localizedDescription)")
            throw MyError.unableFetchUserScore
        }
        return UserScoresDataModel (
            uid: data["uId"] as! String,
            runScore: data["runScore"] as! Int,
            wordsScore: data["wordsScore"] as! Double,
            mazeScore: data["mazeScore"] as! Double,
            towerScore: data["towerScore"] as! Int
        )
    }
    
    func fetchBestScore() async throws -> UserScoresDataModel {
        var bestScores: [String: Any] = [
            "runScore": 0,
            "wordsScore": 1420.0,
            "mazeScore": 1420.0,
            "towerScore": 0
        ]
        let db = Firestore.firestore()
        do {
            let querySnapshot = try await db.collection("scores").getDocuments()
            for document in querySnapshot.documents {
                let data = document.data()
                if let runScore = data["runScore"] as? Int,
                   runScore > (bestScores["runScore"] as! Int) {
                    bestScores["runScore"] = runScore
                }
                if let wordsScore = data["wordsScore"] as? Double,
                   wordsScore < (bestScores["wordsScore"] as! Double) && wordsScore != 0 {
                    bestScores["wordsScore"] = wordsScore
                }
                if let mazeScore = data["mazeScore"] as? Double,
                   mazeScore < (bestScores["mazeScore"] as! Double) && mazeScore != 0  {
                    bestScores["mazeScore"] = mazeScore
                }
                if let towerScore = data["towerScore"] as? Int,
                   towerScore > (bestScores["towerScore"] as! Int) {
                    bestScores["towerScore"] = towerScore
                }
            }
        } catch {
            print("\(MyError.unableFetchBestScore.localizedDescription)")
            throw MyError.unableFetchBestScore
        }
        if bestScores["wordsScore"] as! Double == 1420.0 || bestScores["mazeScore"] as! Double == 1420.0 {
            print("\(MyError.unableFetchBestScore.localizedDescription)")
            throw MyError.unableFetchBestScore
        }
        return UserScoresDataModel (
            uid: "",
            runScore: bestScores["runScore"] as! Int,
            wordsScore: bestScores["wordsScore"] as! Double,
            mazeScore: bestScores["mazeScore"] as! Double,
            towerScore: bestScores["towerScore"] as! Int
        )
    }
    
    func fetchAllScores() async throws -> [UserScoresDataModel] {
        var scores: [UserScoresDataModel] = []
        let db = Firestore.firestore()
        do {
            let querySnapshot = try await db.collection("scores").getDocuments()
            for document in querySnapshot.documents {
                let data = document.data()
                scores.append(UserScoresDataModel (
                    uid: data["uId"] as! String,
                    runScore: data["runScore"] as! Int,
                    wordsScore: data["wordsScore"] as! Double,
                    mazeScore: data["mazeScore"] as! Double,
                    towerScore: data["towerScore"] as! Int
                ))
            }
        }
        catch {
            print("\(MyError.unableFetchAllScores.localizedDescription)")
            throw MyError.unableFetchAllScores
        }
        return scores
    }
    
    func signOut() throws {
        do {
            try Auth.auth().signOut()
        }
        catch {
            print("\(MyError.unableSignOut.localizedDescription)")
            throw MyError.unableSignOut
        }
    }
    
    func delete() async throws {
        do {
            try await Auth.auth().currentUser?.delete()
        }
        catch {
            print("\(MyError.unableDeleteUser.localizedDescription)")
            throw MyError.unableDeleteUser
        }
    }
    
    func resetPassword(email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        }
        catch {
            print("\(MyError.unableResetPassword.localizedDescription)")
            throw MyError.unableResetPassword
        }
    }
}
