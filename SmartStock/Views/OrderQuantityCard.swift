import SwiftUI

struct OrderQuantityCard: View {
    let period: String
    let units: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(period)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("\(units)")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Units")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    OrderQuantityCard(period: "Q1", units: 1250)
        .padding()
        .background(Color(uiColor: .systemGray6))
} 