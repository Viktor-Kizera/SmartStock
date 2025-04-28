//
//  ContentView.swift
//  SmartStock
//
//  Created by Viktor Kizera on 3/25/25.
//

import SwiftUI
import Charts
import UserNotifications

// Оголошуємо екземпляр ProductManager на рівні програми для спільного доступу
class AppState: ObservableObject {
    @Published var productManager = ProductManager()
}

enum AnalyticsPeriod: String, CaseIterable, Equatable {
    case thisMonth = "This Month"
    case threeMonths = "3 Months"
    case sixMonths = "6 Months"
    case thisYear = "This Year"
    
    var title: String { self.rawValue }
}

struct ContentView: View {
    @StateObject private var appState = AppState()
    @StateObject private var notificationManager = NotificationManager()
    @State private var selectedTab: Tab = .home
    @State private var selectedAnalyticsPeriod: AnalyticsPeriod = .thisYear
    @State private var showSplash = true
    @State private var unitPrice: Double = 0.0
    @State private var unitPriceText: String = ""
    @State private var showSettingsAnalytics = false
    @State private var showSettingsProducts = false
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .edgesIgnoringSafeArea(.all)
            VStack {
                if showSplash {
                    SplashView()
                        .transition(.opacity)
                        .zIndex(10)
                } else {
                    TabView(selection: $selectedTab) {
                        NavigationStack {
                            ScrollView {
                                VStack(spacing: 12) {
                                    HeaderView()
                                        .environmentObject(notificationManager)
                                        .padding(.top, 16)
                                    
                                    VStack(spacing: 20) {
                                        InventoryHealthView()
                                        AIInsightsView()
                                        QuickActionsView()
                                        RecentProductsView()
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 90)
                            }
                            .background(Color(uiColor: .systemGray6))
                        }
                        .tag(Tab.home)
                        
                        NavigationStack {
                            ScrollView {
                                VStack(spacing: 20) {
                                    // Header з фільтрами
                                    HStack {
                                        Text("Analytics")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                        
                                        Spacer()
                                        
                                        Menu {
                                            ForEach(AnalyticsPeriod.allCases, id: \.self) { period in
                                                Button(period.title) {
                                                    selectedAnalyticsPeriod = period
                                                }
                                            }
                                        } label: {
                                            Image(systemName: "chevron.down")
                                                .foregroundColor(.gray)
                                        }
                                        .padding(.trailing, 8)
                                        
                                        // Profile Image
                                        Button(action: { showSettingsAnalytics = true }) {
                                            ZStack {
                                                Circle()
                                                .fill(
                                                    LinearGradient(
                                                        colors: [Color(hex: "FF6B6B"), Color(hex: "FF8E8E")],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    )
                                                )
                                                .frame(width: 32, height: 32)
                                                Text("VK")
                                                    .font(.system(size: 14, weight: .medium))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        .shadow(color: Color(hex: "FF6B6B").opacity(0.3), radius: 8, x: 0, y: 4)
                                        .sheet(isPresented: $showSettingsAnalytics) {
                                            SettingsView()
                                        }
                                    }
                                    
                                    // Період фільтрів
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 12) {
                                            ForEach(AnalyticsPeriod.allCases, id: \.self) { period in
                                                Button(action: {
                                                    if selectedAnalyticsPeriod != period {
                                                        selectedAnalyticsPeriod = period
                                                    }
                                                }) {
                                                    Text(period.title)
                                                        .font(.subheadline)
                                                        .padding(.horizontal, 18)
                                                        .padding(.vertical, 8)
                                                        .background(selectedAnalyticsPeriod == period ? Color.blue : Color.gray.opacity(0.1))
                                                        .foregroundColor(selectedAnalyticsPeriod == period ? .white : .gray)
                                                        .cornerRadius(20)
                                                }
                                            }
                                        }
                                        .padding(.vertical, 2)
                                    }
                                    
                                    // Статистика
                                    AnalyticsStatsView()
                                        .environmentObject(appState.productManager)
                                    
                                    // Sales Performance
                                    SalesPerformanceView(selectedPeriod: selectedAnalyticsPeriod)
                                        .environmentObject(appState.productManager)
                                    
                                    // Top Products
                                    TopProductsView()
                                        .environmentObject(appState.productManager)
                                    
                                    // Low Stock Alerts
                                    LowStockAlertsView()
                                        .environmentObject(appState.productManager)
                                }
                                .padding()
                                .padding(.bottom, 90)
                            }
                            .background(Color(uiColor: .systemGray6))
                        }
                        .tag(Tab.analytics)
                        
                        NavigationStack {
                            ProductsView()
                                .environmentObject(appState.productManager)
                                .environmentObject(notificationManager)
                        }
                        .tag(Tab.products)
                        
                        NavigationStack {
                            SettingsView()
                        }
                        .tag(Tab.settings)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    
                    TabBarView(selectedTab: $selectedTab)
                }
            }
            .padding(.top)
        }
        .background(Color(.systemGray6))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showSplash = false
                }
            }
        }
    }
}

// Тимчасові заглушки для інших екранів
struct HomeView: View {
    var body: some View {
        VStack(spacing: 20) {
            InventoryHealthView()
            AIInsightsView()
            QuickActionsView()
            RecentProductsView()
        }
        .padding()
    }
}

struct ProductsView: View {
    @EnvironmentObject var productManager: ProductManager
    @EnvironmentObject var notificationManager: NotificationManager
    @State private var searchText = ""
    @State private var showingAddProduct = false
    @State private var selectedProduct: ProductItem?
    @State private var showingPrediction = false
    @State private var editingProduct: ProductItem? = nil
    @State private var showSettingsProducts = false
    
    var filteredProducts: [ProductItem] {
        if searchText.isEmpty {
            return productManager.products
        } else {
            return productManager.products.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                HStack {
                    Text("Products")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: { showSettingsProducts = true }) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "FF6B6B"), Color(hex: "FF8E8E")],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 32, height: 32)
                            Text("VK")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .shadow(color: Color(hex: "FF6B6B").opacity(0.3), radius: 8, x: 0, y: 4)
                    .sheet(isPresented: $showSettingsProducts) {
                        SettingsView()
                    }
                }
                
                // Search Bar and Add Button
                HStack(spacing: 12) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Search products", text: $searchText)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .cornerRadius(12)
                    
                    // Add Button
                    Button(action: {
                        showingAddProduct = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.blue)
                            .frame(width: 38, height: 38)
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                }
                .frame(height: 38)
                
                // Products List
                if filteredProducts.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "box.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        Text("No products found")
                .font(.headline)
                .foregroundColor(.gray)
                        Text("Try adjusting your search or add a new product")
                            .font(.subheadline)
                            .foregroundColor(.gray.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                } else {
                    VStack(spacing: 16) {
                        ForEach(filteredProducts) { product in
                            ProductCard(product: product, onTap: {
                                selectedProduct = product
                            }, onDelete: {
                                productManager.deleteProduct(product)
                            }, onEdit: {
                                editingProduct = product
                            })
                        }
                    }
                }
            }
            .padding()
            .padding(.bottom, 90)
        }
        .background(Color(uiColor: .systemGray6))
        .sheet(isPresented: $showingAddProduct) {
            AddProductView()
                .environmentObject(notificationManager)
        }
        .sheet(item: $selectedProduct) { product in
            ProductDetailView(product: product)
        }
        .sheet(item: $editingProduct) { product in
            EditProductView(product: product) { updated in
                productManager.updateProduct(updated)
            }
        }
    }
}

struct ProductCard: View {
    let product: ProductItem
    let onTap: () -> Void
    let onDelete: () -> Void
    let onEdit: () -> Void
    @State private var showDeleteAlert = false
    @State private var showActions = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 16) {
                Text(product.emoji)
                    .font(.system(size: 40))
                    .frame(width: 60, height: 60)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                VStack(alignment: .leading, spacing: 8) {
                    Text(product.name)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    // Total sales і $/unit завжди в один ряд
                    HStack(alignment: .firstTextBaseline, spacing: 12) {
                        let totalSales = product.monthlySales.values.reduce(0, +)
                        Text("Total sales: \(totalSales) units")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .alignmentGuide(.firstTextBaseline) { d in d[.firstTextBaseline] }
                        Text(product.unitPrice > 0 ? "\(product.currency.symbol)\(String(format: "%.2f", product.unitPrice))/unit" : "")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .alignmentGuide(.firstTextBaseline) { d in d[.firstTextBaseline] }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer()
                // Кнопка "..." справа
                Button(action: { withAnimation { showActions.toggle() } }) {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .foregroundColor(.gray)
                        .padding(8)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            // Блок з кнопками, який розширює тільки низ картки
            if showActions {
                VStack {
                    HStack(spacing: 24) {
                        GlassButton(systemName: "pencil", color: .orange, action: { showActions = false; onEdit() }, size: 36)
                        GlassButton(systemName: "chart.line.uptrend.xyaxis", color: .blue, action: { showActions = false; onTap() }, size: 36)
                        GlassButton(systemName: "trash", color: .red, action: { showActions = false; showDeleteAlert = true }, size: 36)
                    }
                    .padding(.vertical, 10)
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(2)
            }
        }
        .background(Color.white)
        .cornerRadius(16)
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Delete product?"),
                message: Text("Are you sure you want to delete this product?"),
                primaryButton: .destructive(Text("Yes"), action: onDelete),
                secondaryButton: .cancel(Text("No"))
            )
        }
        .padding(.horizontal, 2)
        .animation(.easeInOut(duration: 0.18), value: showActions)
    }
}

struct GlassButton: View {
    let systemName: String
    let color: Color
    let action: () -> Void
    var size: CGFloat = 50
    @State private var pressed = false
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.12)) {
                pressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                pressed = false
                action()
            }
        }) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.5))
                    .background(.ultraThinMaterial, in: Circle())
                    .shadow(color: color.opacity(0.18), radius: 6, x: 0, y: 2)
                Image(systemName: systemName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(color)
            }
            .frame(width: pressed ? size - 4 : size, height: pressed ? size - 4 : size)
            .scaleEffect(pressed ? 0.92 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct AddProductView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var productManager: ProductManager
    @EnvironmentObject var notificationManager: NotificationManager
    @State private var productName = ""
    @State private var monthlySales: [String: Int] = [:]
    @State private var unitPrice: Double = 0.0
    @State private var unitPriceText: String = ""
    @State private var selectedCurrency: Currency = .usd
    @FocusState private var isNameFieldFocused: Bool
    @FocusState private var isPriceFieldFocused: Bool
    
    private let months = ["January", "February", "March", "April", "May", "June", 
                         "July", "August", "September", "October", "November", "December"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Product Name Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Product Name")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        TextField("Product Name", text: $productName)
                            .focused($isNameFieldFocused)
                            .textInputAutocapitalization(.words)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                    }
                    .padding(.horizontal)
                    
                    // Price Field and Currency
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Price")
                            .font(.headline)
                            .foregroundColor(.gray)
                        HStack(spacing: 12) {
                            // Price input
                            HStack {
                                Text(selectedCurrency.symbol)
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                TextField("0.00", text: $unitPriceText)
                                    .focused($isPriceFieldFocused)
                                    .keyboardType(.decimalPad)
                                    .onChange(of: unitPriceText) { newValue in
                                        // Очищення нецифрових символів
                                        let filtered = newValue.filter { "0123456789.".contains($0) }
                                        if filtered != newValue {
                                            unitPriceText = filtered
                                        }
                                        // Оновлення Double
                                        unitPrice = Double(filtered) ?? 0.0
                                    }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                            .frame(maxWidth: .infinity)
                            
                            // Currency selector
                            Picker("", selection: $selectedCurrency) {
                                ForEach(Currency.allCases, id: \.self) { currency in
                                    Text(currency.symbol).tag(currency)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .frame(width: 80)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Monthly Sales Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Monthly Sales Data (2024)")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        VStack(spacing: 16) {
                            ForEach(months, id: \.self) { month in
                                HStack {
                                    Text(month)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.black)
                                        .frame(width: 100, alignment: .leading)
                                    
                                    Spacer()
                                    
                                    HStack(spacing: 12) {
                                        Button(action: {
                                            monthlySales[month] = max(0, (monthlySales[month] ?? 0) - 1)
                                        }) {
                                            Image(systemName: "minus.circle.fill")
                                                .foregroundColor(.red)
                                                .font(.system(size: 26))
                                        }
                                        
                                        TextField("0", text: Binding(
                                            get: { 
                                                if let sales = monthlySales[month], sales > 0 {
                                                    return "\(sales)"
                                                } else {
                                                    return ""
                                                }
                                            },
                                            set: { 
                                                if let value = Int($0) {
                                                    monthlySales[month] = value
                                                } else {
                                                    monthlySales[month] = 0
                                                }
                                            }
                                        ))
                                        .keyboardType(.numberPad)
                                        .multilineTextAlignment(.center)
                                        .frame(width: 60)
                                        .padding(.vertical, 8)
                                        .background(Color.white)
                                        .cornerRadius(8)
                                        
                                        Button(action: {
                                            monthlySales[month] = (monthlySales[month] ?? 0) + 1
                                        }) {
                                            Image(systemName: "plus.circle.fill")
                                                .foregroundColor(.green)
                                                .font(.system(size: 26))
                                        }
                                    }
                                    
                                    Text("units")
                                        .font(.system(size: 14))
                                }
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white)
                                        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                                )
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Add New Product")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        unitPriceText = ""
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let totalQuantity = monthlySales.values.reduce(0, +)
                        let newProduct = ProductItem(
                            name: productName, 
                            monthlySales: monthlySales, 
                            unitPrice: unitPrice,
                            currency: selectedCurrency
                        )
                        productManager.addProduct(newProduct)
                        sendProductNotification(name: productName, quantity: totalQuantity, price: unitPrice, currency: selectedCurrency)
                        unitPriceText = ""
                        dismiss()
                    }
                    .disabled(productName.isEmpty)
                }
            }
        }
    }
    
    private func priceFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    private func sendProductNotification(name: String, quantity: Int, price: Double, currency: Currency) {
        let content = UNMutableNotificationContent()
        content.title = "New product added"
        content.body = "Name: \(name) | Quantity: \(quantity) units | Price: \(currency.symbol)\(String(format: "%.2f", price)) per unit"
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        let emoji = ProductItem.findEmoji(for: name)
        notificationManager.add(AppNotification(title: content.title, body: content.body, productEmoji: emoji))
    }
}

struct ProductDetailView: View {
    let product: ProductItem
    @EnvironmentObject var productManager: ProductManager
    @Environment(\.dismiss) var dismiss
    @State private var predictedDemand: [String: Int] = [:]
    
    private let months = ["January", "February", "March", "April", "May", "June", 
                         "July", "August", "September", "October", "November", "December"]
    
    private var totalYearlyDemand: Int {
        predictedDemand.values.reduce(0, +)
    }
    
    private var averageMonthlyDemand: Int {
        totalYearlyDemand / 12
    }
    
    private var bestSellingMonth: (month: String, sales: Int) {
        product.monthlySales.max { $0.value < $1.value } ?? ("N/A", 0)
    }
    
    private var totalRevenue: Double {
        Double(totalYearlyDemand) * product.unitPrice
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Product Info Block
                    VStack(spacing: 0) {
                        HStack(spacing: 16) {
                            Text(product.emoji)
                                .font(.system(size: 60))
                                .frame(width: 80, height: 80)
                                .background(Color.white)
                                .cornerRadius(16)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(product.name)
                                    .font(.system(size: 34, weight: .bold))
                                    .foregroundColor(.primary)
                                
                                if product.unitPrice > 0 {
                                    Text("\(product.currency.symbol)\(String(format: "%.2f", product.unitPrice)) per unit")
                                        .font(.headline)
                                        .foregroundColor(.blue)
                }
            }
                            
                            Spacer()
        }
        .padding()
        .background(Color.white)
                        .cornerRadius(16)
                    }
                    .cornerRadius(16)
                    
                    // Forecast Stats Block
                    VStack(spacing: 16) {
                        Text("Total Forecast for Next Year")
                    .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Total Units Needed")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text("\(totalYearlyDemand)")
                                    .font(.system(size: 34, weight: .bold))
                                
                                Text("units/year")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(16)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Average Monthly")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text("\(averageMonthlyDemand)")
                                    .font(.system(size: 34, weight: .bold))
                                
                                Text("units/month")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(16)
    }
    
                        if product.unitPrice > 0 {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Projected Revenue")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text("\(product.currency.symbol)\(String(format: "%.2f", totalRevenue))")
                                    .font(.system(size: 34, weight: .bold))
                                    .foregroundColor(.blue)
                                
                                Text("based on current unit price")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(16)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Best Selling Month")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            HStack(alignment: .firstTextBaseline, spacing: 8) {
                                Text(bestSellingMonth.month)
                                    .font(.system(size: 34, weight: .bold))
                                
                                Text("with")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text("\(bestSellingMonth.sales)")
                                    .font(.system(size: 34, weight: .bold))
                                
                                Text("units")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(16)
                    }
                    .padding()
                    .background(Color(uiColor: .systemGray6))
                    .cornerRadius(16)
                    
                    // Sales Performance Block
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Sales Performance")
                    .font(.headline)
                        
                        Chart {
                            ForEach(months, id: \.self) { month in
                                BarMark(
                                    x: .value("Month", month),
                                    y: .value("Sales", product.monthlySales[month] ?? 0)
                                )
                                .foregroundStyle(Color.blue.gradient)
                            }
                        }
                        .frame(height: 200)
                    }
            .padding()
                    .background(Color(uiColor: .systemGray6))
                    .cornerRadius(16)
                    
                    // Quarterly Forecast Block
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Quarterly Forecast")
                    .font(.headline)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(0..<4) { quarter in
                                let startIdx = quarter * 3
                                let quarterMonths = Array(months[startIdx..<startIdx+3])
                                let totalDemand = quarterMonths.reduce(0) { $0 + (predictedDemand[$1] ?? 0) }
                                let averageQuarterDemand = totalDemand / 3
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Q\(quarter + 1)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    Text("\(totalDemand)")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    Text("Average: \(averageQuarterDemand)/month")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color(UIColor.systemBackground))
                                .cornerRadius(12)
                            }
                        }
                        
                        Chart {
                            ForEach(months, id: \.self) { month in
                                LineMark(
                                    x: .value("Month", month),
                                    y: .value("Demand", predictedDemand[month] ?? 0)
                                )
                                .foregroundStyle(Color.green.gradient)
                            }
                            
                            RuleMark(y: .value("Average", averageMonthlyDemand))
                                .foregroundStyle(.orange)
                                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
                                .annotation(position: .top, alignment: .leading) {
                                    Text("Monthly Average: \(averageMonthlyDemand)")
                                        .font(.caption)
                                        .foregroundColor(.orange)
                                }
                        }
                        .frame(height: 200)
                    }
                    .padding()
                    .background(Color(uiColor: .systemGray6))
                    .cornerRadius(16)
                }
                .padding()
            }
            .background(Color(uiColor: .systemGray6))
            .navigationBarHidden(true)
            .onAppear {
                predictedDemand = productManager.predictDemand(for: product)
    }
        }
    }
}

struct InsightCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct SettingsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                HStack {
                    Text("Settings")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    // Profile Image
                    ZStack {
                        Circle()
                            .fill(
                LinearGradient(
                                    colors: [Color(hex: "FF6B6B"), Color(hex: "FF8E8E")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 32, height: 32)
                        
                        Text("VK")
                            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.white)
                    }
                    .shadow(color: Color(hex: "FF6B6B").opacity(0.3), radius: 8, x: 0, y: 4)
                }
                
                // Profile Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Profile")
                    .font(.headline)
                    
                    VStack(spacing: 12) {
                        SettingsRow(icon: "person.fill", title: "Account", subtitle: "Viktor Kizera")
                        SettingsRow(icon: "envelope.fill", title: "Email", subtitle: "viktorkizera@gmail.com")
                        SettingsRow(icon: "building.2.fill", title: "Company", subtitle: "SmartStock Inc.")
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                
                // App Settings
                VStack(alignment: .leading, spacing: 16) {
                    Text("App Settings")
                        .font(.headline)
                    
                    VStack(spacing: 12) {
                        SettingsToggleRow(icon: "bell.fill", title: "Notifications", subtitle: "Get alerts about stock levels")
                        SettingsToggleRow(icon: "chart.line.uptrend.xyaxis", title: "Analytics", subtitle: "Enable AI-powered insights")
                        SettingsToggleRow(icon: "icloud.fill", title: "Auto Backup", subtitle: "Backup data every 24 hours")
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                
                // Preferences
                VStack(alignment: .leading, spacing: 16) {
                    Text("Preferences")
                        .font(.headline)
                    
                    VStack(spacing: 12) {
                        SettingsRow(icon: "globe", title: "Language", subtitle: "English (US)")
                        SettingsRow(icon: "dollarsign.circle.fill", title: "Currency", subtitle: "USD ($)")
                        SettingsRow(icon: "clock.fill", title: "Time Zone", subtitle: "UTC+02:00")
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                
                // Support & About
                VStack(alignment: .leading, spacing: 16) {
                    Text("Support & About")
                        .font(.headline)
                    
                    VStack(spacing: 12) {
                        SettingsRow(icon: "questionmark.circle.fill", title: "Help Center", subtitle: "Get help and support")
                        SettingsRow(icon: "doc.text.fill", title: "Terms of Service", subtitle: "Read our terms")
                        SettingsRow(icon: "lock.fill", title: "Privacy Policy", subtitle: "Learn about your data")
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                
                // Version Info
                HStack {
                    Text("Version 1.0.0")
                        .font(.footnote)
                    .foregroundColor(.gray)
                
                    Spacer()
                    
                    Button(action: {}) {
                        Text("Check for Updates")
                            .font(.footnote)
                        .foregroundColor(.blue)
                    }
                }
                .padding(.top, 8)
            }
            .padding()
            .padding(.bottom, 90)
        }
        .background(Color(uiColor: .systemGray6))
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.blue)
                .frame(width: 32, height: 32)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                        .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(subtitle)
                    .font(.caption)
                        .foregroundColor(.gray)
                }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
                .padding()
        .background(Color(uiColor: .systemGray6))
        .cornerRadius(12)
    }
}

struct SettingsToggleRow: View {
    let icon: String
    let title: String
    let subtitle: String
    @State private var isEnabled = true
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.blue)
                .frame(width: 32, height: 32)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            
                VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(subtitle)
                    .font(.caption)
                        .foregroundColor(.gray)
            }
            
            Spacer()
            
            Toggle("", isOn: $isEnabled)
                .labelsHidden()
        }
            .padding()
        .background(Color(uiColor: .systemGray6))
        .cornerRadius(12)
    }
}

struct AnalyticsStatsView: View {
    @EnvironmentObject var productManager: ProductManager
    var mainCurrencySymbol: String {
        let all = productManager.products.map { $0.currency.symbol }
        return Set(all).count == 1 ? (all.first ?? "$") : "$"
    }
    var totalProducts: Int {
        productManager.products.reduce(0) { $0 + $1.monthlySales.values.reduce(0, +) }
    }
    var stockValue: Double {
        productManager.products.reduce(0) { $0 + Double($1.monthlySales.values.reduce(0, +)) * $1.unitPrice }
    }
    var body: some View {
        HStack(spacing: 16) {
            VStack(spacing: 12) {
                Spacer(minLength: 8)
                Image(systemName: "cube.box.fill")
                    .font(.system(size: 28))
                        .foregroundColor(.blue)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(Color.blue.opacity(0.12)))
                Text("Total Products")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("\(totalProducts.formatted(.number.grouping(.automatic)))")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.black)
                    .minimumScaleFactor(0.7)
                Spacer(minLength: 8)
            }
            .frame(maxWidth: .infinity, minHeight: 120)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
            
            VStack(spacing: 12) {
                Spacer(minLength: 8)
                Image(systemName: "dollarsign.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.green)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(Color.green.opacity(0.12)))
                Text("Stock Value")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("\(mainCurrencySymbol)\(stockValue >= 1000 ? String(format: "%.1fk", stockValue/1000) : String(format: "%.2f", stockValue))")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.black)
                    .minimumScaleFactor(0.7)
                Spacer(minLength: 8)
            }
            .frame(maxWidth: .infinity, minHeight: 120)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
        }
    }
}

struct SalesPerformanceView: View {
    @EnvironmentObject var productManager: ProductManager
    var selectedPeriod: AnalyticsPeriod
    @State private var selectedType: SalesType = .actual

    enum SalesType: String, CaseIterable { case actual = "Actual", forecast = "Forecast" }
    
    let allMonths: [String] = [
        "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
    ]
    
    // Обчислюємо місяці для графіка, починаючи з поточного
    var months: [String] {
        // Отримуємо поточну дату
        let now = Date()
        // Визначаємо індекс поточного місяця (0-11)
        let currentMonthIndex = Calendar.current.component(.month, from: now) - 1
        // Визначаємо кількість місяців для відображення в залежності від вибраного періоду
        let monthsCount: Int
        switch selectedPeriod {
        case .thisMonth: monthsCount = 1
        case .threeMonths: monthsCount = 3
        case .sixMonths: monthsCount = 6
        case .thisYear: monthsCount = 12
        }
        // Формуємо список місяців, починаючи з поточного
        var result: [String] = []
        for i in 0..<monthsCount {
            // Обчислюємо індекс місяця з урахуванням циклічності (0-11)
            let idx = (currentMonthIndex + i) % 12
            // Додаємо назву місяця до результату
            result.append(allMonths[idx])
        }
        return result
    }
    
    // Сума продажів по кожному місяцю для всіх товарів
    var actualData: [Double] {
        months.map { month in
            Double(productManager.products.reduce(0) { $0 + ($1.monthlySales[month] ?? 0) })
        }
    }
    
    // Forecast: для кожного місяця — сума продажів по всіх товарах за цей місяць * 1.1
    var forecastData: [Double] {
        months.map { month in
            let sum = productManager.products.reduce(0) { $0 + ($1.monthlySales[month] ?? 0) }
            return Double(sum) * 1.1
        }
    }
    
    var chartData: [Double] {
        selectedType == .actual ? actualData : forecastData
    }
    
    var chartColor: Color {
        selectedType == .actual ? .blue : .purple
    }
    
    // Винесені обчислення для logData та maxLog
    var logData: [Double] {
        chartData.map { $0 > 0 ? log10($0) : 0 }
    }
    
    var maxLog: Double {
        logData.max() ?? 1
    }
    
    func formattedValue(_ value: Double) -> String {
        if value >= 1000 {
            return String(format: "%.1fk", value/1000)
        } else {
            return String(Int(round(value)))
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Sales Performance")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                HStack(spacing: 8) {
                    ForEach(SalesType.allCases, id: \.self) { type in
                        Button(action: { selectedType = type }) {
                            Text(type.rawValue)
                                .font(.subheadline)
                                .frame(width: 80)
                                .padding(.vertical, 8)
                                .background(selectedType == type ? (type == .actual ? Color.blue : Color.purple) : Color.gray.opacity(0.1))
                                .foregroundColor(selectedType == type ? .white : .gray)
                                .cornerRadius(20)
                        }
                    }
                }
            }
            .padding(.bottom, 4)
            GeometryReader { geo in
                let barCount = CGFloat(months.count)
                let barSpacing: CGFloat = 8
                let barWidth: CGFloat = 28 // фіксована ширина для всіх режимів
                let chartHeight = geo.size.height - 36
                Group {
                    if months.count > 6 {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(alignment: .bottom, spacing: barSpacing) {
                                ForEach(0..<months.count, id: \.self) { idx in
                                    let value = chartData[idx]
                                    let logValue = logData[idx]
                                    VStack(spacing: 0) {
                                        Text(formattedValue(value))
                                .font(.caption2)
                                            .foregroundColor(chartColor)
                                            .frame(height: 16)
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(chartColor)
                                            .frame(
                                                width: barWidth,
                                                height: value > 0 && maxLog > 0 ? max(8, CGFloat(logValue) / CGFloat(maxLog) * chartHeight) : 8
                                            )
                                        Text(months[idx].prefix(3))
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                            .frame(width: barWidth, height: 36, alignment: .center)
                                            .rotationEffect(.degrees(-45))
                                            .lineLimit(1)
                                    }
                                    .frame(width: barWidth, alignment: .bottom)
                                }
                            }
                            .padding(.horizontal, 8)
                            .frame(height: geo.size.height)
                        }
                    } else {
                        HStack(alignment: .bottom, spacing: barSpacing) {
                            ForEach(0..<months.count, id: \.self) { idx in
                                let value = chartData[idx]
                                let logValue = logData[idx]
                                VStack(spacing: 0) {
                                    Text(formattedValue(value))
                                    .font(.caption2)
                                        .foregroundColor(chartColor)
                                        .frame(height: 16)
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(chartColor)
                                        .frame(
                                            width: barWidth,
                                            height: value > 0 && maxLog > 0 ? max(8, CGFloat(logValue) / CGFloat(maxLog) * chartHeight) : 8
                                        )
                                    Text(months[idx].prefix(3))
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                        .frame(width: barWidth, height: 36, alignment: .center)
                                        .rotationEffect(.degrees(-45))
                                        .lineLimit(1)
                                }
                                .frame(width: barWidth, alignment: .bottom)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    }
                }
            }
            .frame(height: 300)
            }
            .padding()
            .background(Color.white)
        .cornerRadius(16)
    }
}

struct EditProductView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var productManager: ProductManager
    @State var product: ProductItem
    var onSave: (ProductItem) -> Void
    private let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Product Name")
                            .font(.headline)
                            .foregroundColor(.gray)
                        TextField("Product Name", text: $product.name)
        .padding()
        .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                    }
                    .padding(.horizontal)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Price")
                            .font(.headline)
                            .foregroundColor(.gray)
                        HStack(spacing: 12) {
                            HStack {
                                Text(product.currency.symbol)
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                TextField("", value: $product.unitPrice, formatter: priceFormatter())
                                    .keyboardType(.decimalPad)
                                Spacer()
                            }
            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                            .frame(maxWidth: .infinity)
                            Picker("", selection: $product.currency) {
                                ForEach(Currency.allCases, id: \.self) { currency in
                                    Text(currency.symbol).tag(currency)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .frame(width: 80)
                        }
                    }
                    .padding(.horizontal)
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Monthly Sales Data (2024)")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        VStack(spacing: 16) {
                            ForEach(months, id: \.self) { month in
                                HStack {
                                    Text(month)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.black)
                                        .frame(width: 100, alignment: .leading)
                                    Spacer()
                                    HStack(spacing: 12) {
                                        Button(action: {
                                            product.monthlySales[month] = max(0, (product.monthlySales[month] ?? 0) - 1)
                                        }) {
                                            Image(systemName: "minus.circle.fill")
                                                .foregroundColor(.red)
                                                .font(.system(size: 26))
                                        }
                                        ZStack(alignment: .center) {
                                            TextField("0", text: Binding(
                                                get: {
                                                    if let sales = product.monthlySales[month], sales > 0 {
                                                        return "\(sales)"
                                                    } else {
                                                        return ""
                                                    }
                                                },
                                                set: {
                                                    if let value = Int($0) {
                                                        product.monthlySales[month] = value
                                                    } else {
                                                        product.monthlySales[month] = 0
                                                    }
                                                }
                                            ))
                                            .multilineTextAlignment(.center)
                                            .keyboardType(.numberPad)
                                            .font(.system(size: 16, weight: .medium))
                                            .frame(width: 60)
                                            .background(Color(.systemBackground))
                                            .cornerRadius(8)
                                        }
                                        Button(action: {
                                            product.monthlySales[month] = (product.monthlySales[month] ?? 0) + 1
                                        }) {
                                            Image(systemName: "plus.circle.fill")
                                                .foregroundColor(.green)
                                                .font(.system(size: 26))
                                        }
                                    }
                                    Text("units")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                        .frame(width: 40, alignment: .trailing)
                                }
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white)
                                        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                                )
                            }
                        }
                    }
            .padding()
                }
            }
            .navigationTitle("Edit Product")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave(product)
                        dismiss()
                    }
                }
            }
        }
    }
    private func priceFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
}

struct TopProductsView: View {
    @EnvironmentObject var productManager: ProductManager
    @State private var showAll = false
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Top Products")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                Button("View All") {
                    showAll = true
                }
                .foregroundColor(.blue)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(productManager.products) { product in
                        TopProductCard(product: product)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .sheet(isPresented: $showAll) {
            TopProductsListView()
                .environmentObject(productManager)
        }
    }
}

struct TopProductCard: View {
    let product: ProductItem
    var totalSales: Int { product.monthlySales.values.reduce(0, +) }
    var status: (String, Color) {
        if totalSales > 500 {
            return ("High", Color.green)
        } else if totalSales >= 50 {
            return ("Medium", Color.yellow)
        } else {
            return ("Low", Color.red)
        }
    }
    var body: some View {
        VStack(spacing: 10) {
            Text(product.emoji)
                .font(.system(size: 36))
                .frame(width: 50, height: 50)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            Text(product.name)
                .font(.headline)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(maxWidth: 90)
            Text("\(totalSales.formatted(.number.grouping(.automatic))) units sold")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(status.0)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(status.1.opacity(0.12))
                .foregroundColor(status.1)
                .cornerRadius(12)
        }
        .frame(width: 120, height: 160)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
}

struct TopProductsListView: View {
    @EnvironmentObject var productManager: ProductManager
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            List(productManager.products) { product in
                TopProductListRow(product: product)
            }
            .listStyle(.plain)
            .navigationTitle("All Products")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct TopProductListRow: View {
    let product: ProductItem
    var totalSales: Int { product.monthlySales.values.reduce(0, +) }
    var status: (String, Color) {
        if totalSales > 500 {
            return ("High", Color.green)
        } else if totalSales >= 50 {
            return ("Medium", Color.yellow)
        } else {
            return ("Low", Color.red)
        }
    }
    var body: some View {
        HStack(spacing: 16) {
            Text(product.emoji)
                .font(.system(size: 32))
                .frame(width: 44, height: 44)
                .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.headline)
                Text("\(totalSales.formatted(.number.grouping(.automatic))) units sold")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text(status.0)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(status.1.opacity(0.12))
                .foregroundColor(status.1)
                .cornerRadius(12)
        }
        .padding(.vertical, 4)
    }
}

struct LowStockAlertsView: View {
    @EnvironmentObject var productManager: ProductManager
    @State private var showAll = false
    @State private var selectedProduct: ProductItem? = nil
    var lowStockProducts: [ProductItem] {
        productManager.products.filter { $0.monthlySales.values.reduce(0, +) < 10 }
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Low Stock Alerts")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                Button("View All") {
                    showAll = true
                }
                .foregroundColor(.blue)
            }
            VStack(spacing: 12) {
                ForEach(lowStockProducts) { product in
                    Button(action: { selectedProduct = product }) {
                        LowStockAlertRow(product: product)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .sheet(isPresented: $showAll) {
            LowStockAlertsListView(products: lowStockProducts)
        }
        .sheet(item: $selectedProduct) { product in
            ProductDetailView(product: product)
                .environmentObject(productManager)
        }
    }
}

struct LowStockAlertRow: View {
    let product: ProductItem
    var totalSales: Int { product.monthlySales.values.reduce(0, +) }
    var body: some View {
        HStack(spacing: 16) {
            Text(product.emoji)
                .font(.system(size: 36))
                .frame(width: 50, height: 50)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            VStack(alignment: .leading, spacing: 6) {
                Text(product.name)
                    .font(.headline)
                    .fontWeight(.medium)
                Text("Only sold \(totalSales) units")
                    .font(.subheadline)
                    .foregroundColor(.red)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.system(size: 20, weight: .semibold))
        }
        .padding(18)
        .background(Color.red.opacity(0.07))
        .cornerRadius(20)
    }
}

struct LowStockAlertsListView: View {
    let products: [ProductItem]
    @Environment(\.dismiss) var dismiss
    @State private var selectedProduct: ProductItem? = nil
    var body: some View {
        NavigationView {
            List(products) { product in
                Button(action: { selectedProduct = product }) {
                    LowStockAlertRow(product: product)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .listStyle(.plain)
            .navigationTitle("Low Stock Alerts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(item: $selectedProduct) { product in
                ProductDetailView(product: product)
            }
        }
    }
}

struct SplashView: View {
    @State private var animate = false
    @State private var progress: Double = 0
    let progressSteps: [Double] = [0, 0.1, 0.4, 0.65, 0.85, 1.0]
    let stepDelays: [Double] = [0, 0.3, 0.45, 0.35, 0.25, 0.2] // seconds between steps
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            VStack(spacing: 24) {
                Text("📦")
                    .font(.system(size: 80))
                    .scaleEffect(animate ? 1.1 : 0.8)
                    .opacity(animate ? 1 : 0.7)
                    .shadow(color: Color.accentColor.opacity(0.18), radius: 16, x: 0, y: 8)
                    .animation(.easeInOut(duration: 0.7).repeatForever(autoreverses: true), value: animate)
                Text("SmartStock")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(Color.accentColor)
                    .opacity(animate ? 1 : 0.7)
                    .animation(.easeInOut(duration: 0.7).repeatForever(autoreverses: true), value: animate)
                VStack(spacing: 10) {
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color(.systemGray5))
                            .frame(height: 10)
                        Capsule()
                            .fill(Color.accentColor)
                            .frame(width: CGFloat(progress) * 220, height: 10)
                            .animation(.easeInOut(duration: 0.3), value: progress)
                    }
                    .frame(width: 220)
                    Text("Завантаження: \(Int(progress * 100))%")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .monospacedDigit()
                }
            }
            .padding(.top, 8)
            .padding(.bottom, 8)
        }
        .onAppear {
            animate = true
            // Анімація стрибками
            var delay: Double = 0
            for (idx, step) in progressSteps.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        progress = step
                    }
                }
                if idx < stepDelays.count { delay += stepDelays[idx] }
            }
        }
    }
}

#Preview {
    ContentView()
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
