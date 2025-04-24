//
//  ContentView.swift
//  SmartStock
//
//  Created by Viktor Kizera on 3/25/25.
//

import SwiftUI
import Charts

// Оголошуємо екземпляр ProductManager на рівні програми для спільного доступу
class AppState: ObservableObject {
    @Published var productManager = ProductManager()
}

enum AnalyticsPeriod: String, CaseIterable, Equatable {
    case thisMonth = "This Month"
    case lastMonth = "Last Month"
    case last3Months = "Last 3 Months"
    
    var title: String { self.rawValue }
}

struct ContentView: View {
    @StateObject private var appState = AppState()
    @State private var selectedTab: Tab = .home
    @State private var selectedAnalyticsPeriod: AnalyticsPeriod = .thisMonth
    
    var totalProducts: Int {
        appState.productManager.products.reduce(0) { $0 + $1.monthlySales.values.reduce(0, +) }
    }
    
    var stockValue: Double {
        appState.productManager.products.reduce(0) { $0 + Double($1.monthlySales.values.reduce(0, +)) * $1.unitPrice }
    }
    
    var mainCurrencySymbol: String {
        // Якщо всі товари в одній валюті — показуємо її, інакше $ за замовчуванням
        let all = appState.productManager.products.map { $0.currency.symbol }
        return Set(all).count == 1 ? (all.first ?? "$") : "$"
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
        NavigationStack {
            ScrollView {
                        VStack(spacing: 12) {
                            HeaderView()
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
                            
                            // Період фільтрів
                            HStack(spacing: 12) {
                                ForEach(AnalyticsPeriod.allCases, id: \.self) { period in
                                    Button(action: {
                                        selectedAnalyticsPeriod = period
                                    }) {
                                        Text(period.title)
                                            .font(.subheadline)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(selectedAnalyticsPeriod == period ? Color.blue : Color.gray.opacity(0.1))
                                            .foregroundColor(selectedAnalyticsPeriod == period ? .white : .gray)
                                            .cornerRadius(20)
                                    }
                                }
                            }
                            
                            // Статистика
                            HStack(spacing: 12) {
                                // Total Products
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Total Products")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    Text("\(totalProducts.formatted(.number.grouping(.automatic)))")
                                        .font(.title)
                                        .fontWeight(.bold)
                                    
                                    // Можна додати динаміку, якщо потрібно
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .cornerRadius(16)
                                
                                // Stock Value
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Stock Value")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    Text("\(mainCurrencySymbol)\(stockValue >= 1000 ? String(format: "%.1fk", stockValue/1000) : String(format: "%.2f", stockValue))")
                                        .font(.title)
                                        .fontWeight(.bold)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .cornerRadius(16)
                            }
                            
                            // Sales Performance
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Sales Performance")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                
                                HStack(spacing: 16) {
                                    Button(action: {}) {
                                        Text("Actual")
                                            .font(.subheadline)
                                            .foregroundColor(.blue)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(Color.blue.opacity(0.1))
                                            .cornerRadius(20)
                                    }
                                    
                                    Button(action: {}) {
                                        Text("Forecast")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(Color.gray.opacity(0.1))
                                            .cornerRadius(20)
                                    }
                                }
                                
                                // Тут буде графік
                                Rectangle()
                                    .fill(Color.gray.opacity(0.1))
                                    .frame(height: 200)
                                    .cornerRadius(16)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                            
                            // Top Products
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("Top Products")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                    
                                    Spacer()
                                    
                                    Button("View All") {
                                        // Action
                                    }
                                    .foregroundColor(.blue)
                                }
                                
                                HStack(spacing: 12) {
                                    // Product 1
                                    VStack(alignment: .leading, spacing: 8) {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.gray.opacity(0.1))
                                            .frame(width: 50, height: 50)
                                        
                                        Text("Product Name")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                        
                                        Text("1,234 units sold")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        
                                        Text("In Stock")
                                            .font(.caption)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.green.opacity(0.1))
                                            .foregroundColor(.green)
                                            .cornerRadius(12)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(16)
                                    
                                    // Product 2
                                    VStack(alignment: .leading, spacing: 8) {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.gray.opacity(0.1))
                                            .frame(width: 50, height: 50)
                                        
                                        Text("Product Name")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                        
                                        Text("987 units sold")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        
                                        Text("Low Stock")
                                            .font(.caption)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.orange.opacity(0.1))
                                            .foregroundColor(.orange)
                                            .cornerRadius(12)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(16)
                                }
                            }
                            
                            // Low Stock Alerts
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("Low Stock Alerts")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                    
                                    Spacer()
                                    
                                    Button("View All") {
                                        // Action
                                    }
                                    .foregroundColor(.blue)
                                }
                                
                                VStack(spacing: 12) {
                                    ForEach(["Product Name", "Product Name"], id: \.self) { product in
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text(product)
                                                    .font(.subheadline)
                                                    .fontWeight(.medium)
                                                Text("Only \(product == "Product Name" ? "5" : "8") units left")
                                                    .font(.caption)
                                                    .foregroundColor(.red)
                                            }
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                                        }
                                        .padding()
                                        .background(Color.red.opacity(0.05))
                                        .cornerRadius(12)
                                    }
                                }
                            }
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
        .background(Color(uiColor: .systemGray6))
        .ignoresSafeArea()
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
    // Використовуємо спільний екземпляр ProductManager
    @EnvironmentObject var productManager: ProductManager
    @State private var searchText = ""
    @State private var showingAddProduct = false
    @State private var selectedProduct: ProductItem?
    @State private var showingPrediction = false
    
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
                            ProductCard(product: product) {
                                selectedProduct = product
                            } onDelete: {
                                productManager.deleteProduct(product)
                            }
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
        }
        .sheet(item: $selectedProduct) { product in
            ProductDetailView(product: product)
        }
    }
}

struct ProductCard: View {
    let product: ProductItem
    let onTap: () -> Void
    let onDelete: () -> Void
    @State private var showDeleteAlert = false
    
    var body: some View {
        HStack(spacing: 16) {
            Text(product.emoji)
                .font(.system(size: 40))
                .frame(width: 60, height: 60)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(product.name)
                    .font(.headline)
                
                let totalSales = product.monthlySales.values.reduce(0, +)
                Text("Total sales: \(totalSales) units")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                if product.unitPrice > 0 {
                    Text("\(product.currency.symbol)\(String(format: "%.2f", product.unitPrice))/unit")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            
            Spacer()
            
            Button(action: onTap) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundColor(.blue)
                    .padding(8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
            
            Button(action: { showDeleteAlert = true }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .padding(8)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
            }
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Delete product?"),
                    message: Text("Are you sure you want to delete this product?"),
                    primaryButton: .destructive(Text("Yes"), action: onDelete),
                    secondaryButton: .cancel(Text("No"))
                )
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
    }
}

struct AddProductView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var productManager: ProductManager
    @State private var productName = ""
    @State private var monthlySales: [String: Int] = [:]
    @State private var unitPrice: Double = 0.0
    @State private var selectedCurrency: Currency = .usd
    
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
                                
                                ZStack(alignment: .leading) {
                                    if unitPrice == 0 {
                                        Text("0.00")
                                            .foregroundColor(.gray.opacity(0.5))
                                    }
                                    
                                    TextField("", value: $unitPrice, formatter: priceFormatter())
                                        .keyboardType(.decimalPad)
                                }
                                
                                Spacer()
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
                                    // Назва місяця зліва
                        Text(month)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.black)
                            .frame(width: 100, alignment: .leading)
                        
                        Spacer()
                        
                                    // Контроли редагування кількості
                                    HStack(spacing: 12) {
                            Button(action: {
                                            monthlySales[month] = max(0, (monthlySales[month] ?? 0) - 1)
                            }) {
                                Image(systemName: "minus.circle.fill")
                                                .foregroundColor(.red)
                                                .font(.system(size: 26))
                            }
                            
                                        ZStack(alignment: .center) {
                                            // Використовуємо простіший підхід
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
                                .multilineTextAlignment(.center)
                                            .keyboardType(.numberPad)
                                            .font(.system(size: 16, weight: .medium))
                                            .frame(width: 60)
                                            .background(Color(.systemBackground))
                                            .cornerRadius(8)
                                        }
                            
                            Button(action: {
                                            monthlySales[month] = (monthlySales[month] ?? 0) + 1
                            }) {
                                Image(systemName: "plus.circle.fill")
                                                .foregroundColor(.green)
                                                .font(.system(size: 26))
                                        }
                                    }
                                    
                                    // Units справа
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
                    }
                .padding()
            }
            .navigationTitle("Add New Product")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newProduct = ProductItem(
                            name: productName, 
                            monthlySales: monthlySales, 
                            unitPrice: unitPrice,
                            currency: selectedCurrency
                        )
                        productManager.addProduct(newProduct)
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
