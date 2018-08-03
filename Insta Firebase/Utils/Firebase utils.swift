//
//  Firebase utils.swift
//  Insta Firebase
//
//  Created by Viswa Kodela on 8/1/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

extension Database {
    
    static func fetchUserWithUID(uid: String, completion: @escaping (Users) -> ()){
        
        Database.database().reference().child("users").child(uid).observe(.value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            
            let user = Users(uid: uid, dictionary: dictionary)
            
            //            self.fetchPostsWithUser(user: user)
            completion(user)
        }
    }
}
