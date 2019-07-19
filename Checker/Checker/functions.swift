//
//  functions.swift
//  Checker
//
//  Created by Сергей Коршунов on 18/07/2019.
//  Copyright © 2019 Sergey Korshunov. All rights reserved.
//

import Foundation
import UIKit

let Colors: [String] = ["Red", "Green", "Blue", "Cyan"]
func str2col(_ color: String?) -> UIColor? {
    if color == nil { return nil }
    
    switch color!.lowercased() {
    case "blue":
        return .blue
    case "red":
        return .red
    case "cyan":
        return .cyan
    case "green":
        return .green
    default:
        return nil
    }
}

func getListForName(_ name: String) -> [Item] {
    if let data = UserDefaults.standard.value(forKey: name) as? Data  {
        let array = (try? PropertyListDecoder().decode(Array<Item>.self, from: data))!
        return array
    } else {
        return []
    }
}


func setListForName(_ list: [Item], _ name: String) {
    UserDefaults.standard.set(try? PropertyListEncoder().encode(list), forKey: name)
    UserDefaults.standard.synchronize()
}
