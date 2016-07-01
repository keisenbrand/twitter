//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by Katherine Eisenbrand on 6/28/16.
//  Copyright © 2016 Katherine Eisenbrand. All rights reserved.
//

import UIKit
import MBProgressHUD

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellID = "FeedCell"
    let cellHeightEstimate: CGFloat = 90
    
    var tweets = [Tweet]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var isFirstLoad = true
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = cellHeightEstimate
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Initialize a UIRefreshControl
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        //tableView.insertSubview(networkErrorView, atIndex: 0)
        tableView.insertSubview(refreshControl, atIndex: 0)
        refreshControlAction(refreshControl)
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
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        if isFirstLoad {
            // Display HUD right before the request is made
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        }
        
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) in
            self.tweets = []
            self.tweets.appendContentsOf(tweets)
            }, failure: { (error: NSError) in
                print(error.localizedDescription)
        })
        
        refreshControl.endRefreshing()
        if self.isFirstLoad {
            self.isFirstLoad = false
            // Hide HUD once the network request comes back (must be done on main UI thread)
            MBProgressHUD.hideHUDForView(self.view, animated: true)
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
