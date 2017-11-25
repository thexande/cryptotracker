import RealmSwift
import Realm

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
            realmCrypto.percentChangeTwentyFourHour = Double(crypto.percentChangeTwentyFourHour) ?? 0
            realmCrypto.lastUpdated = crypto.lastUpdated
            realmCrypto.iconUrl = "https://files.coinmarketcap.com/static/img/coins/128x128/\(crypto.id).png"
            return realmCrypto
        }
        addRealmObjects(realmCryptos)
    }
}
