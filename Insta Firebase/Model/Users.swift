//
//  UserDetails.swift
//  Insta Firebase
//
//  Created by Viswa Kodela on 7/24/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

struct Users{
    
    let uid: String
    let username: String
    let profileImageUrl: String
    
    init(uid: String, dictionary: [String : Any]) {
        self.username = dictionary["username"] as? String ?? "No username found"
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? "No profileImageUrl Found"
        self.uid = uid
    }
}
