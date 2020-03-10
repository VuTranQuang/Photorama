//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by VuTQ10 on 3/9/20.
//  Copyright © 2020 VuTQ10. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    var store: PhotoStore!
    override func viewDidLoad() {
        super.viewDidLoad()
        store.fetchImage(for: photo) { result in
            switch result {
            case let .success(image):
                self.imageView.image = image
            case let .failure(error):
                print("Error fetching image for photo: \(error)")
            }
        }
    }
    
    
    
}
