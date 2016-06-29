//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by Katherine Eisenbrand on 6/28/16.
//  Copyright © 2016 Katherine Eisenbrand. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellID = "FeedCell"
    
    var tweets = [Tweet]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 130
        tableView.rowHeight = UITableViewAutomaticDimension
        
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) in
            self.tweets.appendContentsOf(tweets)
            }, failure: { (error: NSError) in
                print(error.localizedDescription)
        })
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID) as! FeedCell
        
        let tweet = tweets[indexPath.row]
        cell.usernameLabel.text = tweet.user?.name as? String
        
        if let profileURL = tweet.user?.profileURL {
            cell.profileImageView.setImageWithURL(profileURL)
        }
        
        if let screenname = tweet.user?.screenname {
            cell.screennameLabel.text = "@" + (screenname as String)
        }
        
        cell.tweetTextLabel.text = tweet.text
        
        if let timestamp = tweet.timestamp {
            cell.timestampLabel.text = Tweet.timeAgoSince(timestamp)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
