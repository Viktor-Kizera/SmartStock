//
//  ContentView.swift
//  SmartStock
//
//  Created by Viktor Kizera on 3/25/25.
//

import SwiftUI
import Charts

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
        NavigationStack {
            ScrollView {
                        VStack(spacing: 12) {
                            HeaderView()
                                .padding(.top, 8)
                            
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
                    .edgesIgnoringSafeArea(.top)
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
                                    Button("This Month", action: {})
                                    Button("Last Month", action: {})
                                    Button("Last 3 Months", action: {})
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
                                ForEach(["This Month", "Last Month", "Last 3 Months"], id: \.self) { period in
                                    Button(action: {}) {
                                        Text(period)
                                            .font(.subheadline)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(period == "This Month" ? Color.blue : Color.gray.opacity(0.1))
                                            .foregroundColor(period == "This Month" ? .white : .gray)
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
                                    
                                    Text("2,618")
                                        .font(.title)
                                        .fontWeight(.bold)
                                    
                                    HStack {
                                        Image(systemName: "arrow.up.right")
                                            .foregroundColor(.green)
                                        Text("12% vs last month")
                                            .font(.caption)
                                            .foregroundColor(.green)
                                    }
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
                                    
                                    Text("$124.5k")
                                        .font(.title)
                                        .fontWeight(.bold)
                                    
                                    HStack {
                                        Image(systemName: "arrow.up.right")
                                            .foregroundColor(.green)
                                        Text("8% vs last month")
                                            .font(.caption)
                                            .foregroundColor(.green)
                                    }
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
    @StateObject private var productManager = ProductManager()
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
                    
                    Button(action: {
                        showingAddProduct = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    
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
                
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search products", text: $searchText)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                
                // Products List
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
            .padding()
            .padding(.bottom, 90)
        }
        .background(Color(uiColor: .systemGray6))
        .sheet(isPresented: $showingAddProduct) {
            AddProductView(productManager: productManager)
        }
        .sheet(item: $selectedProduct) { product in
            ProductDetailView(product: product, productManager: productManager)
        }
    }
}

struct ProductCard: View {
    let product: ProductItem
    let onTap: () -> Void
    let onDelete: () -> Void
    
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
            }
            
            Spacer()
            
            Button(action: onTap) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundColor(.blue)
                    .padding(8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .padding(8)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
    }
}

struct AddProductView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var productManager: ProductManager
    @State private var productName = ""
    @State private var monthlySales: [String: Int] = [:]
    
    private let months = ["January", "February", "March", "April", "May", "June", 
                         "July", "August", "September", "October", "November", "December"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    TextField("Product Name", text: $productName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Monthly Sales Data (2024)")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(spacing: 16) {
                            ForEach(months, id: \.self) { month in
                                HStack {
                                    Text(month)
                                        .font(.subheadline)
                                    
                                    Spacer()
                                    
                                    HStack(spacing: 12) {
                                        Button(action: {
                                            monthlySales[month] = max(0, (monthlySales[month] ?? 0) - 1)
                                        }) {
                                            Image(systemName: "minus.circle.fill")
                                                .foregroundColor(.red)
                                        }
                                        
                                        Text("\(monthlySales[month] ?? 0)")
                                            .frame(width: 40)
                                        
                                        Button(action: {
                                            monthlySales[month] = (monthlySales[month] ?? 0) + 1
                                        }) {
                                            Image(systemName: "plus.circle.fill")
                                                .foregroundColor(.green)
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
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
                        let newProduct = ProductItem(name: productName, monthlySales: monthlySales)
                        productManager.addProduct(newProduct)
                        dismiss()
                    }
                    .disabled(productName.isEmpty)
                }
            }
        }
    }
}

struct ProductDetailView: View {
    let product: ProductItem
    @ObservedObject var productManager: ProductManager
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
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header with Emoji
                    HStack {
                        Text(product.emoji)
                            .font(.system(size: 60))
                            .frame(width: 80, height: 80)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(16)
                        
                        VStack(alignment: .leading) {
                            Text(product.name)
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    
                    // Total Yearly Forecast
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Total Forecast for Next Year")
                            .font(.headline)
                        
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
                        
                        // Best Selling Month
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
                    .background(Color.white)
                    .cornerRadius(16)
                    
                    // Sales Chart
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
                    .background(Color.white)
                    .cornerRadius(16)
                    
                    // Quarterly Forecast
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
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            }
                        }
                        
                        // Monthly Forecast Chart
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
                    .background(Color.white)
                    .cornerRadius(16)
                }
                .padding()
            }
            .navigationTitle(product.name)
            .navigationBarTitleDisplayMode(.inline)
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
