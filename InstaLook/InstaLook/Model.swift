//
//  Model.swift
//  InstaLook
//
//  Created by Сергей Коршунов on 30.10.2019.
//  Copyright © 2019 Сергей Коршунов. All rights reserved.
//

import Foundation
import UIKit

//var topImages =  [#imageLiteral(resourceName: "body-3"),#imageLiteral(resourceName: "body-1"), #imageLiteral(resourceName: "body-2")]
//var bottomImages =  [#imageLiteral(resourceName: "jeans-1"),#imageLiteral(resourceName: "jeans-3"), #imageLiteral(resourceName: "jeans-1")]

var topImages: [UIImage] = []
var bottomImages: [UIImage] = []

var topImagesNames: [String] = []
{
    didSet {
        UserDefaults.standard.set(topImagesNames, forKey: "topImages")
    }
}

var bottomImagesNames: [String] = []
{
    didSet {
        UserDefaults.standard.set(bottomImagesNames, forKey: "bottomImages")
    }
}

func loadAllImages() {
    if let names = UserDefaults.standard.array(forKey: "topImages") as? [String] {
        topImagesNames = names
        for name in names {
            topImages.append(loadImage(fileName: name)!)
        }
    }
    
    if let names = UserDefaults.standard.array(forKey: "bottomImages") as? [String] {
        bottomImagesNames = names
        for name in names {
            bottomImages.append(loadImage(fileName: name)!)
        }
    }
}

var documentsUrl: URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
}

func saveImage(image: UIImage) -> String? {
    let fileName = "\(UUID().uuidString).png"
    UserDefaults.standard.set(image.imageOrientation.rawValue, forKey: fileName)
    let fileURL = documentsUrl.appendingPathComponent(fileName)
    if let imageData = image.pngData() {
       try? imageData.write(to: fileURL)
       return fileName // ----> Save fileName
    }
    print("Error saving image")
    return nil
}

func loadImage(fileName: String) -> UIImage? {
    let fileURL = documentsUrl.appendingPathComponent(fileName)
    if let image = UIImage(contentsOfFile: fileURL.path) {
        
        let orientation = UserDefaults.standard.integer(forKey: fileName)
        return UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: UIImage.Orientation(rawValue: orientation)!)
        
    } else {
        return nil
    }
    
}

func deleteImage(fileName: String) {
    let fileURL = documentsUrl.appendingPathComponent(fileName)
    UserDefaults.standard.removeObject(forKey: fileName)
    let fileManager = FileManager()
    do {
        try fileManager.removeItem(at: fileURL)
    } catch {
        print("Error deleting image : \(error.localizedDescription)")
    }
}
