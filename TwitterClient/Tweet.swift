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
    var idStr: String?
    var favorited: Int = 0
    var retweeted: Int = 0
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        let timeStampString = dictionary["created_at"] as? String
        
        if let timeStampString = timeStampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timeStampString)
        }
        
        idStr = dictionary["id_str"] as? String
        
        favorited = dictionary["favorited"] as? Int ?? 0
        retweeted = dictionary["retweeted"] as? Int ?? 0
        
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
    
    func favorite(success: () -> (), failure: (NSError) -> ()) {
        TwitterClient.sharedInstance.favorite(self, success: { () in
            self.favoritesCount += 1
            self.favorited = 1
            success()
        }) { (error: NSError) in
            failure(error)
        }
    }
    
    func unfavorite(success: () -> (), failure: (NSError) -> ()) {
        TwitterClient.sharedInstance.unfavorite(self, success: { () in
            self.favoritesCount -= 1
            self.favorited = 0
            success()
        }) { (error: NSError) in
            failure(error)
        }
    }
    
    func retweet(success: () -> (), failure: (NSError) -> ()) {
        TwitterClient.sharedInstance.retweet(self, success: { () in
            self.retweetCount += 1
            self.retweeted = 1
            success()
        }) { (error: NSError) in
            failure(error)
        }
    }
    
}
