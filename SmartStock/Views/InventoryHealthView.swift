import SwiftUI

struct InventoryHealthView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Inventory Health")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {
                    // View All action
                }) {
                    Text("View All")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            
            HStack(spacing: 12) {
                // In Stock
                InventoryStatCard(
                    title: "In Stock",
                    count: "2,453",
                    color: .green,
                    backgroundColor: Color.green.opacity(0.1)
                )
                
                // Low Stock
                InventoryStatCard(
                    title: "Low Stock",
                    count: "142",
                    color: .orange,
                    backgroundColor: Color.orange.opacity(0.1)
                )
                
                // Out of Stock
                InventoryStatCard(
                    title: "Out of\nStock",
                    count: "23",
                    color: .red,
                    backgroundColor: Color.red.opacity(0.1)
                )
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
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

#Preview {
    InventoryHealthView()
        .padding()
        .background(Color(uiColor: .systemGray6))
} 