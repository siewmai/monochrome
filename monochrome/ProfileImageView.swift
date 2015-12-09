//
//  ProfileImageView.swift
//  monochrome
//
//  Created by Siew Mai Chan on 07/12/2015.
//  Copyright © 2015 Siew Mai Chan. All rights reserved.
//

import UIKit

class ProfileImageView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = frame.size.width / 2
        clipsToBounds = true
    }
}
