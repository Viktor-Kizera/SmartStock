import SwiftUI

struct QuickActionsView: View {
    @EnvironmentObject var notificationManager: NotificationManager
    @EnvironmentObject var productManager: ProductManager
    @EnvironmentObject var tabRouter: TabRouter
    @State private var showAddProduct = false
    @State private var showScanner = false
    @State private var showShareSheet = false
    
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
                    action: {
                        tabRouter.selectedTab = .analytics
                        tabRouter.scrollToSalesPerformance.toggle()
                    }
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
                .environmentObject(productManager)
                .environmentObject(notificationManager)
        }
        .sheet(isPresented: $showScanner) {
            QRScannerPlaceholder()
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheetPlaceholder()
        }
    }
}

struct QRScannerPlaceholder: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "qrcode.viewfinder")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)
            Text("QR Code Scanner Coming Soon")
                .font(.headline)
            Button("Close") { dismiss() }
                .padding(.top, 16)
        }
        .padding()
    }
}

struct ShareSheetPlaceholder: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "square.and.arrow.up")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)
            Text("Export/Share Data Coming Soon")
                .font(.headline)
            Button("Close") { dismiss() }
                .padding(.top, 16)
        }
        .padding()
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
        .environmentObject(ProductManager())
        .environmentObject(NotificationManager())
        .environmentObject(TabRouter())
        .padding()
        .background(Color.gray.opacity(0.1))
} 