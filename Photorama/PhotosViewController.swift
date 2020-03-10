//
//  PhotosViewController.swift
//  Photorama
//
//  Created by VuTQ10 on 3/5/20.
//  Copyright © 2020 VuTQ10. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate {
    @IBOutlet var collectionView: UICollectionView!
    
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCollectionViewCell")
        
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        updateDataSource()
        store.fetchInterestingPhotos { photosResult -> Void in
           self.updateDataSource()
        }
    }
    private func updateDataSource() {
        store.fetchAllPhotos { photosResult in
            switch photosResult {
            case let .success(photos):
                self.photoDataSource.photos = photos
            case .failure:
                self.photoDataSource.photos.removeAll()
            }
            self.collectionView.reloadSections(IndexSet(integer: 0))
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photo = photoDataSource.photos[indexPath.row]
        
        // Download the image data, which could take some time
        store.fetchImage(for: photo) { result in
            guard let photoIndex = self.photoDataSource.photos.index(of: photo),
                case let .success(image) = result else {
                return
            }
            let photoIndexPath = IndexPath(item: photoIndex, section: 0)
            
            if let cell = self.collectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell {
                cell.update(with: image)
            }
        }
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoInfoViewController") as! PhotoInfoViewController
        let photo = photoDataSource.photos[indexPath.row]
        destinationVC.photo = photo
        destinationVC.store = store


        navigationController?.pushViewController(destinationVC, animated: true)
//        pushView(index: indexPath.item)
    }
    
    func pushView(index: Int) {
        let listView = self.storyboard?.instantiateViewController(withIdentifier: "ScrollView") as! ScrollView
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
        let photo = photoDataSource.photos[indexPath.row]
    
        listView.currentPage = index
        listView.photo = photo
        listView.store = store
        navigationController?.pushViewController(listView, animated: true)
    }
    
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 5, height: (collectionView.frame.height) / 4 )
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
