//
//  FirstViewController.swift
//  InstaLook
//
//  Created by Сергей Коршунов on 30.10.2019.
//  Copyright © 2019 Сергей Коршунов. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    @IBOutlet weak var bodyCollectionView: UICollectionView!
    @IBOutlet weak var legsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bodyCollectionView.reloadData()
        legsCollectionView.reloadData()
        if topImages.isEmpty || bottomImages.isEmpty {
            showAlert(title: "InstaLook", message: NSLocalizedString("At least one top and one bottom clothes must be added.", comment: ""))
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }

}

extension FirstViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        switch collectionView {
        case bodyCollectionView:
            return topImages.count
        case legsCollectionView:
            return bottomImages.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: ImageCollectionViewCell!
        
        switch collectionView {
        case bodyCollectionView:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bodyCell", for: indexPath) as? ImageCollectionViewCell
   
            cell.imageView.image = topImages[indexPath.row]

        case legsCollectionView:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "legsCell", for: indexPath) as? ImageCollectionViewCell
            cell.imageView.image = bottomImages[indexPath.row]

            
        default:
            fatalError()
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.85, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.05, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.1, height: collectionView.frame.height)
    }
}
