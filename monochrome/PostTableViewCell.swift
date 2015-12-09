//
//  PostTableViewCell.swift
//  monochrome
//
//  Created by Siew Mai Chan on 09/12/2015.
//  Copyright © 2015 Siew Mai Chan. All rights reserved.
//

import UIKit
import AFDateHelper


class PostTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var creatorImageView: ProfileImageView!
    @IBOutlet weak var creatorNameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var pictureContainerView: UIView!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var numberOfPictureView: UIView!
    @IBOutlet weak var numberOfPictureLabel: UILabel!
    
    let creatorImagePlaceholder = UIImage(named: "person")!
    let picturePlaceholder = UIImage(named: "picture-placeholder")!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func drawRect(rect: CGRect) {
        numberOfPictureView.layer.cornerRadius = numberOfPictureView.frame.size.width / 2
    }
    
    func configure(post: Post) {
        creatorNameLabel.text = post.creator.displayName
        
        if let imageUrl = post.creator.imageUrl {
            let url = NSURL(string: imageUrl)!
            creatorImageView.af_setImageWithURL(url, placeholderImage: creatorImagePlaceholder, imageTransition: .CrossDissolve(0.2))
        }

        let date = NSDate(timeIntervalSince1970: post.timestamp / 1000)
        timestampLabel.text = date.toString(dateStyle: .MediumStyle, timeStyle: .ShortStyle, doesRelativeDateFormatting: true)
        
        if let status = post.status where status != "" {
            statusLabel.text = status
            statusLabel.hidden = false
        } else {
            statusLabel.hidden = true
        }
        
        numberOfPictureView.hidden = true
        pictureImageView.hidden = true
        if let pictures = post.pictures where pictures.count > 0 {
            pictureImageView.hidden = false
            let url = NSURL(string: pictures.values.first!)!
            pictureImageView.af_setImageWithURLRequest(NSURLRequest(URL: url), placeholderImage: self.picturePlaceholder, filter: nil, imageTransition: .CrossDissolve(0.2), completion: { response in
                if pictures.count > 1 {
                    self.numberOfPictureLabel.text = "\(pictures.count)"
                    self.numberOfPictureView.hidden = false
                }
            })
            
        }

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        creatorImageView.af_cancelImageRequest()
        creatorImageView.layer.removeAllAnimations()
        creatorImageView.image = nil
        
        pictureImageView.af_cancelImageRequest()
        pictureImageView.layer.removeAllAnimations()
        pictureImageView.image = nil
    }
}
