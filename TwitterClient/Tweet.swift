//
//  Tweet.swift
//  TwitterClient
//
//  Created by Katherine Eisenbrand on 6/27/16.
//  Copyright © 2016 Katherine Eisenbrand. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var text: String?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var user: User?
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        let timeStampString = dictionary["created_at"] as? String
        
        if let timeStampString = timeStampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timeStampString)
        }
        
        if let userData = dictionary["user"] as? NSDictionary {
            self.user = User(dictionary: userData)
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
        }
        
        return tweets
    }
    
    class func timeAgoSince(date: NSDate) -> String {
        
        let calendar = NSCalendar.currentCalendar()
        let now = NSDate()
        let unitFlags: NSCalendarUnit = [.Second, .Minute, .Hour, .Day, .WeekOfYear, .Month, .Year]
        let components = calendar.components(unitFlags, fromDate: date, toDate: now, options: [])
        
        if components.year > 0 {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MMM d yyyy"
            return formatter.stringFromDate(date)
        }
        
        if components.day >= 1 {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MMM d"
            return formatter.stringFromDate(date)
        }
        
        if components.hour >= 1 {
            return "\(components.hour)h"
        }
        
        if components.minute >= 1 {
            return "\(components.minute)m"
        }
        
        if components.second >= 3 {
            return "\(components.second)s"
        }
        
        return "1s"
        
    }
    
}
