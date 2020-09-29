//
//  Users.swift
//  dummy
//
//  Created by Macbook Air on 27.09.2020.
//  Copyright © 2020 macbook. All rights reserved.
//

import Foundation

struct Users: Decodable {
    let data: [UserInfo]
}

struct UserInfo: Decodable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let picture: String
}
