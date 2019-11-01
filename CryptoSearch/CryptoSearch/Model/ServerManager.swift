//
//  ServerManager.swift
//  CryptoSearch
//
//  Created by Сергей Коршунов on 31.10.2019.
//  Copyright © 2019 Сергей Коршунов. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ServerManager {
  static let shared = ServerManager()
  private  init() {}
  
  func tickerReguest (complition: @escaping ([ParserObject])-> Void){
    Alamofire.request("https://api.coinmarketcap.com/v1/ticker/").responseJSON { response in
      guard response.result.isSuccess, let value = response.result.value else { return }
      let json = JSON(value)
      let coins = json.arrayValue.map { json -> ParserObject in
        ParserObject(responseObject: json)
      }
      complition(coins)
    }
  }
  
//  func convertCurrency(coin:String, currency:String, comp: @escaping (ParserObject)->Void, fail: @escaping(Error)-> Void){
//    Alamofire.request("https://api.coinmarketcap.com/v1/ticker/\(coin.lowercased())/?convert=\(currency)").responseJSON { response in
//      if let json = response.result.value  {
//        let jsonObjects = JSON(json)
//        for item in jsonObjects  {
//          let  object = ParserObject(response: item.1, currency: currency)
//          comp(object)}
//        guard case let .failure(error) = response.result else {return}
//        fail(error)}
//    }
//  }
}
