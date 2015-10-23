//
//  HistoryTableViewController.swift
//  Smashtag
//
//  Created by Alessandro on 10/22/15.
//  Copyright © 2015 Alessandro Belardinelli. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
        
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        tableView.reloadData()
    }
    
    private struct StoryBoard {
        static let cellReuseIdentifier = "HistoryCell"
        static let searchSegueIdentifier = "showRecentSearch"
        static let label = "History"
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchHistory().searches.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.cellReuseIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = SearchHistory().searches[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return StoryBoard.label
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            SearchHistory().removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }


    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case StoryBoard.searchSegueIdentifier:
                if let ttvc = segue.destinationViewController as? TweetTableViewController {
                    if let searchCell = sender as? UITableViewCell {
                        ttvc.searchText = searchCell.textLabel?.text
                    }
                }
            default:
                break
            }
        }
    }
    
}