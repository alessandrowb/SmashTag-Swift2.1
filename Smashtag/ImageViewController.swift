//
//  ImageViewController.swift
//  Smashtag
//
//  Created by Alessandro on 10/21/15.
//  Copyright © 2015 Alessandro Belardinelli. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    var imageURL: NSURL? {
        didSet {
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    private func fetchImage() {
        if let url = imageURL {
            spinner?.startAnimating()
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                let imageData = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()) {
                    if url == self.imageURL {
                        if imageData != nil {
                            self.image = UIImage(data: imageData!)
                        } else {
                            self.image = nil
                        }
                    }
                }
            }
        }
    }
    
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 6.0
        }
    }
    
    @IBAction func tapAction(sender: UITapGestureRecognizer) {
        imageWasMoved = false
        setZoom()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        imageWasMoved = true
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        imageWasMoved = true
    }
    
    private var imageView = UIImageView()
    private var imageWasMoved = false
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
            spinner?.hidden = true
            imageWasMoved = false
            setZoom()
        }
    }
    
    private func setZoom() {
        if imageWasMoved {
            return
        }
        if let mysv = scrollView {
            if image != nil {
                mysv.zoomScale = max(mysv.bounds.size.height / image!.size.height,
                    mysv.bounds.size.width / image!.size.width)
                mysv.contentOffset = CGPoint(x: (imageView.frame.size.width - mysv.frame.size.width) / 2,
                    y: (imageView.frame.size.height - mysv.frame.size.height) / 2)
                imageWasMoved = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setZoom()
    }
}