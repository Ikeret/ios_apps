//
//  data.swift
//  Drink & Drive
//
//  Created by Сергей Коршунов on 14.11.2019.
//  Copyright © 2019 Сергей Коршунов. All rights reserved.
//

import UIKit

let pinkCGColor: CGColor = UIColor.systemPink.cgColor

struct drink {
    var name: String
    var amount: Int
    var persent: Double
}

let drinks = [
    drink(name: "Beer", amount: 50, persent: 7),
    drink(name: "Whine", amount: 50, persent: 15),
    drink(name: "Vodka", amount: 50, persent: 40),
    drink(name: "Absinthe", amount: 50, persent: 75),
    drink(name: "Custom", amount: 50, persent: 1)
]

let amounts = [
    50,
    100,
    200,
    300,
    400,
    500,
    600,
    700,
    800,
    900,
    1000
]

var weight: Double? {
    if UserDefaults.standard.bool(forKey: "definedWeight") {
        return UserDefaults.standard.double(forKey: "weight")
    } else {
        return nil
    }
}

var isFemale: Bool {
    return UserDefaults.standard.bool(forKey: "isFemale")
}

var isLbs: Bool {
    return UserDefaults.standard.bool(forKey: "isLbs")
}

func configureAlert(title: String?, message: String?) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(.init(title: "OK", style: .default, handler: nil))
    return alert
}

func lbsToKg(lbs: Double) -> Double {
    return lbs * 0.453592
}

func getTimeForDrink(degree: Double, volume: Double) -> Double {
    let wid_const = isFemale ? 0.6 : 0.7
    
    let pure_alc = (volume / 100) * degree
    let real_alc = pure_alc * 0.79 * 0.2
    
    let weightInKg = isLbs ? lbsToKg(lbs: weight!) : weight!
    let alc = real_alc / (weightInKg * wid_const)
    
    return alc / (2 / 3) * 60 * 60 * 10
}
