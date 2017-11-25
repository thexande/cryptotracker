import UIKit
import Anchorage
import Realm

class CryptoDetailViewController: UITableViewController {
    let crypto: RealmCryptoCurrency
    lazy var sections = self.createDetailCells(for: self.crypto)
    
    struct DetailSection {
        let title: String
        let cells: [UITableViewCell]
    }
    
    func createDetailCells(for crypto: RealmCryptoCurrency) ->  [DetailSection] {
        let name = CryptoDetailCell(title: "Name", detail: crypto.name)
        let symbol = CryptoDetailCell(title: "Symbol", detail: crypto.symbol)
        let rank = CryptoDetailCell(title: "Rank", detail: String(crypto.rank))
        let priceUsd = CryptoDetailCell(title: "USD Price", detail: "$\(crypto.dollarPrice)")
        let priceBtc = CryptoDetailCell(title: "Bitcoin Price", detail: "$\(crypto.bitcoinPrice)")
        let twentyFourHourVolume = CryptoDetailCell(title: "24 Hour USD Volume", detail: "$\(crypto.twentyFourHourVolumeUsd)")
        let marketCap = CryptoDetailCell(title: "USD Market Cap", detail: "$\(crypto.marketCapUsd)")
        let availableSupply = CryptoDetailCell(title: "Available Supply", detail: "\(crypto.availableSupply)")
        let totalSupply = CryptoDetailCell(title: "Total Supply", detail: "\(crypto.totalSupply)")
        let maxSupply = CryptoDetailCell(title: "Max Supply", detail: "\(crypto.maxSupply)")
        let percentChangeTwentyFour = CryptoDetailCell(title: "24 Hour Percentage Change", detail: "\(crypto.percentChangeTwentyFourHour)%")
        let percentChangeSevenDay = CryptoDetailCell(title: "7 Day Percentage Change", detail: "\(crypto.percentChangeSevenDays)%")
        let percentChangeOneHour = CryptoDetailCell(title: "1 Hour Percentage Change", detail: "\(crypto.percentChangeOneHour)%")
        let lastUpdated = CryptoDetailCell(title: "Last Updated", detail: "\(crypto.lastUpdated)")
        
        let infoSection = DetailSection(title: "Information", cells: [name, symbol, rank, lastUpdated])
        let priceSection = DetailSection(title: "Prices", cells: [priceUsd, priceBtc])
        let volumeSection = DetailSection(title: "Volume", cells: [twentyFourHourVolume, marketCap])
        let marketCapSection = DetailSection(title: "Supply", cells: [availableSupply, totalSupply, maxSupply])
        let percentageSection = DetailSection(title: "Percentage Movements", cells: [percentChangeOneHour, percentChangeTwentyFour, percentChangeSevenDay])
        
        return [infoSection, priceSection, percentageSection, volumeSection, marketCapSection]
    }
    
    init(_ crypto: RealmCryptoCurrency) {
        self.crypto = crypto
        super.init(nibName: nil, bundle: nil)
        title = crypto.symbol
        
        let titleImage = UIImageView()
        titleImage.heightAnchor == 40
        titleImage.widthAnchor == titleImage.heightAnchor
        
        tableView.tableFooterView = UIView()
        
        titleImage.sd_setImage(with: URL(string: crypto.iconUrl), completed: nil)
        
        navigationItem.titleView = titleImage
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        view.backgroundColor = StyleConstants.color.primaryGray
        view.addSubview(title)
        
        title.centerYAnchor == view.centerYAnchor
        title.leadingAnchor == view.leadingAnchor + 12
        
        title.text = sections[section].title
        return view
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.sections[indexPath.section].cells[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
