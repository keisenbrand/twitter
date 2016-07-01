//
//  DetailViewController.swift
//  TwitterClient
//
//  Created by Katherine Eisenbrand on 6/29/16.
//  Copyright © 2016 Katherine Eisenbrand. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "View Tweet"
        navigationItem.backBarButtonItem?.title = "Back"
        
//        replyButton.setImage(UIImage(named: "reply"), forState: .Normal)
//        
//        retweetButton.setImage(UIImage(named: "retweet_before"), forState: .Normal)
//        retweetButton.setImage(UIImage(named: "retweet_after"), forState: .Selected)
//        
//        favoriteButton.setImage(UIImage(named: "like_after"), forState: .Normal)
        
        updateView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateView() {
        if let tweet = tweet {
            usernameLabel.text = tweet.user?.name as? String
            
            if let profileURL = tweet.user?.profileURL {
                
                profileImageView.setImageWithURL(profileURL)
            }
            
            if let screenname = tweet.user?.screenname {
                screennameLabel.text = "@" + (screenname as String)
            }
            
            
            tweetText.text = tweet.text
            
            if let timestamp = tweet.timestamp {
                timestampLabel.text = Tweet.timeAgoSince(timestamp)
            }
            
            retweetsLabel.text = "\(tweet.retweetCount)"
            
            favoritesLabel.text = "\(tweet.favoritesCount)"
            
            if tweet.favorited == 1 {
                favoriteButton.selected = true
                favoriteButton.setImage(UIImage(named: "likePressed"), forState: .Highlighted)
            } else {
                favoriteButton.selected = false
                favoriteButton.setImage(UIImage(named: "likeOnPressed"), forState: .Highlighted)
            }
            
            if tweet.retweeted == 1 {
                retweetButton.selected = true
                retweetButton.setImage(UIImage(named: "retweetPressed"), forState: .Highlighted)
            } else {
                retweetButton.selected = false
                retweetButton.setImage(UIImage(named: "retweetOnPressed"), forState: .Highlighted)
            }
        }
    }
    
    @IBAction func replyButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func retweetButtonPressed(sender: AnyObject) {
        if !sender.selected {
            tweet!.retweet({
                self.updateView()
                }, failure: { (error: NSError) in
                    print(error.localizedDescription)
            })
        }
    }
    
    @IBAction func favoriteButtonPressed(sender: AnyObject) {
        if !sender.selected {
            tweet!.favorite({
                self.updateView()
                }, failure: { (error: NSError) in
                    print(error.localizedDescription)
            })
        } else {
            tweet!.unfavorite({
                self.updateView()
                }, failure: { (error: NSError) in
                    print(error.localizedDescription)
            })
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
