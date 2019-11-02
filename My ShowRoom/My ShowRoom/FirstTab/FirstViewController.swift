//
//  FirstViewController.swift
//  My ShowRoom
//
//  Created by Сергей Коршунов on 02.11.2019.
//  Copyright © 2019 Сергей Коршунов. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var leftStack: UIStackView!
    @IBOutlet weak var rightStack: UIStackView!
    
    @IBOutlet var buttonsOutletCollection: [UIButton]!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for button in buttonsOutletCollection {
            button.isHidden = checkIsHidden(sender: button)
            if categoriesVisibilityIsChanged {
                removeSubviews(view: button)
            }
        }
        categoriesVisibilityIsChanged = false
        
        checkStackViewSubviews(stackView: leftStack)
        checkStackViewSubviews(stackView: rightStack)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "ClothesVC", sender: sender.tag)
        
    }
    
    func checkStackViewSubviews(stackView: UIStackView) {
        if stackView.arrangedSubviews.allSatisfy({ return $0.isHidden}) {
            stackView.isHidden = true
        } else {
            stackView.isHidden = false
        }
    }
    
    func removeSubviews(view: UIView) {
        for subview in view.subviews {
            if subview.tag == 99 {
                subview.removeFromSuperview()
            }
        }
    }
    
    func setImageForButton(image: UIImage, tag: Int) {
        for button in buttonsOutletCollection {
            if button.tag == tag {
                removeSubviews(view: button)
                let imageView = UIImageView(frame: button.bounds)
                imageView.image = image
                imageView.contentMode = .scaleAspectFill
                imageView.layer.cornerRadius = 15
                imageView.clipsToBounds = true
                imageView.tag = 99
                button.addSubview(imageView)
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ClothesVC" {
            let destinationVC = segue.destination as! ClothesTableViewController
            destinationVC.tableView.allowsSelection = true
            let tag = sender as! Int
            destinationVC.navigationItem.title = categories[tag]
            destinationVC.tag = tag
            let dataNames = UserDefaults.standard.array(forKey: categories[tag]) as? [String] ?? []
            destinationVC.dataNames = dataNames
            destinationVC.data = loadAllImages(imageNames: dataNames)
        }
    }
    
    @IBAction func unwindToMainVC(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source as! ClothesTableViewController
        if let image = sourceViewController.selectedImage, let tag = sourceViewController.tag {
            setImageForButton(image: image, tag: tag)
        }
    }
}

