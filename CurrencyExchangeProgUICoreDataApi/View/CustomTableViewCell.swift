//
//  customCellForRates.swift
//  CurrencyExchangeProgUICoreDataApi
//
import UIKit

class CustomTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    // MARK: - Properties
    let currencyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    let symbolLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray

        return label
    }()
    
    let exchangeRateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false // Autolayout kullanmak için
        label.textAlignment = .center // Ortaya hizalama
        label.textColor = .black // Yazı rengi
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium) // Yazı tipi ve boyutu
        label.numberOfLines = 0 // Satır sayısını sınırsız yaparak çoklu satır destekleme
        label.backgroundColor = UIColor.systemGray6 // Arka plan rengi
        label.layer.cornerRadius = 10 // Köşeleri yuvarlama
        label.layer.masksToBounds = true // Köşeleri maskeleme
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
        addSubview(exchangeRateLabel)
        addSubview(currencyLabel)
        addSubview(symbolLabel)

        
        // Layout constraints
        NSLayoutConstraint.activate([
            
            exchangeRateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            exchangeRateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            exchangeRateLabel.widthAnchor.constraint(equalToConstant: 100),
            
            currencyLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            currencyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            currencyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -130),
            
            symbolLabel.topAnchor.constraint(equalTo: currencyLabel.bottomAnchor, constant: 5),
            symbolLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            symbolLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -130),
            symbolLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
    
        ])
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Sadece sayılara izin ver
        let allowedCharacters = CharacterSet(charactersIn: "0123456789")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet) || string.isEmpty
    }
    
}
