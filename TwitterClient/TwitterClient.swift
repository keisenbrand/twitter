//
//  TwitterClient.swift
//  TwitterClient
//
//  Created by Katherine Eisenbrand on 6/28/16.
//  Copyright © 2016 Katherine Eisenbrand. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

enum JSONURLs: String {
    case Timeline = "1.1/statuses/home_timeline.json"
    case VerifyCredentials = "1.1/account/verify_credentials.json"
    case Favorite = "1.1/favorites/create.json?id="
    case Unfavorite = "1.1/favorites/destroy.json?id="
    case Retweet = "1.1/statuses/retweet/"
    case PostTweet = "1.1/statuses/update.json?status="
}

enum TokenURLs: String {
    case AccessToken = "oauth/access_token"
    case RequestToken = "oauth/request_token"
    case AuthorizeTokenBase = "https://api.twitter.com/oauth/authorize?oauth_token="
}

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: "QbHdSNq1dWAapxWxKsgKvL8Ws", consumerSecret: "OkByjkbvW6f74GWS905yboPuOtU22vSZQQIaopRVtOFFuVAsdT")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        fetchRequestTokenWithPath(TokenURLs.RequestToken.rawValue, method: "GET", callbackURL: NSURL(string: "twitterapp://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            let url = NSURL(string: TokenURLs.AuthorizeTokenBase.rawValue + requestToken.token)!
            UIApplication.sharedApplication().openURL(url)
            }, failure: {(error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenURL(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath(TokenURLs.AccessToken.rawValue, method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            self.currentAccount({ ( user: User) in
                User.currentUser = user
                }, failure: { (error: NSError) in
                    self.loginFailure?(error)
            })
            self.loginSuccess?()
            }, failure: { (error: NSError!) in
                self.loginFailure?(error)
        })
    }
    
    func homeTimeline(success: [Tweet] -> (), failure: NSError -> ()) {
        TwitterClient.sharedInstance.GET(JSONURLs.Timeline.rawValue, parameters: nil, progress: nil, success: {(task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            success(tweets)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func currentAccount(success: User -> (), failure: NSError -> ()) {
        TwitterClient.sharedInstance.GET(JSONURLs.VerifyCredentials.rawValue, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })
        
    }
    
    func favorite(tweet: Tweet, success: () -> (), failure: NSError -> ()) {
        let url = JSONURLs.Favorite.rawValue + tweet.idStr!
        TwitterClient.sharedInstance.POST(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            success()
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
    }
    
    func unfavorite(tweet: Tweet, success: () -> (), failure: NSError -> ()) {
        let url = JSONURLs.Unfavorite.rawValue + tweet.idStr!
        TwitterClient.sharedInstance.POST(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            success()
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
    }
    
    func retweet(tweet: Tweet, success: () -> (), failure: NSError -> ()) {
        let url = JSONURLs.Retweet.rawValue + tweet.idStr! + ".json"
        TwitterClient.sharedInstance.POST(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            success()
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
    }
    
    func postTweet(message: String, success: (Tweet) -> (), failure: NSError -> ()) {
        let url = JSONURLs.PostTweet.rawValue + message
        TwitterClient.sharedInstance.POST(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            success(Tweet(dictionary: response as! NSDictionary))
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
    }
}
