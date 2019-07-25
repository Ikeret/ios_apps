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


// MARK: - ListsArray

struct ListItem : Codable {
    var title: String
    var category: String
    var color : String
    
    let id = UUID()
}

var ListsArray: [ListItem] = []

func loadLists() {
    if let data = DataManager.load("CheckerLists", with: Array<ListItem>.self) {
        ListsArray = data
    }
}

func saveLists() {
    DataManager.save(ListsArray, with: "CheckerLists")
}

// MARK: - TasksArray

var CurrentListID: UUID?
var CurrentListName: String?
var CurrentList: [TaskItem] = []

struct TaskItem: Codable {
    var name: String
    var checked: Bool = false
}

func loadTasks(ID: UUID) -> [TaskItem] {
    if let data = DataManager.load(ID.uuidString, with: Array<TaskItem>.self) {
        print("Loaded data: \(data)")
        return data
    } else {
        return []
    }
}

func saveTasks(ID: UUID, _ data: [TaskItem]) {
    print("Saved data: \(data)")
    DataManager.save(data, with: ID.uuidString)
}

// MARK: - UserSettings

struct UserSettings: Codable {
    var AutoSorting: Bool = true
    var RememberingWords: Bool = true
    var DarkMode: Bool = false
}

func loadSettings() {
    
}

func saveSettings() {
    
}

// MARK: - DailyTask

struct DailyTask: Codable{
    var name: String
    var time: Date
    var completed: Bool = false
}

// MARK: - Colors

let Colors: [String] = ["Red", "Green", "Blue", "Cyan"]
func str2col(_ color: String) -> UIColor? {
    
    switch color.lowercased() {
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

// MARK: - Other

func saveAllData() {
    saveLists()
    if CurrentListID != nil {
        saveTasks(ID: CurrentListID!, CurrentList)
    }
}

extension String {
    func strip() -> String {
        return self.trimmingCharacters(in: [" "])
    }
}
