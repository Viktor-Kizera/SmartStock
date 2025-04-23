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
    let products: [Product] = [
        Product(name: "Wireless Headphones", sku: "#WH7845", units: 234, status: .inStock, icon: "headphones"),
        Product(name: "Smart Watch X2", sku: "#SW2346", units: 45, status: .lowStock, icon: "applewatch"),
        Product(name: "Pro Earbuds", sku: "#PE8921", units: 12, status: .criticalStock, icon: "airpodspro"),
        Product(name: "Fast Charger Pro", sku: "#FC4432", units: 567, status: .inStock, icon: "bolt.fill"),
        Product(name: "Premium Case", sku: "#PC1123", units: 89, status: .lowStock, icon: "iphone")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Products")
                    .font(.headline)
                
                Spacer()
                
                NavigationLink("See All") {
                    // Destination view
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            
            VStack(spacing: 12) {
                ForEach(products) { product in
                    ProductRow(product: product)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct ProductRow: View {
    let product: Product
    
    var body: some View {
        HStack(spacing: 16) {
            // Product Icon
            Image(systemName: product.icon)
                .font(.title2)
                .foregroundColor(.gray)
                .frame(width: 40, height: 40)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            // Product Info
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(product.sku)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Units and Status
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(product.units) units")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(product.status.text)
                    .font(.caption)
                    .foregroundColor(product.status.color)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(8)
    }
}

#Preview {
    RecentProductsView()
        .padding()
        .background(Color.gray.opacity(0.1))
} 