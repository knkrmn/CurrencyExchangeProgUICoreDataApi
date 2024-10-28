//
//  ApiServiceBetter.swift
//  ExchangeApiProgramaticUI
//
/*
 import Foundation
 import UIKit
 
 class CurrencyService {
 
 // MARK: - Singleton Instance (Tek örnek kullanım)
 static let shared = CurrencyService()
 
 // MARK: - API Constants (Sabitler)
 private let baseURL = "https://data.fixer.io/api/symbols"
 private let accessKey = "1f41488d560b4d9221ce7ea476b33db6"
 
 // MARK: - Fetch Currency Symbols (Döviz kurlarını çekme)
 func fetchCurrencySymbols(completion: @escaping (Result<[String : String],
 Error>) -> Void) {
 // API isteği için tam URL'yi oluşturuyoruz.
 let urlString = "\(baseURL)?access_key=\(accessKey)"
 // URL geçerli mi kontrol edilir.
 guard let url = URL(string: urlString) else {
 completion(.failure(NSError(domain: "URL is not valid",
 code: 400,userInfo: nil)))
 return
 }
 // Ağ isteği (network request) yapılır.
 let task = URLSession.shared.dataTask(with: url) { data, response, error in
 // Ağ hatası olup olmadığını kontrol ederiz.
 if let error = error {
 completion(.failure(error))
 return
 }
 // Veri var mı kontrol edilir.
 guard let data = data else {
 completion(.failure(NSError(domain: "No data",code: 404,userInfo: nil)))
 return
 }
 do {
 // JSON verisini sözlüğe (dictionary) çeviririz.
 if let jsonResponse = try JSONSerialization.jsonObject(with: data, options:.mutableContainers) as? [String : Any],
 let symbols = jsonResponse["symbols"] as? [String : String] {
 // Eğer başarılı olursa döviz kurlarını döneriz.
 completion(.success(symbols))
 } else {
 // 'symbols' anahtarı bulunmazsa hata döneriz.
 completion(.failure(NSError(domain: "Data format is not correct", code: 422, userInfo: nil)))
 }
 } catch let jsonError {
 // JSON çözümleme hatalarını yakalarız.
 completion(.failure(jsonError))
 } }
 task.resume()
 }
 } */

import Foundation
import UIKit


struct ExchangeSymbolResponse: Codable {
    let symbols: [String: String]
}

struct ExchangeRatesResponse: Codable {
    let timestamp: Int
    let base: String
    let rates: [String: Double]
    let date: String
}

class CurrencyService {
    
    // MARK: - Singleton Instance
    static let shared = CurrencyService()
    
    // MARK: - API Constants
    private let baseFixerURL = "https://data.fixer.io/api/"
    private let accessKey = "9288509ea41855d1c64d86eafff7b1f6"
    
    // MARK: - API Endpoints
    enum APIEndpoint: String {
        case symbols    = "symbols"  // Döviz kurları sembolleri
        case latest     = "latest"    // Güncel döviz kurları
    }
    
    // MARK: - API Endpoints
    enum APIResponse: String {
        case symbols    = "ExchangeSymbolResponse"  // Döviz kurları sembolleri
        case latest     = "ExchangeRatesResponse"    // Güncel döviz kurları
    }
    
    // MARK: - Fetch Data from API
    func fetchData(from endpoint: APIEndpoint, completion: @escaping (Result<Any, Error>) -> Void) {
        // API isteği için tam URL'yi oluşturuyoruz.
        let urlString = "\(baseFixerURL)\(endpoint.rawValue)?access_key=\(accessKey)"
        
        // URL geçerli mi kontrol edilir.
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "URL is not valid", code: 400, userInfo: nil)))
            return
        }
        
        // Ağ isteği (network request) yapılır.
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Ağ hatası olup olmadığını kontrol ederiz.
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Veri var mı kontrol edilir.
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 404, userInfo: nil)))
                return
            }

            do {
                switch endpoint {
                case .symbols:
                    let decodedResponse = try JSONDecoder().decode(ExchangeSymbolResponse.self, from: data)
                    completion(.success(decodedResponse))
                    
                case .latest:
                    let decodedResponse = try JSONDecoder().decode(ExchangeRatesResponse.self, from: data)
                    completion(.success(decodedResponse))
                }
            } catch let decodingError {
                completion(.failure(decodingError))
            }
            
        }
        task.resume()
    }
}
