
import UIKit

class MainTabBarController: UITabBarController {
    
    lazy var ratesVC: UIViewController = {
        let navController = UINavigationController(rootViewController: RatesVC())
        navController.tabBarItem = UITabBarItem(title: "Rates", image: UIImage(systemName: "banknote"), tag: 0)
        return navController
    }()
    
    lazy var exchanceVC: UIViewController = {
        let navController = UINavigationController(rootViewController: ExchangeViewController() )
        navController.tabBarItem = UITabBarItem(title: "Currencies", image: UIImage(systemName: "globe.europe.africa"), tag: 1)
        return navController
    }()
    
     lazy var currenciesVC: UIViewController = {
        let navController = UINavigationController(rootViewController: CurrenciesVC())
        navController.tabBarItem = UITabBarItem(title: "Currencies", image: UIImage(systemName: "globe.europe.africa"), tag: 1)
        return navController
    }()
    
    lazy var timeLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Last Updated:"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .black // İstediğiniz renk
        titleLabel.sizeToFit() // Label'in boyutunu içeriğe göre ayarlar
        return titleLabel
    }()
   

    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 1
        CoreDataManager.shared.forBegining()
        setupUI()
    }

    func setupUI() {
        view.backgroundColor = .white
        viewControllers = [ratesVC, exchanceVC]
    
        navigationItem.title = "Exchange Changer App"

    }

    
}

