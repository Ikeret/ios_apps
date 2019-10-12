//
//  ResultPageViewController.swift
//  devIstanbul
//
//  Created by Сергей Коршунов on 11.10.2019.
//  Copyright © 2019 SelimSelcuk. All rights reserved.
//

import UIKit

class ResultPageViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backButtonOutlet: UIButton!
    var resultMessage = String()
    var uploadedImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        resultLabel.text = resultMessage
        imageView.image = uploadedImage
        
        backButtonOutlet.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
