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
    @State private var productName: String = ""
    @State private var monthlySales: [String: Int] = [
        "January": 0,
        "February": 0
    ]
    @State private var showAllMonths = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                HStack {
                    Text("Product Details")
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
                
                // Product Name Input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Product Name")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    TextField("Enter product name", text: $productName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                // Monthly Sales Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Monthly Sales Data (2024)")
                        .font(.headline)
                    
                    VStack(spacing: 16) {
                        // January
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("January")
                                    .font(.subheadline)
                                
                                Spacer()
                                
                                Text("+12%")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                            
                            HStack {
                                TextField("Units sold", value: $monthlySales["January"], format: .number)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                Button(action: {}) {
                                    Image(systemName: "chevron.up.chevron.down")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        
                        // February
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("February")
                                    .font(.subheadline)
                                
                                Spacer()
                                
                                Text("-5%")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                            
                            HStack {
                                TextField("Units sold", value: $monthlySales["February"], format: .number)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                Button(action: {}) {
                                    Image(systemName: "chevron.up.chevron.down")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        
                        // Show More Button
                        Button(action: { showAllMonths.toggle() }) {
                            HStack {
                                Text("Show More Months")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                
                                Image(systemName: showAllMonths ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                
                // Predict Button
                Button(action: {}) {
                    Text("Predict Demand")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                
                // Demand Forecast
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Demand Forecast")
                            .font(.headline)
                        
                        Spacer()
                        
                        // Legend
                        HStack(spacing: 16) {
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 8, height: 8)
                                Text("Actual")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(Color.purple)
                                    .frame(width: 8, height: 8)
                                Text("Predicted")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    // Chart
                    Chart {
                        ForEach(["Jan", "Mar", "Jun"], id: \.self) { month in
                            BarMark(
                                x: .value("Month", month),
                                y: .value("Sales", Double.random(in: 50...100))
                            )
                            .foregroundStyle(Color.blue)
                        }
                        
                        ForEach(["Sep", "Dec"], id: \.self) { month in
                            BarMark(
                                x: .value("Month", month),
                                y: .value("Sales", Double.random(in: 50...100))
                            )
                            .foregroundStyle(Color.purple)
                        }
                    }
                    .frame(height: 200)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                
                // Suggested Order Quantities
                VStack(alignment: .leading, spacing: 16) {
                    Text("Suggested Order Quantities")
                        .font(.headline)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        OrderQuantityCard(period: "Q1 2025", units: 250)
                        OrderQuantityCard(period: "Q2 2025", units: 780)
                        OrderQuantityCard(period: "Q3 2025", units: 920)
                        OrderQuantityCard(period: "Q4 2025", units: 850)
                    }
                }
                
                // Key Insights
                VStack(alignment: .leading, spacing: 16) {
                    Text("Key Insights")
                        .font(.headline)
                    
                    VStack(spacing: 12) {
                        // Expected Growth
                        InsightCard(
                            icon: "arrow.up.right",
                            title: "Expected Growth",
                            description: "+25% growth expected in Q3",
                            color: .green
                        )
                        
                        // Peak Season
                        InsightCard(
                            icon: "sun.max.fill",
                            title: "Peak Season",
                            description: "July - September 2025",
                            color: .orange
                        )
                        
                        // Low Demand Period
                        InsightCard(
                            icon: "arrow.down.right",
                            title: "Low Demand Period",
                            description: "January - February 2025",
                            color: .red
                        )
                    }
                }
            }
            .padding()
            .padding(.bottom, 90)
        }
        .background(Color(uiColor: .systemGray6))
    }
}

struct OrderQuantityCard: View {
    let period: String
    let units: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(period)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack(spacing: 4) {
                Text("\(units)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                Text("units")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
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
