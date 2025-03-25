import Foundation

struct Prediction: Identifiable, Codable {
    let id: UUID
    let productName: String
    let demand: Int
    let date: Date
    let forecastType: ForecastType
    
    enum ForecastType: String, Codable {
        case basic = "Basic Forecast"
        case advanced = "Advanced AI Forecast"
    }
} 