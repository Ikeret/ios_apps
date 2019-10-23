//
//  constants.swift
//  Mafia Roles
//
//  Created by Сергей Коршунов on 22.10.2019.
//

import Foundation

enum roles: String {
    case mafia = "Мафия"
    case sherif = "Комиссар"
    case medic = "Медсестра"
    case maniac = "Маньяк"
    case player = "Мирный житель"
}
var players = 5
var mafias = 1

var maniac = true
var medic = true
var sherif = true



let descriptions = [
    "Мафия" : "Ваша задача: убивать ночью мирных жителей.",
    "Мирный житель" : "Ваша задача: понять кто мафия и проголосовать за него днем.",
    "Комиссар" : "Ваша задача: проверять жителей ночью, чтобы выяснить, кто является мафией.",
    "Медсестра" : "Ваша задача: лечить людей, чтобы их не убила мафия или маньяк.",
    "Маньяк" : "Ваша задача: убить всех."
]
