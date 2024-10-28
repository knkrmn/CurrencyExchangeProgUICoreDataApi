//
//  Model.swift
//  CurrencyExchangeProgUICoreDataApi
//
import CoreData
import UIKit

// Symbol Model
struct Symbol:Codable {
    let name: String
    let symbol: String
    var isSelected: Bool
}

// Core Data Manager (Model)
class CoreDataManager {
    let defaultSymbols = ["EUR","USD","TRY","UAH","GBP","HUF","YPY"]
    
    static let shared = CoreDataManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Veritabanına tüm sembolleri kaydetme
    func saveSymbols(with symbols: [String : String]) {
        for symbol in symbols {
            print(symbol)
            let newSymbol = NSEntityDescription.insertNewObject(forEntityName: "SYMBOLS", into: context)
            newSymbol.setValue(symbol.key, forKey: "symbol")
            newSymbol.setValue(symbol.value, forKey: "name")
            newSymbol.setValue(defaultSymbols.contains(symbol.key),forKey: "isSelected")
            do {
                try context.save()
            } catch {
                print("Error saving symbol: \(error)")
            }
        }
        print("\(symbols.count) data saved to core for first use")
    }
    
    // Veritabanında sembolün durumunu güncelleme
    func update(symbol: Symbol) {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "SYMBOLS")
        request.predicate = NSPredicate(format: "symbol == %@", symbol.symbol)
        
        do {
            let results = try context.fetch(request)
            if let symbolToUpdate = results.first as? NSManagedObject {
                symbolToUpdate.setValue(!symbol.isSelected, forKey: "isSelected")
                try context.save()
            }
        } catch {
            print("Failed to update symbol: \(error)")
        }
    }
    
    // if there is some records in core data
    func checkIfSymbolsExist() -> Bool {
        // Core Data'yı çekmek için AppDelegate'ten context alıyoruz
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        // Fetch request ile "Symbol" entity'sini sorguluyoruz
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SYMBOLS")
        
        do {
            let result = try context.fetch(fetchRequest)
            // Eğer veri varsa, true döner
            if result.count > 0 {
                print("Modal checkIfSymbolsExist true")
                return true
            }
        } catch {
            print("Error fetching data from Core Data")

        }
        print("Modal checkIfSymbolsExist false")
        return false
    }
    
    //
    func getisSelectedSymbols() -> [Symbol] {
        var selectedSymbolsArr = [Symbol]()
        // 1. AppDelegate'deki context'e eriş
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        // 2. Fetch request oluştur
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SYMBOLS")
        
        do {
            // 3. Verileri fetch et
            let results = try context.fetch(fetchRequest)
            
            // 4. Verileri konsola yazdır
            for result in results as! [NSManagedObject] {
                if let symbol = result.value(forKey: "symbol") as? String {
                    if let name = result.value(forKey: "name") as? String {
                        if let isSelected = result.value(forKey: "isSelected") as? Bool {
                            if isSelected {
                                let newSymbol = Symbol(name: name, symbol: symbol, isSelected: isSelected)
                                selectedSymbolsArr.append(newSymbol)
                            }
                            
                        }
                    }
                }
            }
        } catch {
            print("Verileri çekerken hata oluştu: \(error)")
        }
        return selectedSymbolsArr
    }
    
    //
    func getAllSymbols() -> [Symbol]{
        var symbolsArr = [Symbol]()
        symbolsArr.removeAll(keepingCapacity: false)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SYMBOLS")
        
        do {
            let results = try context.fetch(fetchRequest)
            
            for result in results as! [NSManagedObject] {
                if let symbol = result.value(forKey: "symbol") as? String {
                    if let name = result.value(forKey: "name") as? String {
                        if let isSelected = result.value(forKey: "isSelected") as? Bool {
                            let newSymbol = Symbol(name: name, symbol: symbol, isSelected: isSelected)
                            symbolsArr.append(newSymbol)
                        }
                    }
                }
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        return symbolsArr
    }
    
    func fetchSymbols() {
        CurrencyService.shared.fetchData(from: .symbols) { result in
            switch result {
            case .success(let response):
                
                guard let symbolResponse = response as? ExchangeSymbolResponse else {
                         print("Unexpected response type")
                         return
                     }
                    DispatchQueue.main.async {
                        self.saveSymbols(with: symbolResponse.symbols)
                    }
                case .failure(let error):
                    print("fetchSymbols")
                    print("Error fetching symbols: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchRates() {
        CurrencyService.shared.fetchData(from: .latest) { result in
            switch result {
            case .success(let response):
                guard let ratesResponse = response as? ExchangeRatesResponse else {
                         print("Unexpected response type")
                         return
                     }
                     
                     DispatchQueue.main.async {
                         
                         print("fetchRates")
                         print("Timestamp: \(ratesResponse.timestamp)")
                         print("Base: \(ratesResponse.base)")
                         print("Date: \(ratesResponse.date)")
                        
                     }
            case .failure(let error):
                print("Error fetching symbols: \(error.localizedDescription)")
            }
        }
    }
    
    func printRates(with rates : [String : Any]){
        for rate in rates {
            print("\(rate.key) \(rate.value)")
        }
    }
    
    //func write symbos to core
    func forBegining() {
        if !checkIfSymbolsExist() {
            print("Model forBegining if inside")
            self.fetchSymbols()
        }
    }
}
