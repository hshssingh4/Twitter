//
//  TweetDetailsViewController.swift
//  Twitter
//
//  Created by Harpreet Singh on 2/29/16.
//  Copyright © 2016 Harpreet Singh. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController
{
    var tweet: Tweet!
    var user: User!
    
    @IBOutlet weak var retweetersNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var mediaImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var retweetersLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topRetweetImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    let profileImageTapGesture = UITapGestureRecognizer()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        initProperties()
        profileImageTapGesture.addTarget(self, action: "segueToUserProfile")
        userImageView.userInteractionEnabled = true
        userImageView.addGestureRecognizer(profileImageTapGesture)
        self.navigationController?.navigationBar.tintColor = UIColor(hexString: "#55acee")
    }
    
    func segueToUserProfile()
    {
        performSegueWithIdentifier("segueToUserProfile", sender: userImageView)
    }
    
    
    func initProperties()
    {
        tweetLabel.text = tweet.text!
        timestampLabel.text = String(tweet.timestamp!)
        retweetCountLabel.text = String(tweet.retweetCount)
        favoriteCountLabel.text = String(tweet.favoritesCount)
        usernameLabel.text = tweet.tweetersName!
        screennameLabel.text = tweet.tweetersScreenname!
        if let imageUrl = tweet.tweetersImageUrl
        {
            userImageView.setImageWithURL(imageUrl)
        }
        if let mediaUrl = tweet.mediaUrl
        {
            mediaImageViewHeightConstraint.constant = 128
            mediaImageView.setImageWithURL(mediaUrl)
        }
        else
        {
            mediaImageView.setImageWithURL(NSURL(string: "http://placehold.it/300x300")!)
            mediaImageViewHeightConstraint.constant = 0
            print("yes")
        }
        if let retweetersName = tweet.retweetersName
        {
            retweetersLabelHeightConstraint.constant = 16
            topRetweetImageViewHeightConstraint.constant = 15
            retweetersNameLabel.text = "\(retweetersName) Retweeted"
        }
        else
        {
            retweetersNameLabel.text = nil
            retweetersLabelHeightConstraint.constant = 0
            topRetweetImageViewHeightConstraint.constant = 0
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onRetweetButton(sender: AnyObject)
    {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let id = tweet.id
        if tweet.retweeted! == true
        {
            alert.addAction(UIAlertAction(title: "Undo Retweet", style: UIAlertActionStyle.Destructive, handler: { action in
                TwitterClient.sharedInstance.unretweet(id!, success: { (Tweet) -> () in
                    self.tweet.retweeted = false
                    self.tweet.retweetCount--
                    self.retweetButton.imageView?.image = UIImage(named: "RetweetActionOffIcon")
                    self.retweetCountLabel.text = String(self.tweet.retweetCount)
                    }, failure: { (error: NSError) -> () in
                        print(error.localizedDescription)
                })}))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            
            // Present the Alert.
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            alert.addAction(UIAlertAction(title: "Retweet", style: UIAlertActionStyle.Default, handler: { action in
                TwitterClient.sharedInstance.retweet(id!, success: { (retweetedTweet: Tweet) -> () in
                    self.tweet.retweeted = true
                    self.tweet.retweetCount++
                    self.retweetButton.imageView?.image = UIImage(named: "RetweetActionOnIcon")
                    self.retweetCountLabel.text = String(self.tweet.retweetCount)
                    }) { (error: NSError) -> () in
                        print("Error: \(error.localizedDescription)")
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            
            // Present the Alert.
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func onFavoriteButton(sender: AnyObject)
    {
        let id = tweet.id
        if tweet.favorited! == true
        {
            TwitterClient.sharedInstance.unfavorite(id!, success: { (favoritedTweet: Tweet) -> () in
                self.tweet.favorited = false
                self.tweet.favoritesCount--
                self.favoriteButton.imageView?.image = UIImage(named: "FavoriteActionOffIcon")
                self.favoriteCountLabel.text = String(self.tweet.favoritesCount)
                }) { (error: NSError) -> () in
                    print("Error: \(error.localizedDescription)")
            }
        }
        else
        {
            TwitterClient.sharedInstance.favorite(id!, success: { (favoritedTweet: Tweet) -> () in
                self.tweet.favorited = true
                self.tweet.favoritesCount++
                self.favoriteButton.imageView?.image = UIImage(named: "FavoriteActionOnIcon")
                self.favoriteCountLabel.text = String(self.tweet.favoritesCount)
                }) { (error: NSError) -> () in
                    print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if sender!.isKindOfClass(UIImageView)
        {
            let userProfileViewController = segue.destinationViewController as! UserProfileViewController
            userProfileViewController.user = self.user
        }
    }
}
