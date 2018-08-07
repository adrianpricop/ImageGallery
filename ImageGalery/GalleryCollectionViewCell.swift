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
            actInd.stopAnimating()
            setNeedsDisplay()
        }
    }
    var url: URL? {
        didSet {
            downloadImage(url: url!)
            showActivityIndicatory(uiView: self)
        }
    }
    var imageFrame: CGRect!
    var imageFetcher: ImageFetcher!
    
    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in: bounds)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        showActivityIndicatory(uiView: self)
    }
    
    func downloadImage(url: URL) {
        imageFetcher = ImageFetcher() { (url, image) in
            DispatchQueue.main.async {
                if image.size.width > self.frame.width {
                    let ratio = self.frame.width / image.size.width
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
    
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func showActivityIndicatory(uiView: UIView) {
        actInd.frame.size = CGSize(width: 40, height: 40)
        actInd.center = self.center
        actInd.center = uiView.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        actInd.color = UIColor.blue
        self.addSubview(actInd)
        actInd.startAnimating()
    }    
}
