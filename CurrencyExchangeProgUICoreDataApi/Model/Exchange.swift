import Foundation

struct ExchangeRate {
    let baseCurrency: String
    let targetCurrency: String
    let rate: Double
    
    func convert(amount: Double, isReversed: Bool = false) -> Double {
        return isReversed ? amount / rate : amount * rate
    }
}
