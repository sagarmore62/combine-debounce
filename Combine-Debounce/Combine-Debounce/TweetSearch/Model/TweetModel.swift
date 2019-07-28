//
//  TweetModel.swift
//  Debounce-Demo
//
//  Created by Sagar More on 27/07/19.
//  Copyright © 2019 Sagar More. All rights reserved.
//

import Foundation

struct Tweet: Decodable {
    let text: String
    let user: User
}

struct User: Decodable {
    let name, profileImageUrl: String
}
