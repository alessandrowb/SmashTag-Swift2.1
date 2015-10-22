//
//  ContentTableViewController.swift
//  Smashtag
//
//  Created by Alessandro on 10/18/15.
//  Copyright © 2015 Alessandro Belardinelli. All rights reserved.
//

import UIKit

class ContentTableViewController: UITableViewController {
    
    var tweet :Tweet? {
        didSet {
            if tweet != nil {
                if tweet!.media.count > 0 {
                    var subContent: [String] = []
                    var aspectRatios: [Double] = []
                    for media in tweet!.media {
                        subContent.append("\(media.url)")
                        aspectRatios.append(media.aspectRatio)
                    }
                    contents.append(Contents (title: "Images", data:subContent, imageRatio: aspectRatios))
                }
                if tweet!.hashtags.count > 0 {
                    var subContent: [String] = []
                    let aspectRatios: [Double] = []
                    for hashtag in tweet!.hashtags {
                        subContent.append(hashtag.keyword)
                    }
                    contents.append(Contents (title: "Hashtags", data:subContent, imageRatio: aspectRatios))
                }
                if tweet!.userMentions.count > 0 {
                    var subContent: [String] = []
                    let aspectRatios: [Double] = []
                    for userMention in tweet!.userMentions {
                        subContent.append(userMention.keyword)
                    }
                    contents.append(Contents (title: "User Mentions", data:subContent, imageRatio: aspectRatios))
                }
                if tweet!.urls.count > 0 {
                    var subContent: [String] = []
                    let aspectRatios: [Double] = []
                    for url in tweet!.urls {
                        subContent.append(url.keyword)
                    }
                    contents.append(Contents (title: "Links", data:subContent, imageRatio: aspectRatios))
                }
            }
        }
    }
    
    private var contents: [Contents] = []
    
    private struct Contents {
        var title: String
        var data: [String]
        var imageRatio: [Double]
    }
    
    // MARK: - UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let sections = contents.count
        return sections
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents[section].data.count
    }
    
    private struct Storyboard {
        static let ImageCellReuseIdentifier = "ImageContent"
        static let KeywordCellReuseIdentifier = "KeywordContent"
        static let ImageCellSegueIdentifier = "showFullImage"
        static let KeyworkCellSegueIdentifier = "performSearch"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var thisTextColor = UIColor.blackColor()
        switch contents[indexPath.section].title {
        case "Hashtags":
            thisTextColor = TweetTextColors.hashtagColor
        case "User Mentions":
            thisTextColor = TweetTextColors.userColor
        case "Links":
            thisTextColor = TweetTextColors.urlColor
        default:
            break
        }
        
        if contents[indexPath.section].title == "Images" {
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ImageCellReuseIdentifier, forIndexPath: indexPath) as! ContentTableViewCell
            let fileUrl = NSURL(string: contents[indexPath.section].data[indexPath.row])
            cell.imageUrl = fileUrl
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.KeywordCellReuseIdentifier, forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = contents[indexPath.section].data[indexPath.row]
            cell.textLabel?.textColor = thisTextColor
            
            return cell
        }
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contents[section].title
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if contents[indexPath.section].title == "Images" {
            return tableView.bounds.size.width / CGFloat(contents[indexPath.section].imageRatio[indexPath.row])
        }
        else {
            return UITableViewAutomaticDimension
        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Storyboard.KeyworkCellSegueIdentifier:
                if let ttvc = segue.destinationViewController as? TweetTableViewController {
                    if let tweetCell = sender as? UITableViewCell {
                        ttvc.searchText = tweetCell.textLabel?.text
                    }
                }
            case Storyboard.ImageCellSegueIdentifier:
                if let ivc = segue.destinationViewController as? ImageViewController {
                    if let tweetCell = sender as? ContentTableViewCell {
                        ivc.imageURL = tweetCell.imageUrl
                    }
                }
            default:
                break
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == Storyboard.KeyworkCellSegueIdentifier {
            if let cell = sender as? UITableViewCell {
                if let url = cell.textLabel?.text {
                    if url.hasPrefix("http") {
                        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
                        return false
                    }
                }
            }
        }
        return true
    }
    
}