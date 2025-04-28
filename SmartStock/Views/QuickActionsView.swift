import SwiftUI

struct QuickActionsView: View {
    @State private var showAddProduct = false
    @State private var showScanner = false
    @State private var showShareSheet = false
    var onAnalytics: (() -> Void)? = nil
    
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
                    action: { showAddProduct = true }
                )
                
                QuickActionButton(
                    icon: "barcode.viewfinder",
                    title: "Scan Item",
                    action: { showScanner = true }
                )
                
                QuickActionButton(
                    icon: "chart.bar",
                    title: "Analytics",
                    action: { onAnalytics?() }
                )
                
                QuickActionButton(
                    icon: "square.and.arrow.up",
                    title: "Export Data",
                    action: { showShareSheet = true }
                )
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .sheet(isPresented: $showAddProduct) {
            AddProductView()
        }
        .sheet(isPresented: $showScanner) {
            ScannerPlaceholderView()
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: ["Exported SmartStock data (placeholder)"])
        }
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

struct ScannerPlaceholderView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "qrcode.viewfinder")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            Text("QR Code Scanner Coming Soon")
                .font(.title3)
                .foregroundColor(.gray)
            Button("Close") { dismiss() }
                .padding()
        }
        .padding()
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    QuickActionsView()
        .padding()
        .background(Color.gray.opacity(0.1))
} 