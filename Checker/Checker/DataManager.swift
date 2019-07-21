//
//  DataManager.swift
//  Checker
//
//  Created by Сергей Коршунов on 21/07/2019.
//  Copyright © 2019 Sergey Korshunov. All rights reserved.
//

import Foundation

public class DataManager {
    
    // Get Document Directory
    static fileprivate func getDocumentDirectory() -> URL {
        if let url = FileManager.default.urls(for:  .documentDirectory, in: .userDomainMask).first {
            return url
        } else {
            fatalError("Unable to get access to Document directory")
        }
    }
    
    // Save codable object
    static func save<T:Encodable>(_ object: T, with filename: String) {
        let path = getDocumentDirectory().appendingPathComponent(filename, isDirectory: false).path
        
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(object)
            if FileManager.default.fileExists(atPath: path) {
                try FileManager.default.removeItem(atPath: path)
            }
            FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    // Load codable object
    static func load<T:Decodable>(_ filename: String, with type: T.Type) -> T {
        let path = getDocumentDirectory().appendingPathComponent(filename, isDirectory: false).path
        
        if !FileManager.default.fileExists(atPath: path) {
            fatalError("File not found at path \(path)")
        }
        
        if let data = FileManager.default.contents(atPath: path) {
            do {
                let model = try JSONDecoder().decode(type, from: data)
                return model
            } catch {
                fatalError(error.localizedDescription)
            }
        } else {
            fatalError("Data is unavailable at path \(path)")
        }
    }
    
    // Load data from a file
    static func loadData(_ filename: String) -> Data? {
        let path = getDocumentDirectory().appendingPathComponent(filename, isDirectory: false).path
        
        if !FileManager.default.fileExists(atPath: path) {
            fatalError("File not found at path \(path)")
        }
        
        if let data = FileManager.default.contents(atPath: path) {
            return data
        } else {
            fatalError("Data is unavailable at path \(path)")
        }
    }
    
    // Delete a file
    static func delete(_ filename: String) {
        let path = getDocumentDirectory().appendingPathComponent(filename, isDirectory: false).path
        
        if FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.removeItem(atPath: path)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}
