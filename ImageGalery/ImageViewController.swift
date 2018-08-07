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
    var imageView: UIImageView!

    @IBOutlet weak var imageScrollView: UIScrollView! {
        didSet {
            imageScrollView.minimumZoomScale = 0.1
            imageScrollView.maximumZoomScale = 5
            imageScrollView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let image = image else { return }
        let size = image.size
        imageView = UIImageView(image: image)
        imageScrollView.addSubview(imageView)
        imageScrollView.contentSize = size
    }
}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
