//
//  Date Extension.swift
//  Insta Firebase
//
//  Created by Viswa Kodela on 8/2/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit


extension Date {
    
    func timeAgoDisplay() -> String {
        
        
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour  = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        let year = 12 * month
        
        if secondsAgo < minute {
            return "\(secondsAgo) seconds ago"
        }
        else if secondsAgo < hour{
            return "\(secondsAgo / minute) minutes ago"
        }
        else if secondsAgo < day {
            return "\(secondsAgo / hour) hours ago"
        }
        else if secondsAgo < week {
            return "\(secondsAgo / day) days ago"
        }
        else if secondsAgo < month {
            return "\(secondsAgo / week) weeks ago"
        }
        else if secondsAgo < year {
            return "\(secondsAgo / month) months ago"
        }
        return "\(secondsAgo / year) years ago"
        
    }
    
}
