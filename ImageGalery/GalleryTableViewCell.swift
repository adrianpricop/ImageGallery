//
//  GalleryTableViewCell.swift
//  ImageGalery
//
//  Created by apple on 18/07/2018.
//  Copyright © 2018 wolfpack. All rights reserved.
//

import UIKit

protocol GalleryTableViewCellDelegate {
    func titleDidChange(_ title: String, in cell: UITableViewCell)
}

class GalleryTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.addTarget(self,
                                     action: #selector(titleDidChange(_:)),
                                     for: .editingDidEnd)
            textField.returnKeyType = .done
            textField.delegate = self
            
        }
    }
    
    
    
    
    
    
    @objc func titleDidChange(_ sender: UITextField) {
        guard let title = sender.text, title != "" else {
            return
            }
    }
}
