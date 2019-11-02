//
//  ClothesTableViewController.swift
//  My ShowRoom
//
//  Created by Сергей Коршунов on 02.11.2019.
//  Copyright © 2019 Сергей Коршунов. All rights reserved.
//

import UIKit
import SPAlert

class ClothesTableViewController: UITableViewController {
    
    var tag: Int!
    var data: [UIImage]!
    
    var selectedImage: UIImage!
    
    var dataNames: [String]! {
        didSet {
            UserDefaults.standard.set(dataNames, forKey: categories[tag])
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            tableView.reloadData()
    }
        
    @IBAction func addAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "My ShowRoom", message: nil, preferredStyle: .actionSheet)
        alert.addAction(.init(title: "Camera", style: .default, handler: { (action) in
            #if !targetEnvironment(simulator)
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.videoQuality = .typeMedium
            self.present(imagePicker, animated: true)
            #endif
        }))
        alert.addAction(.init(title: "Photo Library", style: .default, handler: { (action) in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.videoQuality = .typeMedium

            self.present(imagePicker, animated: true)
        }))
        alert.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! ClothesTableViewCell
        cell.photoView.image = data[indexPath.row]
        cell.photoView.layer.cornerRadius = 15
        cell.photoView.clipsToBounds = true
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteImage(fileName: dataNames[indexPath.row])
            SPAlert.present(title: "Deleted", preset: .done)
            dataNames.remove(at: indexPath.row)
                
                
            data.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedImage = data[indexPath.row]
        performSegue(withIdentifier: "unwind1", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentImage = data[indexPath.row]
        return tableView.frame.width / (currentImage.size.width / currentImage.size.height)
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ClothesTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        DispatchQueue.main.async {
            self.dataNames.append(saveImage(image: selectedImage)!)
        }
        data.append(selectedImage)
        if picker.sourceType == .camera {
            picker.dismiss(animated: true, completion: nil)
        }
        SPAlert.present(title: NSLocalizedString("Added", comment: ""), preset: .done)
        tableView.reloadData()
    }

}

