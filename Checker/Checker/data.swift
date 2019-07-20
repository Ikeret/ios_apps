//
//  data.swift
//  Checker
//
//  Created by Сергей Коршунов on 18/07/2019.
//  Copyright © 2019 Sergey Korshunov. All rights reserved.
//

import Foundation
import UIKit

let SavedData = UserDefaults.standard

struct List : Codable {
    var name = String()
    var category = String()
    var color = String()
}

var ListsArray: [List]
{
    set {
        SavedData.set(try? PropertyListEncoder().encode(newValue), forKey: "ListsArray")
        SavedData.synchronize()
    }
    get {
        if let data = SavedData.value(forKey: "ListsArray") as? Data  {
            let array = (try? PropertyListDecoder().decode(Array<List>.self, from: data))!
            return array
        } else {
            return []
        }
    }
}

var CurrentListName: String?

struct Item : Codable {
    var name = String()
    var checked = false
}

var Tasks: [String]
{
    set {
        SavedData.set(newValue, forKey: "Tasks")
        SavedData.synchronize()
    }
    get {
        if let array = SavedData.stringArray(forKey: "Tasks") {
            return array
        } else {
            return []
        }
    }
}


var Settings: [String : Bool] {
    set {
        SavedData.set(newValue, forKey: "CheckerSettings")
        SavedData.synchronize()
    }
    get {
        if let array = SavedData.dictionary(forKey: "CheckerSettings") as? [String : Bool] {
            return array
        }
        let defaults = ["AutoSorting": true, "RememberingWords": true]
        //SavedData.set(defaults, forKey: "CheckerSettings")
        //SavedData.synchronize()
        return defaults
    }
}
