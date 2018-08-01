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
    var gallery: ImageGallery?{
        didSet {
            guard let newGallery = gallery else {return}
            if newGallery.images.count >= 0 {
                delegate?.UppdateGallery(newGallery)
            }
        }
    }
    
    var navigatioBar: UINavigationBar!
    
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
        
        let trashButton = UIButton()
        trashButton.setImage(UIImage(named: "icon_trash"), for: .normal)
        trashButton.setTitle("Trash", for: .normal)
        trashButton.backgroundColor = UIColor.black
        let dropInteraction = UIDropInteraction(delegate: self)
        trashButton.addInteraction(dropInteraction)
        let barItem = UIBarButtonItem(customView: trashButton)
        navigationItem.rightBarButtonItem = barItem
        barItem.customView!.widthAnchor.constraint(equalToConstant: 32).isActive = true
        barItem.customView!.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let imageVc = segue.destination as? ImageViewController {
            let cell = sender as? GalleryCollectionViewCell
            if let image = cell?.backgroundImage{
                imageVc.image = image
            }
            
        }
        
//        if segue.identifier == "ImageView"{
//            let indexpath = collectionView?.indexPathsForSelectedItems
//            let cell = collectionView?.cellForItem(at: (indexpath?.first)!) as! GalleryCollectionViewCell
//            let image = cell.backgroundImage
//            let imageVc = segue.destination as! ImageViewController
//            imageVc.image = image
//        }
    }
    
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        if let cell = sender as? GalleryCollectionViewCell {
//            return cell.backgroundImage != nil
//        }
//        return false
//    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        performSegue(withIdentifier: "image", sender: cell)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard (gallery?.images.count) != nil else {
            return 0
        }
        return gallery!.images.count
//        if gallery?.images.count != 0 {
//            return gallery!.images.count
//        }else {
//            return 0
//        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GalleryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionViewCell", for: indexPath) as! GalleryCollectionViewCell
        let url = gallery?.images[indexPath.row].imagePath!
        cell.downloadImage(url: url!)
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
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if session.localDragSession != nil {
            if collectionView.hasActiveDrag {
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
            else {
                return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
            }
        }else {
            return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        var destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                collectionView.performBatchUpdates({
                    let imageData = gallery?.images[sourceIndexPath.item]
                    gallery?.images.remove(at: sourceIndexPath.item)
                    collectionView.deleteItems(at: [sourceIndexPath])
                    gallery?.images.insert(imageData!, at: destinationIndexPath.item)
                    collectionView.insertItems(at: [destinationIndexPath])
                })
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            } else {
                coordinator.session.loadObjects(ofClass: NSURL.self) { nsurls in
                    if let url = nsurls.first as? URL {
                        let imagea = ImageGallery.Image(imagePath: url)
                        self.gallery?.images += [imagea]
                        let index = IndexPath(row: (self.gallery?.images.count)! - 1, section: 0)
                        self.collectionView?.insertItems(at: [index])
                    }
                }
            }
        }
    }
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
        if let imageUrl = gallery?.images[indexPath.row].imagePath as NSURL? {
            let urlItem = UIDragItem(itemProvider: NSItemProvider(object: imageUrl))
            urlItem.localObject = imageUrl
            dragItems.append(urlItem)
        }
        return dragItems
    }
}

extension GalleryCollectionViewController: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: URL.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .move)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        guard let item = session.items.first else { return }
        guard let index = session.items.index(of: item) else { return }
        let indexPath = IndexPath(row: index, section: 0)
        gallery?.images.remove(at: index)
        collectionView?.deleteItems(at: [indexPath])
    }
}

