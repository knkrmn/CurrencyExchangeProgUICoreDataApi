
import UIKit

class RatesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    var selectedSymbolsArr: [Symbol]?
    let ratesView = RatesView()
    var rates: ExchangeRatesResponse?

    var exchangeVC = ExchangeViewController()

    // MARK: - Lifecycle Methods
    override func loadView() {
        self.view = ratesView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
        updateList()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ratesView.tableView.reloadData()
        updateList()
    }

    // MARK: - Setup Methods
    private func setupUI() {
        setupTableView()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.titleView = ratesView.topLabel
    }
    
    @objc func addTapped(){
        let currenciesVC = CurrenciesVC()
        currenciesVC.modalPresentationStyle = .automatic
        currenciesVC.modalTransitionStyle = .coverVertical // Yukarıdan aşağı geçiş animasyonu ekler
        
        currenciesVC.onDismiss = { [weak self] in
            self?.updateList()
        }
        
        present(currenciesVC, animated: true, completion:nil)
    }

    private func setupTableView() {
        ratesView.tableView.delegate = self
        ratesView.tableView.dataSource = self
        ratesView.tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomTableViewCell")
        ratesView.tableView.estimatedRowHeight = 100
        ratesView.tableView.rowHeight = UITableView.automaticDimension
    }

    // MARK: - Data Methods
    func loadData() {
        selectedSymbolsArr = CoreDataManager.shared.getisSelectedSymbols()
        fetchRatesData()
        ratesView.tableView.reloadData()
    }

    func fetchRatesData() {
        CurrencyService.shared.fetchData(from: .latest) { [weak self] result in
            switch result {
            case .success(let response):
                if let ratesResponse = response as? ExchangeRatesResponse {
                    DispatchQueue.main.async {
                        self?.rates = ratesResponse
                        self?.ratesView.tableView.reloadData()
                    }
                }
            case .failure(let error):
                print("Döviz kurları alınamadı: \(error.localizedDescription)")
            }
        }
    }

    func updateList() {
        let oldCount = selectedSymbolsArr?.count
        selectedSymbolsArr = CoreDataManager.shared.getisSelectedSymbols()
        
        if oldCount != selectedSymbolsArr?.count {
            ratesView.tableView.reloadData()
        }
    }

    // MARK: - TableView Delegate & DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedSymbolsArr?.count ?? 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }

        let symbol = selectedSymbolsArr?[indexPath.row]
        cell.currencyLabel.text = symbol?.name
        cell.symbolLabel.text = symbol?.symbol

        if let rate = rates?.rates[symbol?.symbol ?? "USD"] {
            cell.exchangeRateLabel.text = String("\(rate)".prefix(5))
        } else {
            cell.exchangeRateLabel.text = ""
        }
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let symbol = selectedSymbolsArr?[indexPath.row] {
                CoreDataManager.shared.update(symbol: symbol)
            }
            selectedSymbolsArr?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
