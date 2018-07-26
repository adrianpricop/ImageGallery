//
//  GalleryCollectionViewCell.swift
//  ImageGalery
//
//  Created by apple on 20/07/2018.
//  Copyright © 2018 wolfpack. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {

    
//    var url: URL! {
//        didSet {
//            imageView.load(url: url)
//        }
//
    var backgroundImage: UIImage? {
        didSet {
            setNeedsDisplay()
        }
    }
    var imageFrame: CGRect!
    
    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in: bounds)
    }
    
    var imageFetcher: ImageFetcher!
    func downloadImage(url: URL) {
        imageFetcher = ImageFetcher() { (url, image) in
            DispatchQueue.main.async {
//                let imageView = UIImageView(frame: self.frame)
//                if image.size.width > self.frame.width {
//                    imageView.contentMode = UIViewContentMode.scaleAspectFit
//                }else {
//                    imageView.contentMode = UIViewContentMode.center
//                }
//                imageView.image = image
//                self.addSubview(imageView)
                if image.size.width > self.frame.width {
                    let ratio = self.frame.width / image.size.width
                    print()
                    self.bounds = CGRect(x: self.frame.origin.x,
                                             y: self.frame.origin.y + (self.frame.height - (image.size.height * ratio)) / 2,
                                             width: image.size.width * ratio,
                                             height: image.size.height * ratio)
                }else {
                    self.bounds = self.frame
                }
                self.backgroundImage = image
            }
        }
        imageFetcher.fetch(url)
    }
}
