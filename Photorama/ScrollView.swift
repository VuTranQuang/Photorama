//
//  ScrollView.swift
//  Photorama
//
//  Created by VuTQ10 on 3/10/20.
//  Copyright © 2020 VuTQ10. All rights reserved.
//

import UIKit

class ScrollView: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageController: UIPageControl!
    
   
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    var frontScrollViews = [UIScrollView]()
    var first = false
    var currentPage = 0
    let imgView = UIImageView()
    var photo: Photo!
    var photos = [UIImageView]()
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        pageController.currentPage = currentPage
        pageController.numberOfPages = photos.count
        
    }
    override func viewDidLayoutSubviews() {
        if !first {
            first =  true
            let pageScrollViewSize = scrollView.frame.size
            scrollView.contentSize = CGSize(width: pageScrollViewSize.width * CGFloat(photos.count), height: 0)
            scrollView.contentOffset = CGPoint(x: CGFloat(currentPage) * scrollView.frame.width, y: 0)
            
            store.fetchImage(for: photo) { result in
                switch result {
                case let .success(image):
                    self.imgView.image = image
                case let .failure(error):
                    print("Error fetching image for photo: \(error)")
                }
            }
            imgView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
            imgView.contentMode = .scaleAspectFill
            photos.append(imgView)
            for i in 0..<photos.count {
                let frontScrollView = UIScrollView(frame: CGRect(x: CGFloat(i) * scrollView.frame.size.width, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height))
                frontScrollView.delegate = self
                frontScrollView.minimumZoomScale = 0.5
                frontScrollView.maximumZoomScale = 2
                frontScrollView.isPagingEnabled = true
                frontScrollView.contentSize = imgView.bounds.size
                frontScrollView.addSubview(imgView)
                frontScrollViews.append(frontScrollView)
                
                self.scrollView.addSubview(frontScrollView)
                
            }
        }
    }
    
    @IBAction func onClickPageCtr(_ sender: UIPageControl) {
        scrollView.contentOffset = CGPoint(x: CGFloat(pageController.currentPage) * scrollView.frame.width, y: 0)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageController.currentPage = Int(scrollView.contentOffset.x/scrollView.frame.size.width)
    }
    
}
extension ScrollView: UIScrollViewDelegate, UIGestureRecognizerDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photos[pageController.currentPage]
    }
}
