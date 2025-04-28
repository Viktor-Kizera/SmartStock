import SwiftUI

struct InventoryHealthView: View {
    @EnvironmentObject var productManager: ProductManager
    @State private var showAll = false
    @State private var selectedCategory: StockCategory? = nil
    
    // Stock category sums
    private var greenSum: Int {
        productManager.products.filter { totalSales(for: $0) >= 100 && totalSales(for: $0) <= 100_000 }
            .map { totalSales(for: $0) }
            .reduce(0, +)
    }
    private var yellowSum: Int {
        productManager.products.filter { totalSales(for: $0) >= 50 && totalSales(for: $0) < 100 }
            .map { totalSales(for: $0) }
            .reduce(0, +)
    }
    private var purpleSum: Int {
        productManager.products.filter { totalSales(for: $0) >= 10 && totalSales(for: $0) < 50 }
            .map { totalSales(for: $0) }
            .reduce(0, +)
    }
    private var redSum: Int {
        productManager.products.filter { totalSales(for: $0) >= 1 && totalSales(for: $0) < 10 }
            .map { totalSales(for: $0) }
            .reduce(0, +)
    }
    
    private func totalSales(for product: ProductItem) -> Int {
        product.monthlySales.values.reduce(0, +)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Sales Dashboard")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    showAll = true
                }) {
                    Text("View All")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    Button(action: { selectedCategory = .green }) {
                        InventoryStatCard(
                            title: "Many stock",
                            count: "\(greenSum)",
                            color: .green,
                            backgroundColor: Color.green.opacity(0.1)
                        )
                    }.buttonStyle(PlainButtonStyle())
                    Button(action: { selectedCategory = .yellow }) {
                        InventoryStatCard(
                            title: "Medium stock",
                            count: "\(yellowSum)",
                            color: .yellow,
                            backgroundColor: Color.yellow.opacity(0.1)
                        )
                    }.buttonStyle(PlainButtonStyle())
                    Button(action: { selectedCategory = .purple }) {
                        InventoryStatCard(
                            title: "Enough stock",
                            count: "\(purpleSum)",
                            color: .purple,
                            backgroundColor: Color.purple.opacity(0.1)
                        )
                    }.buttonStyle(PlainButtonStyle())
                    Button(action: { selectedCategory = .red }) {
                        InventoryStatCard(
                            title: "Low stock",
                            count: "\(redSum)",
                            color: .red,
                            backgroundColor: Color.red.opacity(0.1)
                        )
                    }.buttonStyle(PlainButtonStyle())
                }
                .padding(.vertical, 2)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
        .sheet(isPresented: $showAll) {
            InventoryHealthListView()
                .environmentObject(productManager)
        }
        .sheet(item: $selectedCategory) { category in
            InventoryHealthCategoryListView(category: category)
                .environmentObject(productManager)
        }
    }
}

struct InventoryHealthListView: View {
    @EnvironmentObject var productManager: ProductManager
    
    private func totalSales(for product: ProductItem) -> Int {
        product.monthlySales.values.reduce(0, +)
    }
    
    private var greenProducts: [ProductItem] {
        productManager.products.filter { totalSales(for: $0) >= 100 && totalSales(for: $0) <= 100_000 }
    }
    private var yellowProducts: [ProductItem] {
        productManager.products.filter { totalSales(for: $0) >= 50 && totalSales(for: $0) < 100 }
    }
    private var purpleProducts: [ProductItem] {
        productManager.products.filter { totalSales(for: $0) >= 10 && totalSales(for: $0) < 50 }
    }
    private var redProducts: [ProductItem] {
        productManager.products.filter { totalSales(for: $0) >= 1 && totalSales(for: $0) < 10 }
    }
    
    var body: some View {
        NavigationView {
            List {
                if !greenProducts.isEmpty {
                    Section(header: Text("Many stock").foregroundColor(.green)) {
                        ForEach(greenProducts) { product in
                            InventoryHealthListRow(product: product, color: .green)
                        }
                    }
                }
                if !yellowProducts.isEmpty {
                    Section(header: Text("Medium stock").foregroundColor(.yellow)) {
                        ForEach(yellowProducts) { product in
                            InventoryHealthListRow(product: product, color: .yellow)
                        }
                    }
                }
                if !purpleProducts.isEmpty {
                    Section(header: Text("Enough stock").foregroundColor(.purple)) {
                        ForEach(purpleProducts) { product in
                            InventoryHealthListRow(product: product, color: .purple)
                        }
                    }
                }
                if !redProducts.isEmpty {
                    Section(header: Text("Low stock").foregroundColor(.red)) {
                        ForEach(redProducts) { product in
                            InventoryHealthListRow(product: product, color: .red)
                        }
                    }
                }
            }
            .navigationTitle("All Products by Stock")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct InventoryHealthListRow: View {
    let product: ProductItem
    let color: Color
    
    private var totalSales: Int {
        product.monthlySales.values.reduce(0, +)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Text(product.emoji)
                .font(.system(size: 32))
                .frame(width: 44, height: 44)
                .background(color.opacity(0.12))
                .cornerRadius(10)
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.headline)
                Text("Total sales: \(totalSales) units")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct InventoryStatCard: View {
    let title: String
    let count: String
    let color: Color
    let backgroundColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            Text(count)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(backgroundColor)
        .cornerRadius(12)
    }
}

enum StockCategory: Identifiable {
    case green, yellow, purple, red
    var id: Int {
        switch self {
        case .green: return 1
        case .yellow: return 2
        case .purple: return 3
        case .red: return 4
        }
    }
    var title: String {
        switch self {
        case .green: return "Many stock"
        case .yellow: return "Medium stock"
        case .purple: return "Enough stock"
        case .red: return "Low stock"
        }
    }
    var color: Color {
        switch self {
        case .green: return .green
        case .yellow: return .yellow
        case .purple: return .purple
        case .red: return .red
        }
    }
}

struct InventoryHealthCategoryListView: View {
    @EnvironmentObject var productManager: ProductManager
    let category: StockCategory
    
    private func totalSales(for product: ProductItem) -> Int {
        product.monthlySales.values.reduce(0, +)
    }
    
    private var filteredProducts: [ProductItem] {
        switch category {
        case .green:
            return productManager.products.filter { totalSales(for: $0) >= 100 && totalSales(for: $0) <= 100_000 }
        case .yellow:
            return productManager.products.filter { totalSales(for: $0) >= 50 && totalSales(for: $0) < 100 }
        case .purple:
            return productManager.products.filter { totalSales(for: $0) >= 10 && totalSales(for: $0) < 50 }
        case .red:
            return productManager.products.filter { totalSales(for: $0) >= 1 && totalSales(for: $0) < 10 }
        }
    }
    
    var body: some View {
        NavigationView {
            List(filteredProducts) { product in
                InventoryHealthListRow(product: product, color: category.color)
            }
            .navigationTitle(category.title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    InventoryHealthView()
        .environmentObject(ProductManager())
        .padding()
        .background(Color(uiColor: .systemGray6))
} 