//
//  PhotoCollectionViewCell.swift
//  Photorama
//
//  Created by VuTQ10 on 3/6/20.
//  Copyright © 2020 VuTQ10. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        update(with: nil)
    }
    override func prepareForReuse() {
        update(with: nil)
    }
    func update(with image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            spinner.isHidden = true
            imageView.image = imageToDisplay
        } else {
            spinner.startAnimating()
            imageView.image = nil
            spinner.isHidden = false
        }
    }
}
