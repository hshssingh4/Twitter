//
//  UserProfileViewController.swift
//  Twitter
//
//  Created by Harpreet Singh on 3/7/16.
//  Copyright © 2016 Harpreet Singh. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController
{
    var tweeter: NSDictionary!

    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initUser()
    }
    
    func initUser()
    {
        usernameLabel.text = tweeter["name"] as? String
        screennameLabel.text = "@\(tweeter["screen_name"] as! String)"
        if let profileImageUrl = tweeter["profile_image_url"] as? String
        {
            let tweetersImageUrl = NSURL(string: profileImageUrl)
            userImageView.setImageWithURL(tweetersImageUrl!)
        }
        if let profileBackgroundImageUrl = tweeter["profile_background_image_url"] as? String
        {
            let tweeterBackgroundImageUrl = NSURL(string: profileBackgroundImageUrl)
            headerImageView.setImageWithURL(tweeterBackgroundImageUrl!)
        }
        tweetsCountLabel.text = "\(tweeter["statuses_count"] as! Int)"
        followersCountLabel.text = "\(tweeter["followers_count"] as! Int)"
        followingCountLabel.text = "\(tweeter["friends_count"] as! Int)"
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
