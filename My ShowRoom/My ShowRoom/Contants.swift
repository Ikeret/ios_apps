//
//  Contants.swift
//  My ShowRoom
//
//  Created by Сергей Коршунов on 02.11.2019.
//  Copyright © 2019 Сергей Коршунов. All rights reserved.
//

import Foundation
import UIKit

let categories = [
    "Верхняя одежда",
    "Нижняя одежда",
    "Головной убор",
    "Сумка",
    "Пояс",
    "Обувь",
    "Прочее"
]


var categoriesVisibilityIsChanged = false

func checkIsHidden(sender: UIControl) -> Bool {
    return UserDefaults.standard.bool(forKey: categories[sender.tag])
}


func loadAllImages(imageNames: [String]) -> [UIImage] {
    var images: [UIImage] = []
    for imageName in imageNames {
        if let image = loadImage(fileName: imageName) {
            images.append(image)
        }
    }
    return images
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
