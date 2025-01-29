//
//  MyErrors.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 21/01/2025.
//

import Foundation

enum MyError: Error, LocalizedError, Equatable {
    case runtimeError(String)
    case noProvider
    case noAuthUser
    case noEmailAuthUser
    case unableFetchUserData
    case unableCreateUser
    case unableDeleteUser
    case unableDownloadImgUrl
    case unableUploadImgToStorage
    case unableAddUser
    case unableAddUserScore
    case unableSignInWithEmail
    case unableSignInWithGoogle
    case unableSignUpWithEmail
    case unableSignOut
    case unableResetPassword
    case noViewController
    case noGidToken
    case unableFetchUserScore
    case unableFetchBestScore
    case unableFetchAllScores
    
    var errorDescription: String? {
        switch self {
        case .runtimeError(let message):
            return message
        case .noProvider:
            return "Error while getting provider data from current user."
        case .noAuthUser:
            return "Error while getting authenticated user."
        case .noEmailAuthUser:
            return "Error while getting email authenticated user data."
        case .unableFetchUserData:
            return "Error while trying to fetch user data."
        case .unableCreateUser:
            return "Error while creating email authenticated user."
        case .unableDeleteUser:
            return "Error while deleting user from authenticated user."
        case .unableDownloadImgUrl:
            return "Error while downloading image URL."
        case .unableUploadImgToStorage:
            return "Error while uploading image to storage."
        case .unableAddUser:
            return "Error while adding new user."
        case .unableAddUserScore:
            return "Error while adding new user score."
        case .unableSignInWithEmail:
            return "Error while signing in email user."
        case .unableSignInWithGoogle:
            return "Error while signing in Google user."
        case .unableSignUpWithEmail:
            return "Error while signing up email user."
        case .unableSignOut:
            return "Error while signing out auth user."
        case .unableResetPassword:
            return "Error while trying to reset auth user password."
        case .noViewController:
            return "Error while trying to get view controller."
        case .noGidToken:
            return "Error while trying to get Gid token."
        case .unableFetchUserScore:
            return "Error while trying to fetch user score."
        case .unableFetchBestScore:
            return "Error while trying to fetch best score."
        case .unableFetchAllScores:
            return "Error while trying to fetch all scores."
        }
    }
}
