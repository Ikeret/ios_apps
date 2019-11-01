//
//  ParserOject.swift
//  CryptoSearch
//
//  Created by Сергей Коршунов on 31.10.2019.
//  Copyright © 2019 Сергей Коршунов. All rights reserved.
//

import UIKit
import SwiftyJSON

class ParserObject: NSObject {
    let coinName: String!
    let coinPriceUSD: Double!
    let coinId: String!
    let coinSymbol: String!
    let coinRank: Int!
    let coinWeeklyChange: Double!
      
    
    init(responseObject: JSON) {
        self.coinName = responseObject["name"].string
        self.coinPriceUSD = Double(responseObject["price_usd"].string!)
        self.coinId = responseObject["id"].string
        self.coinSymbol = responseObject["symbol"].string
        self.coinRank = Int(responseObject["rank"].string!)
        self.coinWeeklyChange = Double(responseObject["percent_change_7d"].string!)
    }
    
//    init(response: JSON, currency: String){
//        self.coinName = response["name"].string
//        self.coinPriceUSD = response["price_\(currency.lowercased())"].string
//        self.coinId = response["id"].string
//        self.coinSymbol = response["symbol"].string
//        self.coinRank = response["rank"].string
//        self.coinWeeklyChange = response["percent_change_7d"].string
//    }
  
}

class GlobalparserObject: NSObject {
    let total_market: String!
    let total_24h_volume: String!
    let bitcoin_percentage: String!
    let active_currencies: String!
    let active_assets: String!
    let active_markets: String!
    let last_updated: String!
  
  init(response: JSON, currency: String) {
    self.total_market = response["total_market_cap_\(currency.lowercased())"].string
    self.total_24h_volume = response["total_market_cap_\(currency.lowercased())"].string
    self.bitcoin_percentage = response["bitcoin_percentage_of_market_cap"].string
    self.active_currencies = response["active_currencies"].string
    self.active_assets = response["active_assets"].string
    self.active_markets = response["active_markets"].string
    self.last_updated = response["last_updated"].string
  }
  
}

