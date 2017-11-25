//
//  MarketViewController.swift
//  cryptotracker
//
//  Created by Alexander Murphy on 11/24/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import Foundation
import UIKit
import Anchorage
import SDWebImage
import Realm
import RealmSwift

class PillView: UIView {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        backgroundColor = StyleConstants.color.purple
        addSubview(label)
        label.text = "0"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        label.topAnchor == topAnchor + 4
        label.bottomAnchor == bottomAnchor - 4
        label.leadingAnchor == leadingAnchor + 4
        label.trailingAnchor == trailingAnchor - 4
        layer.masksToBounds = true
        layer.cornerRadius = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MarketCell: UITableViewCell {
    let logoImageView = UIImageView()
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    let percentageChangeLabel = UILabel()
    lazy var logoContainer = UIStackView(arrangedSubviews: [self.titleLabel, self.subTitleLabel])
    let rankView = PillView()
    
    lazy var rankContainer: UIView = {
        let view = UIView()
        view.addSubview(rankView)
        return view
    }()
    
    func setCrypto(_ crypto: RealmCryptoCurrency) {
        guard let url = URL(string: crypto.iconUrl) else { return }
        logoImageView.sd_setImage(with: url, completed: nil)
        titleLabel.text = crypto.symbol
        subTitleLabel.text = crypto.name
        percentageChangeLabel.text = "\(String(crypto.percentChangeTwentyFourHour))%"
        percentageChangeLabel.textColor = (crypto.percentChangeTwentyFourHour > 0 ? StyleConstants.color.emerald : StyleConstants.color.primaryRed)
        rankView.label.text = String(crypto.rank)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views: [UIView] = [logoImageView, logoContainer, percentageChangeLabel, rankContainer]
        views.forEach { view in
            addSubview(view)
        }
        
        rankView.centerYAnchor == centerYAnchor
        rankContainer.leadingAnchor == leadingAnchor + 12
        rankContainer.widthAnchor == 36
        rankContainer.verticalAnchors == verticalAnchors
    
        rankView.centerAnchors == rankContainer.centerAnchors
        
        percentageChangeLabel.trailingAnchor == trailingAnchor - 12
        percentageChangeLabel.centerYAnchor == centerYAnchor
        
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .ultraLight)
        subTitleLabel.font = UIFont.systemFont(ofSize: 10, weight: .light)
        percentageChangeLabel.font = UIFont.systemFont(ofSize: 16, weight: .ultraLight)
        
        logoContainer.axis = .vertical
        logoContainer.leadingAnchor == logoImageView.trailingAnchor + 12
        logoContainer.centerYAnchor == centerYAnchor
        
        
        logoImageView.heightAnchor == 40
        logoImageView.widthAnchor == logoImageView.heightAnchor
        logoImageView.centerYAnchor == centerYAnchor
        logoImageView.leadingAnchor == rankContainer.trailingAnchor + 12
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MarketViewController: UIViewController {
    lazy var cryptos: [RealmCryptoCurrency]? = {
        do {
            let realm = try Realm()
            return Array(realm.objects(RealmCryptoCurrency.self))
            
        } catch _ { return nil }
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(MarketCell.self, forCellReuseIdentifier: String(describing: MarketCell.self))
        return view
    }()
    
    lazy var segment: UISegmentedControl = {
        let segment: UISegmentedControl = UISegmentedControl(items: [ "Cap", "1 hr %", "24 hr %", "7 day %", "Volume"])
        segment.sizeToFit()
        segment.addTarget(self, action: #selector(didChangeSegmentedControl(_:)), for: .valueChanged)
        segment.tintColor = UIColor.white
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "market".uppercased()
        view.addSubview(tableView)
        self.navigationItem.titleView = segment
        
        tableView.horizontalAnchors == view.horizontalAnchors
        tableView.bottomAnchor == view.bottomAnchor
        tableView.topAnchor ==  view.topAnchor
        
        CryptoCurrencyHelper.fetchCryptos(url: UrlConstants.coinMarketCapTickerUrl) { (cryptos) in
            RealmCrudHelper.writeCryptos(cryptos)
        }
    }
    
    @objc func didChangeSegmentedControl(_ segmented: UISegmentedControl) {
        switch segmented.selectedSegmentIndex {
        case 0:
            cryptos = cryptos?.sorted(by: { (crypto1, crypto2) -> Bool in
                return crypto1.rank < crypto2.rank
            })
            tableView.reloadData()
        case 1:
            cryptos = cryptos?.sorted(by: { (crypto1, crypto2) -> Bool in
                return crypto1.percentChangeOneHour < crypto2.percentChangeOneHour
            })
            tableView.reloadData()
        case 2:
            cryptos = cryptos?.sorted(by: { (crypto1, crypto2) -> Bool in
                return crypto1.percentChangeTwentyFourHour < crypto2.percentChangeTwentyFourHour
            })
            tableView.reloadData()
        case 3:
            cryptos = cryptos?.sorted(by: { (crypto1, crypto2) -> Bool in
                return crypto1.percentChangeSevenDays < crypto2.percentChangeSevenDays
            })
            tableView.reloadData()
        case 3:
            cryptos = cryptos?.sorted(by: { (crypto1, crypto2) -> Bool in
                return crypto1.twentyFourHourVolumeUsd < crypto2.twentyFourHourVolumeUsd
            })
            tableView.reloadData()
        default: return
        }
    }
}

extension MarketViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cryptos = cryptos else { return 0 }
        return cryptos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cryptos = cryptos, let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MarketCell.self)) as? MarketCell else { return UITableViewCell() }
        cell.setCrypto(cryptos[indexPath.row])
        return cell
    }
}
