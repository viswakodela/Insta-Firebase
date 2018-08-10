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
        
        let quotient: Int
        let unit: String
        
        let minute = 60
        let hour  = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        let year = 12 * month
        
        if secondsAgo < minute {
            quotient =  secondsAgo
            unit = "seconds"
        }
        else if secondsAgo < hour{
            quotient =  secondsAgo / minute
            unit = "minute"
        }
        else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "hour"
        }
        else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "day"
        }
        else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "week"
        }
        else if secondsAgo < year {
            quotient = secondsAgo / month
            unit = "month"
        }
        else{
            quotient = secondsAgo / year
            unit = "year"
        }
        
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
        
        
    }
    
}
