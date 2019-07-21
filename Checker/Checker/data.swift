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

var ListsArray: [ListItem]
{
    set {
        DataManager.save(newValue, with: "CheckerLists")
    }
    get {
        if let data = DataManager.load("CheckerLists", with: Array<ListItem>.self) {
            return data
        }
        return []
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



struct ListItem : Codable {
    var title: String
    var category: String
    var color : String
    
    let id = UUID()
}

struct TaskItem: Codable {
    var name: String
    var completed: Bool = false
}

struct UserSettings: Codable {
    var AutoSorting: Bool = true
    var RememberingWords: Bool = true
    var DarkMode: Bool = false
}

struct DailyTask: Codable{
    var name: String
    var time: Date
    var completed: Bool = false
}
