//
//  file.swift
//  Numbers
//
//  Created by Сергей Коршунов on 23.10.2019.
//  Copyright © 2019 Sergey Korshunov. All rights reserved.
//

import Foundation
import UIKit

var launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")

func colorForIndex(index: Int) -> CGColor {
    let num = index % 6
    switch num {
    case 0:
        return UIColor.systemRed.cgColor
    case 1:
        return UIColor.systemGreen.cgColor
    case 2:
        return UIColor.systemBlue.cgColor
    case 3:
        return UIColor.systemPink.cgColor
    case 4:
        return UIColor.systemOrange.cgColor
    case 5:
        return UIColor.systemYellow.cgColor
    default:
        return UIColor.white.cgColor
    }
}

var wheelStrings = ["Slice #1", "Slice #2", "Slice #3", "Slice #4", "Slice #5", "Slice #6"]
