//
//  ResultViewController.swift
//  Qreator
//
//  Created by Сергей Коршунов on 03.11.2019.
//  Copyright © 2019 Сергей Коршунов. All rights reserved.
//

import UIKit
import EFQRCode

class ResultViewController: UIViewController {
    
    var currentType: QRtype!
    var mainText: String!
    var secondaryText: String!
    
    var withBackgroundImage: Bool!
    var pickedImage: UIImage!

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        createQRCode()
    }
    
    @IBAction func shareButton(_ sender: Any) {
        let activityViewController = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    func createQRCode() {
        var content = ""
        switch currentType {
        case .url:
            content = "\(mainText ?? "")"
        case .contact:
            content = "tel:\(mainText ?? "")"
        case .text:
            content = "\(mainText ?? "")"
        case .sms:
            content = "SMSTO:\(mainText ?? ""):\(secondaryText ?? "")"
        case .none:
            fatalError()
        }
        
        if withBackgroundImage {
            if let tryImage = EFQRCode.generate(
                content: content,
                watermark: pickedImage.cgImage
            ) {
                imageView.image = UIImage(cgImage: tryImage)
            } else {
                print("Create QRCode image failed!")
            }
        } else {
            if let tryImage = EFQRCode.generate(
                content: content
                ) {
                imageView.image = UIImage(cgImage: tryImage)
            } else {
                print("Create QRCode image failed!")
            }
        }
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
