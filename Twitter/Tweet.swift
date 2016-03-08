//
//  Tweet.swift
//  Twitter
//
//  Created by Harpreet Singh on 2/23/16.
//  Copyright © 2016 Harpreet Singh. All rights reserved.
//

import UIKit

class Tweet: NSObject
{
    var tweeter: NSDictionary?
    var tweetersName: String?
    var tweetersScreenname: String?
    var tweetersImageUrl: NSURL?
    var mediaUrl: NSURL?
    var text: String?
    var timestamp: String?
    var datePosted: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var retweetersName: String?
    var id: Int?
    var retweeted: Bool?
    var favorited: Bool?
    
    init(var dictionary: NSDictionary)
    {
        if let dictionaryStatus = dictionary["retweeted_status"]
        {
            retweetersName = (dictionary["user"] as! NSDictionary)["name"] as? String
            dictionary = dictionaryStatus as! NSDictionary
        }
        
        id = dictionary["id"] as? Int
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        retweeted = dictionary["retweeted"] as? Bool
        favorited = dictionary["favorited"] as? Bool
        
        let user = dictionary["user"] as! NSDictionary
        tweeter = user
        tweetersName = user["name"] as? String
        tweetersScreenname = "@\((user["screen_name"] as? String)!)"
        if let profileImageUrl = user["profile_image_url"] as? String
        {
            tweetersImageUrl = NSURL(string: profileImageUrl)
        }
        
        let entities = dictionary["entities"] as! NSDictionary
        if let media = entities["media"] as? NSArray
        {
            let imageMediaUrl = media[0]["media_url"] as? String
            mediaUrl = NSURL(string: imageMediaUrl!)
        }
        
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString
        {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:s Z y"
            datePosted = formatter.dateFromString(timestampString)
            
            let duration = (datePosted?.timeIntervalSinceNow)! * -1 // Get time passed.
            
            switch duration
            {
            case 0..<60:
                timestamp = "\(Int(duration))s"
            case 60..<3600:
                timestamp = "\(Int(duration / 60))m"
            case 3600..<86400:
                timestamp = "\(Int(duration / 3600))h"
            default:
                timestamp = "\(Int(duration / 86400))d"
            }
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]
    {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries
        {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }

    class func getTweet(dictionary: NSDictionary) -> Tweet
    {
        return Tweet(dictionary: dictionary)
    }
}
