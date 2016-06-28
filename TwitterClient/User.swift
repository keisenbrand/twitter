//
//  User.swift
//  TwitterClient
//
//  Created by Katherine Eisenbrand on 6/27/16.
//  Copyright © 2016 Katherine Eisenbrand. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: NSString?
    var screenname: NSString?
    var profileURL: NSURL?
    var tagline: NSString?
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        
        let profileURLString = dictionary["profile_image_url_https"] as? String
        if let profileURLString = profileURLString {
            profileURL = NSURL(string: profileURLString)
        }
        
        tagline = dictionary["description"] as? String
    }
}
