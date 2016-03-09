//
//  TwitterClient.swift
//  Twitter
//
//  Created by Harpreet Singh on 2/23/16.
//  Copyright © 2016 Harpreet Singh. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager
{
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: "SCeolPojrMhawPxVnTi7ZArtO", consumerSecret: "ejiIMTy9qGQIW4GL0IPoNHhHsL1pJ761Q7ViImQVlpaeX75GBN")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ())
    {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            
            print("name: \(user.name!)")
            print("screenname: \(user.screenname!)")
            print("profile url: \(user.profileUrl!)")
            print("description: \(user.tagline!)")
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func homeTimeline(var count: Int, success: ([Tweet]) -> (), failure: (NSError) -> ())
    {
        if count >= 200
        {
            count = 200
        }

        var parameters: [String : AnyObject]
        parameters = ["count": count]
        
        GET("1.1/statuses/home_timeline.json", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            success(tweets)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
            })
    }
    
    func retweet(id: Int, success: (Tweet) -> (), failure: (NSError) -> ())
    {
        var parameters: [String : AnyObject]
        parameters = ["id": id]
        
        POST("1.1/statuses/retweet.json", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let dictionary = response as! NSDictionary
            let tweet = Tweet.getTweet(dictionary)
            success(tweet)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func unretweet(id: Int, success: (Tweet) -> (), failure: (NSError) -> ())
    {
        var parameters: [String : AnyObject]
        parameters = ["include_my_retweet": 1]
        
        GET("1.1/statuses/show.json?id=\(id)", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let dictionary = response as! NSDictionary
            print(dictionary)
            let currentUserRetweet = dictionary["current_user_retweet"] as! NSDictionary
            let currentTweetId = currentUserRetweet["id"] as? Int
       
            self.POST("1.1/statuses/destroy/\(currentTweetId!).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let dictionary = response as! NSDictionary
                let tweet = Tweet.getTweet(dictionary)
                success(tweet)
                }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                    print(error.localizedDescription)
            })
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func favorite(id: Int, success: (Tweet) -> (), failure: (NSError) -> ())
    {
        var parameters: [String : AnyObject]
        parameters = ["id": id]

        POST("1.1/favorites/create.json", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let dictionary = response as! NSDictionary
            let tweet = Tweet.getTweet(dictionary)
            success(tweet)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func unfavorite(id: Int, success: (Tweet) -> (), failure: (NSError) -> ())
    {
        var parameters: [String : AnyObject]
        parameters = ["id": id]
        
        POST("1.1/favorites/destroy.json", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionary = response as! NSDictionary
            let tweet = Tweet.getTweet(dictionary)
            success(tweet)
            }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        }
    }
    
    func composeTweet(tweetText: String, success: (Tweet) -> (), failure: (NSError) -> ())
    {
        var parameters: [String : AnyObject]
        parameters = ["status": tweetText]
        
        POST("1.1/statuses/update.json", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionary = response as! NSDictionary
            let tweet = Tweet.getTweet(dictionary)
            success(tweet)
            }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        }
    }
    
    func deleteTweet(id: Int, success: (Tweet) -> (), failure: (NSError) -> ())
    {
        var parameters: [String : AnyObject]
        parameters = ["id": id]
        
        POST("1.1/statuses/destroy.json", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionary = response as! NSDictionary
            let tweet = Tweet.getTweet(dictionary)
            success(tweet)
            }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        }
    }
    
    func login(success: () -> (), failure: (NSError) -> ())
    {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "harpreetTwitterApp://oauth"), scope: nil, success: {
            (requestToken: BDBOAuth1Credential!) -> Void in
            
            print("I got a token.")
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(url!)
            
            })
            {
                (error: NSError!) -> Void in
                print("error \(error.localizedDescription)")
                self.loginFailure?(error)
        }
    }
    
    func logout()
    {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: NSURL)
    {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: {(accessToken: BDBOAuth1Credential!) -> Void in
            
            self.currentAccount({ (user: User) -> () in
                
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: NSError) -> () in
                self.loginFailure?(error)
            })
        }){(error: NSError!) -> Void in
                
            print("error \(error.localizedDescription)")
            self.loginFailure?(error)
        }
        

    }
}
