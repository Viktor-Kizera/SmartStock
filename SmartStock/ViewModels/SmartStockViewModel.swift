import Foundation
import SwiftUI

class SmartStockViewModel: ObservableObject {
    @Published var productName: String = ""
    @Published var monthlySales: [String: Int] = [
        "Січень": 0, "Лютий": 0, "Березень": 0,
        "Квітень": 0, "Травень": 0, "Червень": 0,
        "Липень": 0, "Серпень": 0, "Вересень": 0,
        "Жовтень": 0, "Листопад": 0, "Грудень": 0
    ]
    @Published var yearlyPrediction: Int = 0
    @Published var isShowingResults = false
    
    private let userDefaults = UserDefaults.standard
    private let forecastsKey = "savedForecasts"
    
    let months = [
        "Січень", "Лютий", "Березень",
        "Квітень", "Травень", "Червень",
        "Липень", "Серпень", "Вересень",
        "Жовтень", "Листопад", "Грудень"
    ]
    
    func updateSales(for month: String, value: Int) {
        monthlySales[month] = value
    }
    
    func predictDemand() {
        let values = months.map { monthlySales[$0] ?? 0 }
        let average = values.reduce(0, +) / values.count
        let trend = calculateTrend(values: values)
        
        // Розраховуємо річний прогноз з урахуванням тренду
        yearlyPrediction = max(0, Int(Double(average * 12) * (1 + trend)))
        isShowingResults = true
        saveForecast()
    }
    
    private func calculateTrend(values: [Int]) -> Double {
        guard values.count > 1 else { return 0 }
        
        let doubles = values.map(Double.init)
        var sumXY = 0.0
        var sumX = 0.0
        var sumX2 = 0.0
        let n = Double(doubles.count)
        
        for (i, value) in doubles.enumerated() {
            let x = Double(i)
            sumXY += x * value
            sumX += x
            sumX2 += x * x
        }
        
        let slope = (n * sumXY - sumX * doubles.reduce(0, +)) / (n * sumX2 - sumX * sumX)
        return slope / (doubles.reduce(0, +) / n)
    }
    
    private func saveForecast() {
        let forecast = [
            "productName": productName,
            "monthlySales": monthlySales,
            "yearlyPrediction": yearlyPrediction,
            "date": Date()
        ] as [String : Any]
        
        userDefaults.set(forecast, forKey: forecastsKey)
    }
    
    func incrementSales(for month: String) {
        let currentValue = monthlySales[month] ?? 0
        monthlySales[month] = currentValue + 1
    }
    
    func decrementSales(for month: String) {
        let currentValue = monthlySales[month] ?? 0
        monthlySales[month] = max(0, currentValue - 1)
    }
} 