//
//  UserDetails.swift
//  Insta Firebase
//
//  Created by Viswa Kodela on 7/24/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

struct UserDetails {
    
    let userName: String
    let profileImageUrl: String
    
    init(dictionary: [String : Any]) {
        self.userName = dictionary["username"] as? String ?? "No username found"
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? "No profileImageUrl Found"
    }
}
