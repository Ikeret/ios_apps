//
//  functions.swift
//  Checker
//
//  Created by Сергей Коршунов on 18/07/2019.
//  Copyright © 2019 Sergey Korshunov. All rights reserved.
//

import Foundation
import UIKit

func str2col(_ color: String?) -> UIColor? {
    if color == nil { return nil }
    
    switch color!.lowercased() {
    case "blue":
        return .blue
    case "red":
        return .red
    case "yellow":
        return .yellow
    case "green":
        return .green
    default:
        return nil
    }
}
