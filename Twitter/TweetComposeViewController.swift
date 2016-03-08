//
//  TweetComposeViewController.swift
//  Twitter
//
//  Created by Harpreet Singh on 3/7/16.
//  Copyright © 2016 Harpreet Singh. All rights reserved.
//

import UIKit

class TweetComposeViewController: UIViewController, UITextViewDelegate
{
    @IBOutlet weak var composeTextField: UITextView!
    var user: User!
    var charCount: Int!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var composeButton: UIBarButtonItem!
    @IBOutlet weak var countLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        composeTextField.delegate = self
        composeTextField.text = "What's happening..."
        composeTextField.textColor = UIColor.lightGrayColor()
        composeTextField.userInteractionEnabled = true
        composeButton.enabled = false
        charCount = 140
        countLabel.text = "\(charCount)"
        countLabel.textColor = UIColor.greenColor()
        setUser()
        self.automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onCancelButton(sender: AnyObject)
    {
        composeTextField.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textViewDidBeginEditing(textView: UITextView)
    {
        composeTextField.text = nil
        composeTextField.textColor = UIColor.blackColor()
    }
    
    func textViewDidChange(textView: UITextView)
    {
        if let text = textView.text
        {
            if text != ""
            {
                composeButton.enabled = true
            }
            else
            {
                
                composeButton.enabled = false
            }
            charCount = 140 - textView.text.characters.count
            countLabel.text = "\(charCount)"
            if charCount < 15
            {
                countLabel.textColor = UIColor.redColor()
            }
            else
            {
                countLabel.textColor = UIColor.greenColor()
            }
            
        }
    }
    
    func setUser()
    {
        self.user = User._currentUser
        self.userImageView.setImageWithURL(user.profileUrl!)
        self.usernameLabel.text = user.name!
        self.screennameLabel.text = "@\(user.screenname!)"
    }

    @IBAction func onComposeTweet(sender: AnyObject)
    {
        TwitterClient.sharedInstance.composeTweet(composeTextField.text!, success: { (composedTweet: Tweet) -> () in
            self.composeTextField.resignFirstResponder()
            self.dismissViewControllerAnimated(true, completion: nil)
            }) { (error: NSError) -> () in
                print("Error: \(error.localizedDescription)")
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
