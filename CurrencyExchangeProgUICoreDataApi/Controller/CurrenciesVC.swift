
import UIKit

class CurrenciesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    //MARK: - Properties
    let defaultSymbols = ["USD","EUR","JPY","CZK","TRY","UAH","GBP"]
    var symbols = [Symbol]()
    var filteredSymbols = [Symbol]()
    let currenciesView = CurrenciesView()
    let ratesVC = RatesVC()
    var onDismiss: (() -> Void)?
    
    //MARK: - LifeCycle
    
    override func loadView() {
        self.view = currenciesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        symbols = CoreDataManager.shared.getAllSymbols()
        filteredSymbols = symbols
        
        currenciesView.tableView.delegate = self
        currenciesView.tableView.dataSource = self
        currenciesView.searchBar.delegate = self
        
        currenciesView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //currenciesView.searchBar.isHidden = false // Search bar'ı göster
        refreshData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //currenciesView.searchBar.isHidden = true // Search bar'ı gizle
     
        print("Current VC - viewWillDisappear")
        //ratesView.tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
         super.viewDidDisappear(animated)
         onDismiss?()  // Blok tanımlıysa çağır
     }
    
    
    private func refreshData() {
        symbols = CoreDataManager.shared.getAllSymbols()
        filteredSymbols = symbols
        currenciesView.tableView.reloadData()
    }
    
    //MARK: - TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSymbols.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let currency = filteredSymbols[indexPath.row]
        
        cell.textLabel?.text = "\(currency.symbol) - \(currency.name)"
        cell.backgroundColor = currency.isSelected ? .systemBlue : .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        CoreDataManager.shared.update(symbol: filteredSymbols[indexPath.row])
        filteredSymbols[indexPath.row].isSelected.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    //MARK: - SearchBar Delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredSymbols = symbols
        } else {
            filteredSymbols = symbols.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        currenciesView.tableView.reloadData()
    }
}
