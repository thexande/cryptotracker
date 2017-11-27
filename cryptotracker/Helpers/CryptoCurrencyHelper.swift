import Foundation
import PromiseKit

struct UrlConstants {
    static let coinMarketCapTickerUrl: URL = URL(string: "https://api.coinmarketcap.com/v1/ticker/")!
    static let globalInfoUrl: URL = URL(string: "https://api.coinmarketcap.com/v1/global/")!
}

struct CryptoDescription {
    let symbol: String
    let cryptoDescription: String
}

class CryptoCurrencyHelper {
    static func fetchMarketInformation(url: URL, _ completion: @escaping(CryptoWorldInformation) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            let string1 = String(data: data, encoding: String.Encoding.utf8) ?? "Data could not be printed"
            print(string1)

            do {
                let marketInfo = try JSONDecoder().decode(CryptoWorldInformation.self, from: data)
                completion(marketInfo)
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
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
//    static func fetchCryptos(url: URL, _ completion: @escaping([CryptoCurrencyDescription]) -> Void) {
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard let data = data else { return }
//            do {
//                let cryptos = try JSONDecoder().decode([CryptoCurrency].self, from: data)
//
//                let descriptionPromises: [Promise<CryptoDescription>] = cryptos.map { crypto -> Promise<CryptoDescription> in
//                    return fetchDescription(for: crypto.symbol)
//                }
//
//                _ = PromiseKit.when(fulfilled: descriptionPromises).then { descriptions -> Void in
//                    let desc = Array(descriptions)
//                    let currencyDescriptions: [CryptoCurrencyDescription] = desc.map { description in
//                        guard let crypto = cryptos.filter({ $0.symbol == description.symbol }).first else { return}
//                        let cryptoDescription = CryptoCurrencyDescription(crypto: crypto, description: description.cryptoDescription)
//                    }
//
//                    completion(currencyDescriptions)
//                }
//
//            } catch let error {
//                print(error.localizedDescription)
//            }
//        }.resume()
//    }
    
    static func fetchDescription(for ticker: String) -> Promise<CryptoDescription> {
        return Promise { resolve, reject in
            let url = URL(string: "https://krausefx.github.io/crypto-summaries/coins/\(ticker)-5.txt")!
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, let string = String(data: data, encoding: String.Encoding.utf8) else {
                    return
                }
                resolve(CryptoDescription(symbol: ticker, cryptoDescription: string))
                }.resume()
        }
    }
}
