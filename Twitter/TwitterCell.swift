//
//  TwitterCell.swift
//  Twitter
//
//  Created by Harpreet Singh on 2/23/16.
//  Copyright © 2016 Harpreet Singh. All rights reserved.
//

import UIKit

class TwitterCell: UITableViewCell
{
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetersNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    @IBOutlet weak var mediaImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var retweetersLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topRetweetImageViewHeightConstraint: NSLayoutConstraint!
    

    var tweet: Tweet!
    {
        didSet
        {
            tweetTextLabel.text = tweet.text!
            timestampLabel.text = String(tweet.timestamp!)
            retweetCountLabel.text = String(tweet.retweetCount)
            favoritesCountLabel.text = String(tweet.favoritesCount)
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
                mediaImageView.image = nil
                mediaImageViewHeightConstraint.constant = 0
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
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        mediaImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}
