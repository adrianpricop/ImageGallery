//
//  GalleryCollectionViewController.swift
//  ImageGalery
//
//  Created by apple on 18/07/2018.
//  Copyright © 2018 wolfpack. All rights reserved.
//

import UIKit

private let reuseIdentifier = "GalleryCollectionViewCell"


protocol GalleryUpdateDelegate {
    func UppdateGallery(_ updatedGallery: ImageGallery)
}

class GalleryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var tableViewController: GaleryTableViewController?
    var delegate: GalleryUpdateDelegate?
    var gallery: ImageGallery!{
        didSet {
            if gallery.images.count >= 0 {
                delegate?.UppdateGallery(gallery)
            }
            if oldValue != nil && oldValue.images.count + 1 == gallery.images.count {
//                let index = IndexPath(row: gallery.images.count - 1, section: 0)
//                self.collectionView?.insertItems(at: [index])
            }
        }
    }
    
    var maxWidth: CGFloat {
        return (self.view.frame.width - 2 * cellSpacing) / 3
    }
    var cellSpacing: CGFloat {
        return 10
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.dragDelegate = self
        collectionView?.dropDelegate = self
        collectionView?.dragInteractionEnabled = true
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
        if gallery.images.count != 0 {
            return gallery.images.count
        }else {
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GalleryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionViewCell", for: indexPath) as! GalleryCollectionViewCell
        let url = gallery.images[indexPath.row].imagePath!
        cell.downloadImage(url: url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: maxWidth, height: maxWidth * 2 / 3)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }

}

extension GalleryCollectionViewController: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .move)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        var destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                collectionView.performBatchUpdates({
                    let imageData = gallery.images[sourceIndexPath.item]
                    gallery.images.remove(at: sourceIndexPath.item)
                    collectionView.deleteItems(at: [sourceIndexPath])
                    gallery.images.insert(imageData, at: destinationIndexPath.item)
                    collectionView.insertItems(at: [destinationIndexPath])
                })
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            } else {
                coordinator.session.loadObjects(ofClass: NSURL.self) { nsurls in
                    if let url = nsurls.first as? URL {
                        let imagea = ImageGallery.Image(imagePath: url)
                        self.gallery.images += [imagea]
                        let index = IndexPath(row: self.gallery.images.count - 1, section: 0)
                        self.collectionView?.insertItems(at: [index])
                    }
                }
            }
        }
    }
            
    
//    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
//        coordinator.session.loadObjects(ofClass: NSURL.self) { nsurls in
//            if let url = nsurls.first as? URL {
//                let imagea = ImageGallery.Image(imagePath: url)
//                self.gallery.images += [imagea]
//                let index = IndexPath(row: self.gallery.images.count - 1, section: 0)
//                self.collectionView?.insertItems(at: [index])
//            }
//        }
//    }
}

extension GalleryCollectionViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return getDragItems(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return getDragItems(at: indexPath)
    }
    
    private func getDragItems(at indexPath: IndexPath) -> [UIDragItem] {
        var dragItems = [UIDragItem]()
        if let imageUrl = gallery.images[indexPath.row].imagePath as NSURL? {
            let urlItem = UIDragItem(itemProvider: NSItemProvider(object: imageUrl))
            urlItem.localObject = imageUrl
            dragItems.append(urlItem)
        }
        return dragItems
    }
}

