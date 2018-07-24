//
//  GalleryCollectionViewController.swift
//  ImageGalery
//
//  Created by apple on 18/07/2018.
//  Copyright © 2018 wolfpack. All rights reserved.
//

import UIKit

private let reuseIdentifier = "GalleryCollectionViewCell"


protocol galleryUpdateDelegate {
    func UppdateGalery(_ updatedGallery: ImageGallery)
}

class GalleryCollectionViewController: UICollectionViewController, UICollectionViewDropDelegate, UICollectionViewDelegateFlowLayout {
    
    var tableViewController: GaleryTableViewController?
    var delegate: galleryUpdateDelegate?
    var gallery: ImageGallery? = ImageGallery(images: [], title: "") {
        didSet {
            if gallery!.images.count > 0 {
                delegate?.UppdateGalery(gallery!)
            }
            collectionView?.reloadData()
        }
    }
    
    var maxWidth: CGFloat {
        return (self.view.frame.width - 2 * cellSpacing) / 3
    }
    var cellSpacing: CGFloat {
        return self.view.frame.width / 64
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.dropDelegate = self
        self.collectionView!.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if gallery!.images.count != 0 {
            return gallery!.images.count
        }else {
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GalleryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionViewCell", for: indexPath) as! GalleryCollectionViewCell
        if cell.url == nil {
            cell.url = gallery?.images[indexPath.row].imagePath
        }
        return cell
    }
    


    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: maxWidth, height: maxWidth * 3 / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        coordinator.session.loadObjects(ofClass: NSURL.self) { nsurls in
            if let url = nsurls.first as? URL {
                let imagea = ImageGallery.Image(imagePath: url, aspectRatio: 1)
                self.gallery?.images += [imagea]                
            }
        }
    }
    
//    func fetchImage(for index: Int) -> UIImage {
//        if let url = gallery?.images[index].imagePath {
//            imageFetcher = ImageFetcher() {(url, image) in
//                DispatchQueue.main.async {
//                }
//            }
//                return self.imageFetcher.fetch(url)
//            }
//
//
//    }
}

