//
//  AuthUserDataModel.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 27/01/2025.
//

import Foundation

struct AuthUserDataModel {
    let uid: String
    let email: String
    let name: String
    let photoUrl: String

    init(uid: String, email: String, photoUrl: String, name: String) {
        self.uid = uid
        self.email = email
        self.photoUrl = photoUrl
        self.name = name
    }
}
