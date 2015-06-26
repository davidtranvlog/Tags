//
//  TweetTableViewCell.swift
//  Tags
//
//  Created by Duc Tran on 6/8/15.
//  Copyright (c) 2015 Developer Inspirus. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetImageView: UIImageView!

    private func updateUI()
    {
        // configure the tweet here.
        // reset any existing tweet info
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        if let tweet = self.tweet {
            var tweetText = tweet.text
            if tweetTextLabel?.text != nil {
                for _ in tweet.media {
                    tweetText += " 📷"
                }
            }
            
            var attributedTweetText = NSMutableAttributedString(string: tweetText)
            attributedTweetText.changeKeywordsColor(tweet.hashtags, color: indexedKeywordColor)
            attributedTweetText.changeKeywordsColor(tweet.urls, color: indexedKeywordColor)
            attributedTweetText.changeKeywordsColor(tweet.userMentions, color: indexedKeywordColor)
            
            tweetTextLabel.attributedText = attributedTweetText
            
            // username
            tweetScreenNameLabel?.text = "\(tweet.user)"
            
            // profile image 
            fetchProfileImage()
            fetchTweetImage()
            configureTweetDate()
        }
    }
    
    func fetchProfileImage()
    {
        if let profileImageURL = tweet!.user.profileImageURL {
            
            let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
            dispatch_async(dispatch_get_global_queue(qos, 0)) {
                
                if let imageData = NSData(contentsOfURL: profileImageURL) {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tweetProfileImageView?.image = UIImage(data: imageData)
                    }
                }
                
            }
            
        }
    }
    
    func fetchTweetImage()
    {
        if let tweetImageURL = tweet!.media.first?.url {
            let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                
                if let tweetImageData = NSData(contentsOfURL: tweetImageURL) {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tweetImageView?.image = UIImage(data: tweetImageData)
                    })
                }
            })
        }
    }
    
    func configureTweetDate()
    {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        tweetCreatedLabel?.text = formatter.stringFromDate(tweet!.created)
    }
    
}

public var indexedKeywordColor = UIColor(red: 85/255.0, green: 172/255.0, blue: 238/255.0, alpha: 1)

private extension NSMutableAttributedString
{
    func changeKeywordsColor(keywords: [Tweet.IndexedKeyword], color: UIColor)
    {
        for keyword in keywords {
            addAttribute(NSForegroundColorAttributeName, value: color, range: keyword.nsrange)
        }
    }
}


























