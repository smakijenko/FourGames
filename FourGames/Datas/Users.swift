//
//  Users.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 29/01/2025.
//

import Foundation

class Users {
    let users: [AuthUserDataModel] = [
        AuthUserDataModel (
            uid: "1",
            email: "test1@test.com",
            photoUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyzTWQoCUbRNdiyorem5Qp1zYYhpliR9q0Bw&s",
            name: "Carl Johnson"
        ),
        AuthUserDataModel (
            uid: "2",
            email: "test2@test.com",
            photoUrl: "https://static.wikia.nocookie.net/gtawiki/images/c/cb/TrevorPhilips-GTAVe-Prologue.png/revision/latest/scale-to-width/360?cb=20220608064500",
            name: "Trevor Philips"
        ),
        AuthUserDataModel (
            uid: "3",
            email: "test3@test.com",
            photoUrl: "https://pbs.twimg.com/profile_images/1688993067720699904/OJslW1ok_400x400.jpg",
            name: "Anne Jackson"
        ),
        AuthUserDataModel (
            uid: "4",
            email: "test4@test.com",
            photoUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSCqJXMPBWQv6-s_awKUKRCBoGOlA0KpLJy3A&s",
            name: "Karol Nowak"
        )
    ]
}
