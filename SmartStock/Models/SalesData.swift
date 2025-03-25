import Foundation

struct SalesData: Identifiable, Codable {
    let id: UUID
    let month: Date
    let units: Int
}

struct ProductForecast: Identifiable, Codable {
    let id: UUID
    let productName: String
    let historicalSales: [SalesData]
    let yearlyPrediction: Int
    let date: Date
} 