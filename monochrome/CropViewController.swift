//
//  CropViewController.swift
//  monochrome
//
//  Created by Siew Mai Chan on 07/12/2015.
//  Copyright © 2015 Siew Mai Chan. All rights reserved.
//

import UIKit

protocol CropViewControllerDelegate: class {
    func imageDidFinichCrop(image: UIImage)
}

class CropViewController: UIViewController, UIScrollViewDelegate {
    
    weak var delegate : CropViewControllerDelegate?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var centeringView: UIView!
    @IBOutlet weak var cropOverlay: CropOverlay!
    
    let imageView = UIImageView()
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image
        imageView.sizeToFit()
        
        scrollView.addSubview(imageView)
        scrollView.delegate = self
        scrollView.maximumZoomScale = 1
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let scale = calculateMinimumScale(view.frame.size)
        let frame = cropOverlay.frame
        
        scrollView.contentInset = calculateScrollViewInsets(frame)
        scrollView.minimumZoomScale = scale
        scrollView.zoomScale = scale
        centerScrollViewContents()
        centerImageViewOnScroll()

    }
    
    private func calculateMinimumScale(size: CGSize) -> CGFloat {
        let size = cropOverlay.frame.size
        let scaleWidth = size.width / image!.size.width
        let scaleHeight = size.height / image!.size.height
        let scale = fmax(scaleWidth, scaleHeight)
        
        return scale
    }
    
    private func calculateScrollViewInsets(frame: CGRect) -> UIEdgeInsets {
        let size = view.frame.size
        let bottom = size.height - (frame.origin.y + frame.size.height)
        let right = size.width - (frame.origin.x + frame.size.width)
        let insets = UIEdgeInsetsMake(frame.origin.y, frame.origin.x, bottom, right)
        
        return insets
    }
    
    private func centerScrollViewContents() {
        let size = cropOverlay.frame.size
        let imageSize = imageView.frame.size
        var imageOrigin = CGPointZero
        if imageSize.width < size.width {
            imageOrigin.x = (size.width - imageSize.width) / 2
        }
        
        if imageSize.height < size.height {
            imageOrigin.y = (size.height - imageSize.height) / 2
        }
        
        imageView.frame.origin = imageOrigin
    }
    
    private func centerImageViewOnScroll() {
        let size = cropOverlay.frame.size
        let scrollInsets = scrollView.contentInset
        let imageSize = imageView.frame.size
        var contentOffset = CGPointMake(-scrollInsets.left, -scrollInsets.top)
        contentOffset.x -= (size.width - imageSize.width) / 2
        contentOffset.y -= (size.height - imageSize.height) / 2
        scrollView.contentOffset = contentOffset
    }

    
    internal func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    internal func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContents()
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func crop(sender: AnyObject) {
        var cropFrame = cropOverlay.frame
        cropFrame.origin.x += scrollView.contentOffset.x
        cropFrame.origin.y += scrollView.contentOffset.y
        
        let croppedImage = image.crop(cropFrame, scale: scrollView.zoomScale)
        self.delegate?.imageDidFinichCrop(croppedImage)
        
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
}
