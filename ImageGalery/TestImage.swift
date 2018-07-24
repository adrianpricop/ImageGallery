//
//  TestImage.swift
//  ImageGalery
//
//  Created by apple on 20/07/2018.
//  Copyright © 2018 wolfpack. All rights reserved.
//

import UIKit

class TestImage: UIView {

    var backgroundImage: UIImage? { didSet { setNeedsDisplay() } }
    
    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in: bounds)
    }
 

}
