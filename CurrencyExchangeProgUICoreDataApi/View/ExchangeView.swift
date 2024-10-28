
import UIKit

class ExchangeView: UIView {
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Amount"
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.textColor = .darkGray
        textField.borderStyle = .none
        textField.keyboardType = .decimalPad
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // Kenarlık ve arka plan ayarları
        textField.layer.borderWidth = 1.5
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        textField.layer.cornerRadius = 12
        textField.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        // Gölge ayarları
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOpacity = 0.1
        textField.layer.shadowOffset = CGSize(width: 0, height: 2)
        textField.layer.shadowRadius = 4
        
        // Sol ve sağ boşluk eklemek için bir iç kenar boşluğu ekleyebiliriz
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.rightView = paddingView
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        
        return textField
    }()
    
    let baseCurrencyPicker = UIPickerView()
    let targetCurrencyPicker = UIPickerView()
    
    let convertButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Convert", for: .normal)
        
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = false
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.3
        
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let resultLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        
        // Yazı tipi ve rengini ayarlıyoruz
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .systemBlue
        
        // Arka plan rengi ve yuvarlatma ekliyoruz
        label.backgroundColor = UIColor.systemGray6
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        
        // İçerik kenar boşluğu ekliyoruz
        label.textAlignment = .center
        label.layer.borderColor = UIColor.systemBlue.cgColor
        label.layer.borderWidth = 1.0
        
        // Gölge ekliyoruz
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 3)
        label.layer.shadowOpacity = 0.3
        label.layer.shadowRadius = 5
        label.translatesAutoresizingMaskIntoConstraints = false
       
        return label
    }()
    

    
    // MARK: - Setup UI
    private func setupUI() {
        addSubview(amountTextField)
        addSubview(baseCurrencyPicker)
        addSubview(targetCurrencyPicker)
        addSubview(convertButton)
        addSubview(resultLabel)
    
        baseCurrencyPicker.translatesAutoresizingMaskIntoConstraints = false
        targetCurrencyPicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Miktar TextField'ı
            amountTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 80),
            amountTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            amountTextField.widthAnchor.constraint(equalToConstant: 200),
            amountTextField.heightAnchor.constraint(equalToConstant: 40),
            
            // Kaynak Para Birimi Picker'ı
            baseCurrencyPicker.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 30),
            baseCurrencyPicker.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            baseCurrencyPicker.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -10),
            baseCurrencyPicker.heightAnchor.constraint(equalToConstant: 120),
            
            // Hedef Para Birimi Picker'ı
            targetCurrencyPicker.topAnchor.constraint(equalTo: baseCurrencyPicker.topAnchor),
            targetCurrencyPicker.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 10),
            targetCurrencyPicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            targetCurrencyPicker.heightAnchor.constraint(equalToConstant: 120),
            
            // Çevir Butonu
            convertButton.topAnchor.constraint(equalTo: baseCurrencyPicker.bottomAnchor, constant: 30),
            convertButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            convertButton.widthAnchor.constraint(equalToConstant: 200),
            convertButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Sonuç Label
            resultLabel.topAnchor.constraint(equalTo: convertButton.bottomAnchor, constant: 30),
            resultLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            resultLabel.widthAnchor.constraint(equalToConstant: 250),
            resultLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
