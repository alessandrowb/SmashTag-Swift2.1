//
//  ContentTableViewCell.swift
//  Smashtag
//
//  Created by Alessandro on 10/18/15.
//  Copyright © 2015 Alessandro Belardinelli. All rights reserved.
//

import UIKit

class ContentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var refresher: UIActivityIndicatorView!
    @IBOutlet weak var contentImage: UIImageView!
    
    var imageUrl: NSURL? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        contentImage?.image = nil
        if let url = imageUrl {
            refresher?.startAnimating()
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                let imageData = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()) {
                    if url == self.imageUrl {
                        if imageData != nil {
                            self.contentImage?.image = UIImage(data: imageData!)
                        } else {
                            self.contentImage?.image = nil
                        }
                        self.refresher?.stopAnimating()
                        self.refresher?.hidden = true
                    }
                }
            }
        }
    }
}