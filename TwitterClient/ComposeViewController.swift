//
//  ComposeViewController.swift
//  TwitterClient
//
//  Created by Katherine Eisenbrand on 6/29/16.
//  Copyright © 2016 Katherine Eisenbrand. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol ComposeViewControllerDelegate : class {
    func didPostTweet(tweet: Tweet)
}

class ComposeViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var charactersLeftLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    
    
    let tweetPlaceholder = "What's happening?"
    let characterLimit = 140
    
    var user = User.currentUser
    
    weak var delegate: ComposeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        toggleButton(false)
        
        textView.text = tweetPlaceholder
        textView.textColor = UIColor.lightGrayColor()
        textView.delegate = self
        
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
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == tweetPlaceholder {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            textView.text = tweetPlaceholder
            textView.textColor = UIColor.lightGrayColor()
        }
        textView.resignFirstResponder()
        toggleButton(false)
    }
    
    func textViewDidChange(textView: UITextView) {
        charactersLeftLabel.text = "\(characterLimit-textView.text.characters.count)"
        if characterLimit-textView.text.characters.count < 0 {
            textView.text = textView.text.substringToIndex(textView.text.startIndex.advancedBy(characterLimit))
            charactersLeftLabel.text = "0"
        }
        if textView.text.characters.count > 0 {
            toggleButton(true)
        } else {
            toggleButton(false)
        }
    }
    
    @IBAction func tapped(sender: UITapGestureRecognizer) {
        textView.resignFirstResponder()
    }
    
    @IBAction func postTweet(sender: AnyObject) {
        TwitterClient.sharedInstance.postTweet(textView.text, success: { (tweet: Tweet) in
            self.delegate?.didPostTweet(tweet)
            self.dismissViewControllerAnimated(true, completion: nil)
        }) { (error: NSError) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func toggleButton(enabled: Bool) {
        tweetButton.enabled = enabled
        if enabled {
            UIView.animateWithDuration(0.5, delay:0, options:UIViewAnimationOptions.TransitionFlipFromTop, animations: {
                self.tweetButton.alpha = 1
                }, completion: { finished in
            })
        } else {
            UIView.animateWithDuration(0.5, delay:0, options:UIViewAnimationOptions.TransitionFlipFromTop, animations: {
                self.tweetButton.alpha = 0.5
                }, completion: { finished in
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
