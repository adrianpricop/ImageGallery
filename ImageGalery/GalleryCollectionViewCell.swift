//
//  GalleryCollectionViewCell.swift
//  ImageGalery
//
//  Created by apple on 20/07/2018.
//  Copyright © 2018 wolfpack. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    var backgroundImage: UIImage? {
        didSet {
            setNeedsDisplay()
        }
    }
    var url: URL? {
        didSet {
            fetchImage()
        }
    }
    var imageFetcher: ImageFetcher!
    
    
    func fetchImage() {
        imageFetcher = ImageFetcher() { (url, image) in
            DispatchQueue.main.async {
                self.backgroundImage = image
            }
        }
        imageFetcher.fetch(url!)
    
    }
    
    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in: bounds)
    }
}
