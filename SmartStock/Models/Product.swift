import Foundation

struct ProductItem: Identifiable, Codable, Hashable, Equatable {
    var id: UUID
    var name: String
    var monthlySales: [String: Int]
    var predictedDemand: [String: Int]
    var emoji: String
    
    init(id: UUID = UUID(), name: String, monthlySales: [String: Int] = [:]) {
        self.id = id
        self.name = name
        self.monthlySales = monthlySales
        self.predictedDemand = [:]
        self.emoji = ProductItem.findEmoji(for: name)
    }
    
    private static let emojiDictionary: [String: String] = [
        // Фрукти
        "apple": "🍎",
        "red apple": "🍎",
        "green apple": "🍏",
        "banana": "🍌",
        "orange": "🍊",
        "lemon": "🍋",
        "pear": "🍐",
        "peach": "🍑",
        "grapes": "🍇",
        "strawberry": "🍓",
        "blueberry": "🫐",
        "watermelon": "🍉",
        "mango": "🥭",
        "pineapple": "🍍",
        "coconut": "🥥",
        "kiwi": "🥝",
        "tomato": "🍅",
        "avocado": "🥑",
        
        // Овочі
        "carrot": "🥕",
        "corn": "🌽",
        "cucumber": "🥒",
        "broccoli": "🥦",
        "onion": "🧅",
        "garlic": "🧄",
        "potato": "🥔",
        "pepper": "🫑",
        "eggplant": "🍆",
        "mushroom": "🍄",
        
        // Інші продукти
        "bread": "🍞",
        "milk": "🥛",
        "cheese": "🧀",
        "egg": "🥚",
        "meat": "🥩",
        "chicken": "🍗",
        "fish": "🐟",
        "shrimp": "🦐",
        "rice": "🍚",
        "noodles": "🍜",
        "pizza": "🍕",
        "hamburger": "🍔",
        "sandwich": "🥪",
        "hotdog": "🌭",
        "taco": "🌮",
        "sushi": "🍣",
        
        // Напої
        "coffee": "☕️",
        "tea": "🫖",
        "juice": "🧃",
        "water": "💧",
        "beer": "🍺",
        "wine": "🍷",
        
        // Солодощі
        "candy": "🍬",
        "chocolate": "🍫",
        "cookie": "🍪",
        "cake": "🍰",
        "ice cream": "🍦",
        "donut": "🍩"
    ]
    
    private static func findEmoji(for name: String) -> String {
        let lowercaseName = name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Спочатку шукаємо точне співпадіння
        if let emoji = emojiDictionary[lowercaseName] {
            return emoji
        }
        
        // Якщо точного співпадіння немає, шукаємо часткове
        for (key, emoji) in emojiDictionary {
            if lowercaseName.contains(key) || key.contains(lowercaseName) {
                return emoji
            }
        }
        
        // Якщо нічого не знайдено, повертаємо стандартний емодзі
        return "📦"
    }
}

class ProductManager: ObservableObject {
    @Published var products: [ProductItem] = []
    private let saveKey = "savedProducts"
    
    init() {
        loadProducts()
    }
    
    func addProduct(_ product: ProductItem) {
        products.append(product)
        saveProducts()
    }
    
    func deleteProduct(_ product: ProductItem) {
        products.removeAll { $0.id == product.id }
        saveProducts()
    }
    
    func updateProduct(_ product: ProductItem) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products[index] = product
            saveProducts()
        }
    }
    
    func predictDemand(for product: ProductItem) -> [String: Int] {
        // Базове прогнозування: середнє значення + 10% для росту
        var predictions: [String: Int] = [:]
        let months = ["January", "February", "March", "April", "May", "June", 
                     "July", "August", "September", "October", "November", "December"]
        
        // Розрахунок середнього місячного продажу
        let totalSales = product.monthlySales.values.reduce(0, +)
        let averageSales = totalSales / max(product.monthlySales.count, 1)
        
        // Прогноз на наступний рік з урахуванням сезонності
        for month in months {
            if let historicalSales = product.monthlySales[month] {
                // Якщо є історичні дані для місяця, використовуємо їх як базу
                predictions[month] = Int(Double(historicalSales) * 1.1) // +10% до історичного значення
            } else {
                // Якщо немає історичних даних, використовуємо середнє значення
                predictions[month] = Int(Double(averageSales) * 1.1)
            }
        }
        
        return predictions
    }
    
    private func saveProducts() {
        if let encoded = try? JSONEncoder().encode(products) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadProducts() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([ProductItem].self, from: data) {
            products = decoded
        }
    }
} 