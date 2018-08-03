//
//  DateAlgorthem.swift
//  Insta Firebase
//
//  Created by Viswa Kodela on 8/2/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

let now = Date()
let pastDate = Date(timeIntervalSinceNow: -60)

extension Date {
    
    func tieAgoDisplay() -> String {
        
        let secondsAgo = Date().timeIntervalSince(pastDate)
        print(secondsAgo)
        return "\(secondsAgo)"
        
    }
    
}
