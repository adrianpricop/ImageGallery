//
//  GaleryTableViewController.swift
//  ImageGalery
//
//  Created by apple on 18/07/2018.
//  Copyright © 2018 wolfpack. All rights reserved.
//

import UIKit

class GaleryTableViewController: UITableViewController, GalleryUpdateDelegate {
    
    var galleryNames = [String]()
    var activeGallerys = [ImageGallery]() {
        didSet{
            if activeGallerys.count == 0 {
                addGallery()
            }
            galleryNames.removeAll()
            for index in activeGallerys.indices {
                galleryNames.append(activeGallerys[index].title)
            }
        }
    }
    var recentlyDeletedGalery = [ImageGallery]()
    var gallerys: [[ImageGallery]] {
        return [activeGallerys, recentlyDeletedGalery]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView!.register(GalleryTableViewCell.self, forCellReuseIdentifier: "GaleryCell")
        if activeGallerys.count == 0 {
            addGallery()
        }
        self.performSegue(withIdentifier: "GalleryColletionView", sender: self)
    }
    
    @IBAction func addGallery(_ sender: UIBarButtonItem) {
        addGallery()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                let deletedGalery = activeGallerys.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                recentlyDeletedGalery.append(deletedGalery)
            }else {
                recentlyDeletedGalery.remove(at: indexPath.row)
            }
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 1 {
            let restore = UIContextualAction(style: .normal, title: "restore") { (action, view, completionHandler) in
                let restoreGallery = self.recentlyDeletedGalery.remove(at: indexPath.row)
                self.activeGallerys.append(restoreGallery)
                completionHandler(true)
                self.tableView.reloadData()
            }
            return UISwipeActionsConfiguration(actions: [restore])
        }else {
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.performSegue(withIdentifier: "GalleryColletionView", sender: self)
        }
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GalleryColletionView"{
            let indexpath = tableView.indexPathForSelectedRow
            let index = indexpath?.row ?? 0
            if let galleryControlerVC = segue.destination as? UINavigationController {
                if let galleryVC = galleryControlerVC.visibleViewController as? GalleryCollectionViewController {
                    galleryVC.gallery = activeGallerys[index]
                    galleryVC.delegate = self
                }
            }
        }
    }
    
    func UppdateGallery(_ updatedGallery: ImageGallery) {
        for index in activeGallerys.indices {
            if activeGallerys[index] == updatedGallery {
                activeGallerys[index] = updatedGallery
            }
        }
    }
    
    func addGallery() {
        let newGallery = ImageGallery(images: [], title: "new".madeUnique(withRespectTo: galleryNames))
        activeGallerys += [newGallery]
        tableView.reloadData()
    }
}

extension GaleryTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return gallerys.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gallerys[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Recently Deleted"
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GaleryCell", for: indexPath) as! GalleryTableViewCell
        
        cell.textLabel?.text = gallerys[indexPath.section][indexPath.row].title
        
        return cell
    }
}
