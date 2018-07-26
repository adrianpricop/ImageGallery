//
//  GalleryImage.swift
//  ImageGalery
//
//  Created by apple on 19/07/2018.
//  Copyright © 2018 wolfpack. All rights reserved.
//

import Foundation

struct ImageGallery: Hashable, Equatable {
    
    struct Image: Hashable {
        
        var hashValue: Int {
            return imagePath?.hashValue ?? 0
        }
        
        var imagePath: URL?
        
        init(imagePath: URL?) {
            self.imagePath = imagePath
        }
    }
    
    var hashValue: Int {
        return identifier.hashValue
    }
    
    static func == (lhs: ImageGallery, rhs: ImageGallery) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    let identifier: String = UUID().uuidString
    var images: [Image]
    var title: String
    
}
