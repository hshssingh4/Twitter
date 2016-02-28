//
//  LoginViewController.swift
//  Twitter
//
//  Created by Harpreet Singh on 2/22/16.
//  Copyright © 2016 Harpreet Singh. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import ChameleonFramework

class LoginViewController: UIViewController
{
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var twitterLogoImageView: UIImageView!
    let color1 = UIColor(hexString: "#33ff66", withAlpha: 0.9)
    let color2 = UIColor(hexString: "#55acee")

    override func viewDidLoad()
    {
        super.viewDidLoad()
        messageLabel.text = "Get real-time updates about what matters to you."
        loginButton.layer.cornerRadius = 5.0
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        let backgroundColor = GradientColor(UIGradientStyle.TopToBottom, frame: self.view.frame, colors: [color1, color2])
        self.view.backgroundColor = backgroundColor
        let originaCenter = self.twitterLogoImageView.center
        self.twitterLogoImageView.center = self.view.center
        UIView.animateWithDuration(1.0) { () -> Void in
            self.twitterLogoImageView.center = originaCenter
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButtonTap(sender: AnyObject)
    {
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.messageLabel.hidden = true
            self.welcomeLabel.hidden = true
            self.loginButton.hidden = true
            self.twitterLogoImageView.center.y = self.view.center.y
            }, completion: { finished in
                TwitterClient.sharedInstance.login({ () -> () in
                    
                    self.performSegueWithIdentifier("loginSegue", sender: nil)
                    
                    }) { (error: NSError) -> () in
                        print("Error: \(error.localizedDescription)")
                }
        })
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
