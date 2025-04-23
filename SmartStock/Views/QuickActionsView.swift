import SwiftUI

struct QuickActionsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.headline)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                QuickActionButton(
                    icon: "plus",
                    title: "Add Product",
                    action: {}
                )
                
                QuickActionButton(
                    icon: "barcode.viewfinder",
                    title: "Scan Item",
                    action: {}
                )
                
                QuickActionButton(
                    icon: "chart.bar",
                    title: "Analytics",
                    action: {}
                )
                
                QuickActionButton(
                    icon: "square.and.arrow.up",
                    title: "Export Data",
                    action: {}
                )
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.blue)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
    }
}

#Preview {
    QuickActionsView()
        .padding()
        .background(Color.gray.opacity(0.1))
} 