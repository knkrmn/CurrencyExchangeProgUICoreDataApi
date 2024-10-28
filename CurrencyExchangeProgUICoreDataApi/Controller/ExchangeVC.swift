import UIKit

class ExchangeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private let exchangeView = ExchangeView()
    private var exchangeRate: ExchangeRate?
    private var currencies  = CoreDataManager.shared.getisSelectedSymbols()
    var rates: ExchangeRatesResponse?
    var rate : Double = 1.0
  

    
    
    // MARK: - Lifecycle Methods
    override func loadView() {
        self.view = exchangeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchRatesData()

        setupPickerViews()
        exchangeView.convertButton.addTarget(self, action: #selector(convertTapped), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updatePickers()
                
    }
    
    // MARK: - Setup Methods
    private func setupPickerViews() {
        exchangeView.baseCurrencyPicker.delegate = self
        exchangeView.baseCurrencyPicker.dataSource = self
        exchangeView.targetCurrencyPicker.delegate = self
        exchangeView.targetCurrencyPicker.dataSource = self
    }
    
    // MARK: - Button Action
    @objc private func convertTapped() {
        guard let amountText = exchangeView.amountTextField.text,
              let amount = Double(amountText),
              let baseCurrency = selectedBaseCurrency(),
              let targetCurrency = selectedTargetCurrency() else {
            exchangeView.resultLabel.text = "Invalid input."
            return
        }
        
        print(rates?.rates[baseCurrency] as Any)
        print(rates?.rates[targetCurrency] as Any)
        
        if let baseCurrancyRate = rates?.rates[baseCurrency],
           let targetCurrencyRate = rates?.rates[targetCurrency]    {
            
            if baseCurrancyRate != 0 {
            
                rate = targetCurrencyRate / baseCurrancyRate
                
            } else {
                print("Base currency rate is zero, cannot perform conversion.")
            }
        } else {
            print("Kurlar alınamadı veya geçersiz para birimi.")
        }

        
        exchangeRate = ExchangeRate(baseCurrency: baseCurrency, targetCurrency: targetCurrency, rate: rate) // Örnek döviz kuru
    
        
        if let result = exchangeRate?.convert(amount: amount) {
            let formattedResult = String(format: "%.2f", result) // 2 ondalık basamak
            exchangeView.resultLabel.text = "\(formattedResult) \(targetCurrency)"
        }
    }
    
    func fetchRatesData() {
        CurrencyService.shared.fetchData(from: .latest) { [weak self] result in
            switch result {
            case .success(let response):
                if let ratesResponse = response as? ExchangeRatesResponse {
                    DispatchQueue.main.async {
                        self?.rates = ratesResponse
                    }
                }
            case .failure(let error):
                print("Fetch Döviz kurları alınamadı: \(error.localizedDescription)")
            }
        }
    }
    
    func updatePickers() {
        let oldCount = currencies.count
        currencies  = CoreDataManager.shared.getisSelectedSymbols()
        if oldCount != currencies.count {
            exchangeView.baseCurrencyPicker.reloadAllComponents()
            exchangeView.targetCurrencyPicker.reloadAllComponents()
        }
    }
    
    private func selectedBaseCurrency() -> String? {
        let selectedRow = exchangeView.baseCurrencyPicker.selectedRow(inComponent: 0)
        return selectedRow < currencies.count ? currencies[selectedRow].symbol : nil
    }

    private func selectedTargetCurrency() -> String? {
        let selectedRow = exchangeView.targetCurrencyPicker.selectedRow(inComponent: 0)
        return selectedRow < currencies.count ? currencies[selectedRow].symbol : nil
    }
    
    // MARK: - UIPickerViewDelegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row].symbol
    }
    
}
