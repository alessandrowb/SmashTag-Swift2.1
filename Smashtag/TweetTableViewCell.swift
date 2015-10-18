//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Alessandro on 10/17/15.
//  Copyright © 2015 Alessandro Belardinelli. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    private struct TweetTextColors {
        static let hashtagColor = UIColor.greenColor()
        static let urlColor = UIColor.blueColor()
        static let userColor = UIColor.orangeColor()
    }
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    func updateUI() {
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        // load new information from our tweet (if any)
        if let tweet = self.tweet {
            setTweetTextLabel(tweet)
            setTwitterScreenName(tweet)
            setTweetImageView(tweet)
            setTwitterDate(tweet)
        }
    }
    
    // MARK: - TweetCellContent
    
    private func setTweetTextLabel(tweet: Tweet) {
        var tweetText: String = tweet.text
        for _ in tweet.media {tweetText += " 📷"}
        let attribText = NSMutableAttributedString(string: tweetText)
        
        attribText.setKeywordsColor(tweet.hashtags, color: TweetTextColors.hashtagColor)
        attribText.setKeywordsColor(tweet.urls, color: TweetTextColors.urlColor)
        attribText.setKeywordsColor(tweet.userMentions, color: TweetTextColors.userColor)
        
        tweetTextLabel?.attributedText = attribText
    }
    
    private func setTwitterScreenName (tweet: Tweet) {
        tweetScreenNameLabel?.text = "\(tweet.user)"
    }
    
    private func setTweetImageView (tweet: Tweet) {
        if let profileImageURL = tweet.user.profileImageURL {
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                if let imageData = NSData(contentsOfURL: profileImageURL) {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tweetProfileImageView?.image = UIImage(data: imageData)
                    }
                }
                else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tweetProfileImageView?.image = nil
                    }
                }
            }
        }
    }
    
    private func setTwitterDate (tweet: Tweet)  {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
            formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        } else {
            formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        }
        tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
    }
    
}

private extension NSMutableAttributedString {
    func setKeywordsColor(keywords: [Tweet.IndexedKeyword], color: UIColor) {
        for keyword in keywords {
            addAttribute(NSForegroundColorAttributeName, value: color, range: keyword.nsrange)
        }
    }
}