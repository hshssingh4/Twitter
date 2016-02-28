//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Harpreet Singh on 2/23/16.
//  Copyright © 2016 Harpreet Singh. All rights reserved.
//

import UIKit
import UIScrollView_InfiniteScroll

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var tweets: [Tweet]!
    var refreshControl: UIRefreshControl!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        TwitterClient.sharedInstance.homeTimeline(20, success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.estimatedRowHeight = 120
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
            })
            { (error: NSError) -> () in
                print(error.localizedDescription)}

        addRefreshControl()
        addInfiniteScroll()
        modifyView()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // Table View Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let tweets = tweets
        {
            return tweets.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("TwitterCell") as! TwitterCell
        
        cell.tweet = tweets[indexPath.row]
        cell.retweetButton.tag = indexPath.row
        cell.favoriteButton.tag = indexPath.row

        let modifiedCell = modifyCell(cell)
        return modifiedCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    
    @IBAction func onLogoutButton(sender: AnyObject)
    {
        let alert = UIAlertController(title: "Are you sure you want to log out?", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        // Two Actions Added.
        alert.addAction(UIAlertAction(title: "Log Out", style: UIAlertActionStyle.Destructive, handler: logoutUser))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        // Present the Alert.
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func logoutUser(alert: UIAlertAction)
    {
        TwitterClient.sharedInstance.logout()
    }
    
    @IBAction func onRetweetButton(sender: AnyObject)
    {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let senderButton = sender as! UIButton
        let tweet = tweets[senderButton.tag]
        let id = tweet.id
        if tweet.retweeted! == true
        {
            alert.addAction(UIAlertAction(title: "Undo Retweet", style: UIAlertActionStyle.Destructive, handler: { action in
                TwitterClient.sharedInstance.unretweet(id!, success: { (Tweet) -> () in
                    tweet.retweeted = false
                    tweet.retweetCount--
                    self.tableView.reloadData()
                    }, failure: { (error: NSError) -> () in
                        print(error.localizedDescription)
                })}))
                
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { action in
                self.tableView.reloadData()}))
            
            // Present the Alert.
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            alert.addAction(UIAlertAction(title: "Retweet", style: UIAlertActionStyle.Default, handler: { action in
                TwitterClient.sharedInstance.retweet(id!, success: { (retweetedTweet: Tweet) -> () in
                    tweet.retweeted = true
                    tweet.retweetCount++
                    self.tableView.reloadData()
                    }) { (error: NSError) -> () in
                        print("Error: \(error.localizedDescription)")
                        self.tableView.reloadData()
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { action in
                self.tableView.reloadData()}))
            
            // Present the Alert.
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func onFavoriteButton(sender: AnyObject)
    {
        let senderButton = sender as! UIButton
        let tweet = tweets[senderButton.tag]
        let id = tweet.id
        if tweet.favorited! == true
        {
            TwitterClient.sharedInstance.unfavorite(id!, success: { (favoritedTweet: Tweet) -> () in
                tweet.favorited = false
                tweet.favoritesCount--
                self.tableView.reloadData()
                }) { (error: NSError) -> () in
                    print("Error: \(error.localizedDescription)")
            }
        }
        else
        {
            TwitterClient.sharedInstance.favorite(id!, success: { (favoritedTweet: Tweet) -> () in
                tweet.favorited = true
                tweet.favoritesCount++
                self.tableView.reloadData()
                }) { (error: NSError) -> () in
                    print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    // Refresh control methods
    func addRefreshControl()
    {
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.blackColor()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    func onRefresh()
    {
        appendRefreshedTweets()
        self.refreshControl.endRefreshing()
    }
    
    func appendRefreshedTweets()
    {
        let latestTweetDate = self.tweets[0].datePosted
        TwitterClient.sharedInstance.homeTimeline(20, success: { (tweets: [Tweet]) -> () in
            
            for tweet in tweets
            {
                if tweet.datePosted?.timeIntervalSinceDate(latestTweetDate!) > 0
                {
                    self.tweets.insert(tweet, atIndex: 0)
                    self.tableView.setContentOffset(CGPoint(x: 0, y: 64), animated: false)
                }
            }
        
            self.tableView.reloadData()
            })
            { (error: NSError) -> () in
                print(error.localizedDescription)}
    }
    
    // Infinite scroll methods
    func addInfiniteScroll()
    {
        tableView.addInfiniteScrollWithHandler { (scrollView) -> Void in
            let tableView = scrollView as! UITableView
            let lastTweetDate = self.tweets[self.tweets.count-1].datePosted
            
            TwitterClient.sharedInstance.homeTimeline(self.tweets.count + 20, success: { (tweets: [Tweet]) -> () in
                
                for tweet in tweets
                {
                    if tweet.datePosted?.timeIntervalSinceDate(lastTweetDate!) < 0
                    {
                        self.tweets.append(tweet)
                    }
                }
                self.tableView.reloadData()
                })
                { (error: NSError) -> () in
                    print(error.localizedDescription)}
            
            // finish infinite scroll animation
            tableView.finishInfiniteScroll()
        }
    }
    
    // Modifying methods
    func modifyView()
    {
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "TwitterLogo"))
        self.tableView.infiniteScrollIndicatorStyle = .Gray
    }

    func modifyCell(cell: TwitterCell) -> TwitterCell
    {
        if cell.tweet.retweeted! == true
        {
            cell.retweetButton.imageView?.image = UIImage(named: "RetweetActionOnIcon")
        }
        else
        {
            cell.retweetButton.imageView?.image = UIImage(named: "RetweetActionOffIcon")
        }
        
        if cell.tweet.favorited! == true
        {
            cell.favoriteButton.imageView?.image = UIImage(named: "FavoriteActionOnIcon")
        }
        else
        {
            cell.favoriteButton.imageView?.image = UIImage(named: "FavoriteActionOffIcon")
        }
        cell.userImageView.layer.cornerRadius = 5.0
        cell.mediaImageView.layer.cornerRadius = 5.0
        return cell
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
