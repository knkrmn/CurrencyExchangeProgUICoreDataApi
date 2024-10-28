//
//  customCellForRates.swift
//  CurrencyExchangeProgUICoreDataApi
//
//  Created by Okan Karaman on 23.10.2024.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    let currencyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    let symbolLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(currencyLabel)
        addSubview(symbolLabel)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            currencyLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            currencyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            currencyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            symbolLabel.topAnchor.constraint(equalTo: currencyLabel.bottomAnchor, constant: 5),
            symbolLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            symbolLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            symbolLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}
