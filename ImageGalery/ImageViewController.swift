//
//  ImageView.swift
//  ImageGalery
//
//  Created by apple on 27/07/2018.
//  Copyright © 2018 wolfpack. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    var image: UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var imageScrollView: UIScrollView! {
        didSet {
            imageScrollView.minimumZoomScale = 1/8
            imageScrollView.maximumZoomScale = 1
        }
    }
    
    override func viewDidLoad() {
        guard let image = image else { return }
        let size = image.size
        imageView.frame = CGRect(x: imageView.frame.origin.x,
                                 y: imageView.frame.origin.y,
                                 width: size.width,
                                 height: size.height)
        imageView.image = image
    }
}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
