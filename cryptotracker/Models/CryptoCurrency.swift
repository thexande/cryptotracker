//
//  CryptoCurrency.swift
//  cryptotracker
//
//  Created by Alexander Murphy on 11/24/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

struct UrlConstants {
    static let coinMarketCapTickerUrl: URL = URL(string: "https://api.coinmarketcap.com/v1/ticker/")!
}

class CryptoCurrencyHelper {
    static func fetchCryptos(url: URL, _ completion: @escaping([CryptoCurrency]) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let cryptos = try JSONDecoder().decode([CryptoCurrency].self, from: data)
                completion(cryptos)
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

class RealmCrudHelper {
    static func addRealmObjects(_ objects: [Object]) {
        do {
            let realm = try Realm()
            for object in objects {
                do {
                    try realm.write {
                        realm.add(object, update: true)
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    static func writeCryptos(_ cryptos: [CryptoCurrency]) {
        let realmCryptos: [RealmCryptoCurrency] = cryptos.map { crypto in
            let realmCrypto = RealmCryptoCurrency()
            realmCrypto.id = crypto.id
            realmCrypto.name = crypto.name
            realmCrypto.symbol = crypto.symbol
            realmCrypto.rank = Int(crypto.rank) ?? 0
            realmCrypto.dollarPrice = Double(crypto.priceUsd) ?? 0
            realmCrypto.bitcoinPrice = Double(crypto.priceBtc) ?? 0
            realmCrypto.twentyFourHourVolumeUsd = Double(crypto.twentyFourHourVolumeUsd) ?? 0
            realmCrypto.marketCapUsd = Double(crypto.marketCapUsd) ?? 0
            realmCrypto.availableSupply = Double(crypto.availableSupply) ?? 0
            realmCrypto.totalSupply = Double(crypto.totalSupply) ?? 0
            realmCrypto.maxSupply = Double(crypto.maxSupply ?? "") ?? 0
            realmCrypto.percentChangeOneHour = Double(crypto.percentChangeOneHour) ?? 0
            realmCrypto.percentChangeSevenDays = Double(crypto.percentChangeSevenDays ?? "") ?? 0
            realmCrypto.lastUpdated = crypto.lastUpdated
            realmCrypto.iconUrl = "https://files.coinmarketcap.com/static/img/coins/128x128/\(crypto.id).png"
            return realmCrypto
        }
        addRealmObjects(realmCryptos)
    }
}

class RealmCryptoCurrency: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var symbol = ""
    @objc dynamic var rank = 0
    @objc dynamic var dollarPrice = 0.0
    @objc dynamic var bitcoinPrice = 0.0
    @objc dynamic var twentyFourHourVolumeUsd = 0.0
    @objc dynamic var marketCapUsd = 0.0
    @objc dynamic var availableSupply = 0.0
    @objc dynamic var totalSupply = 0.0
    @objc dynamic var maxSupply = 0.0
    @objc dynamic var percentChangeOneHour = 0.0
    @objc dynamic var percentChangeTwentyFourHour = 0.0
    @objc dynamic var percentChangeSevenDays = 0.0
    @objc dynamic var lastUpdated = ""
    @objc dynamic var iconUrl = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

struct CryptoCurrency: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case rank
        case priceUsd = "price_usd"
        case priceBtc = "price_btc"
        case twentyFourHourVolumeUsd = "24h_volume_usd"
        case marketCapUsd = "market_cap_usd"
        case availableSupply = "available_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case percentChangeOneHour = "percent_change_1h"
        case percentChangeTwentyFourHour = "percent_change_24h"
        case percentChangeSevenDays = "percent_change_7d"
        case lastUpdated = "last_updated"
    }
    
    let id: String
    let name: String
    let symbol: String
    let rank: String
    let priceUsd: String
    let priceBtc: String
    let twentyFourHourVolumeUsd: String
    let marketCapUsd: String
    let availableSupply: String
    let totalSupply: String
    let maxSupply: String?
    let percentChangeOneHour: String
    let percentChangeTwentyFourHour: String
    let percentChangeSevenDays: String?
    let lastUpdated: String
}
