import SwiftUI

struct Product: Identifiable {
    let id = UUID()
    let name: String
    let sku: String
    let units: Int
    let status: StockStatus
    let icon: String
}

enum StockStatus {
    case inStock
    case lowStock
    case criticalStock
    
    var color: Color {
        switch self {
        case .inStock: return .green
        case .lowStock: return .orange
        case .criticalStock: return .red
        }
    }
    
    var text: String {
        switch self {
        case .inStock: return "In Stock"
        case .lowStock: return "Low Stock"
        case .criticalStock: return "Critical Stock"
        }
    }
}

struct RecentProductsView: View {
    @EnvironmentObject var productManager: ProductManager
    
    // Show up to 5 most recent products
    var recentProducts: [ProductItem] {
        productManager.products.suffix(5).reversed()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Products")
                    .font(.headline)
                Spacer()
                NavigationLink("See All") {
                    ProductsListView()
                        .environmentObject(productManager)
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            VStack(spacing: 12) {
                ForEach(recentProducts) { product in
                    ProductItemRow(product: product)
                }
                if recentProducts.isEmpty {
                    Text("No products yet.")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                        .padding(.vertical, 16)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct ProductItemRow: View {
    let product: ProductItem
    
    var totalSales: Int { product.monthlySales.values.reduce(0, +) }
    
    var salesColor: Color {
        switch totalSales {
        case 100...100_000: return .green
        case 50..<100: return .yellow
        case 10..<50: return .purple
        case 1..<10: return .red
        default: return .gray
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Text(product.emoji)
                .font(.system(size: 32))
                .frame(width: 44, height: 44)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                if product.unitPrice > 0 {
                    Text("\(product.currency.symbol)\(String(format: "%.2f", product.unitPrice))/unit")
                        .font(.caption2)
                        .foregroundColor(.blue)
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(totalSales) units")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(salesColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(salesColor, lineWidth: 1.2)
                            .background(RoundedRectangle(cornerRadius: 8).fill(salesColor.opacity(0.08)))
                    )
            }
        }
        .padding(.vertical, 4)
    }
}

struct ProductsListView: View {
    @EnvironmentObject var productManager: ProductManager
    var body: some View {
        List(productManager.products.reversed()) { product in
            ProductItemRow(product: product)
        }
        .navigationTitle("All Products")
    }
}

#Preview {
    RecentProductsView()
        .environmentObject(ProductManager())
        .padding()
        .background(Color.gray.opacity(0.1))
} 