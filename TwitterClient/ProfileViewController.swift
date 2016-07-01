//
//  ProfileViewController.swift
//  TwitterClient
//
//  Created by Katherine Eisenbrand on 7/1/16.
//  Copyright © 2016 Katherine Eisenbrand. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var exitButton: UIBarButtonItem!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        navigationItem.title = "View Profile"
        
        if tabBarController?.selectedIndex == 1 {
            exitButton.enabled = false
        }
        
        if let user = user {
            usernameLabel.text = user.name as? String
            
            if user.screenname == User.currentUser?.screenname {
                navigationItem.title = "My Profile"
            }
            
            if let profileURL = user.profileURL {
                
                imageView.setImageWithURL(profileURL)
            }
            
            if let screenname = user.screenname {
                screennameLabel.text = "@" + (screenname as String)
            }
            
            if let tagline = user.tagline {
                taglineLabel.text = tagline as String
            }
            
            followingLabel.text = "\(user.following)"
            followersLabel.text = "\(user.followers)"
            
            if user.followers != 1 {
                followersLabel.text = "Followers"
            } else {
                followersLabel.text = "Follower"
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onExit(sender: AnyObject) {
        if tabBarController?.selectedIndex != 1 {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
