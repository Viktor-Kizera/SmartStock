import Foundation

struct ProductItem: Identifiable, Codable, Hashable, Equatable {
    var id: UUID
    var name: String
    var monthlySales: [String: Int]
    var predictedDemand: [String: Int]
    var emoji: String
    var unitPrice: Double
    var currency: Currency
    
    init(id: UUID = UUID(), name: String, monthlySales: [String: Int] = [:], unitPrice: Double = 0.0, currency: Currency = .usd) {
        self.id = id
        self.name = name
        self.monthlySales = monthlySales
        self.predictedDemand = [:]
        self.emoji = ProductItem.findEmoji(for: name)
        self.unitPrice = unitPrice
        self.currency = currency
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
    
    static func findEmoji(for name: String) -> String {
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

enum Currency: String, Codable, CaseIterable {
    case usd = "USD"
    case uah = "UAH"
    
    var symbol: String {
        switch self {
        case .usd: return "$"
        case .uah: return "₴"
        }
    }
    
    var name: String {
        switch self {
        case .usd: return "US Dollar"
        case .uah: return "Ukrainian Hryvnia"
        }
    }
}

class ProductManager: ObservableObject {
    @Published var products: [ProductItem] = []
    private let saveKey = "savedProducts"
    private let hasInitializedKey = "hasInitializedProducts"
    
    init() {
        loadProducts()
        
        // Додаємо демонстраційні товари тільки при першому запуску
        if UserDefaults.standard.bool(forKey: hasInitializedKey) == false {
            addDemoProducts()
            UserDefaults.standard.set(true, forKey: hasInitializedKey)
        }
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
    
    private func addDemoProducts() {
        let months = ["January", "February", "March", "April", "May", "June", 
                     "July", "August", "September", "October", "November", "December"]
        
        // Демо-товар 1: Яблука
        var appleSales: [String: Int] = [:]
        for (index, month) in months.enumerated() {
            // Зимою і восени більше продажі
            if index < 2 || index > 8 {
                appleSales[month] = Int.random(in: 500...800)
            } else {
                appleSales[month] = Int.random(in: 200...500)
            }
        }
        
        let apple = ProductItem(
            name: "Apples", 
            monthlySales: appleSales, 
            unitPrice: 1.25, 
            currency: .usd
        )
        
        // Демо-товар 2: Банани
        var bananaSales: [String: Int] = [:]
        for month in months {
            bananaSales[month] = Int.random(in: 300...700)
        }
        
        let banana = ProductItem(
            name: "Bananas", 
            monthlySales: bananaSales, 
            unitPrice: 0.89, 
            currency: .usd
        )
        
        // Демо-товар 3: Молоко
        var milkSales: [String: Int] = [:]
        for month in months {
            milkSales[month] = Int.random(in: 800...1200)
        }
        
        let milk = ProductItem(
            name: "Milk", 
            monthlySales: milkSales, 
            unitPrice: 2.49, 
            currency: .usd
        )
        
        // Додаємо демо-товари
        products.append(apple)
        products.append(banana)
        products.append(milk)
        
        // Зберігаємо до UserDefaults
        saveProducts()
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