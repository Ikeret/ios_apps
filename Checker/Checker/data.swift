//
//  data.swift
//  Checker
//
//  Created by Сергей Коршунов on 18/07/2019.
//  Copyright © 2019 Sergey Korshunov. All rights reserved.
//

import Foundation
import UIKit

let Colors: [String] = ["Black", "Red", "Green", "Yellow", "Blue"]

struct List : Codable {
    var name: String = ""
    var category: String = ""
    var color: String = ""
}

var ListsArray: [List]
{
    set {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: "ListsArray")
        UserDefaults.standard.synchronize()
    }
    get {
        if let data = UserDefaults.standard.value(forKey: "ListsArray") as? Data  {
            let array = (try? PropertyListDecoder().decode(Array<List>.self, from: data))!
            return array
        } else {
            return []
        }
    }
}
