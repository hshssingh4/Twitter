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
    var user: User!

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
        usernameLabel.text = user.name!
        screennameLabel.text = "@\(user.screenname!)"
        if let profileImageUrl = user.profileUrl
        {
            userImageView.setImageWithURL(profileImageUrl)
        }
        if let profileBackgroundImageUrl = user.headerImageUrl
        {
            headerImageView.setImageWithURL(profileBackgroundImageUrl)
        }
        print(user.headerImageUrl)
        tweetsCountLabel.text = "\(user.statusesCount!)"
        followersCountLabel.text = "\(user.followersCount!)"
        followingCountLabel.text = "\(user.friendsCount!)"
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
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
