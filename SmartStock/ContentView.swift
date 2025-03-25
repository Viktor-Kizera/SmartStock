//
//  ContentView.swift
//  SmartStock
//
//  Created by Viktor Kizera on 3/25/25.
//

import SwiftUI
import Charts

struct ContentView: View {
    @StateObject private var viewModel = SmartStockViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    productInputSection
                    monthlySalesSection
                    predictButton
                    
                    if viewModel.isShowingResults {
                        resultSection
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 24)
            }
            .background(
                LinearGradient(
                    colors: [Color(UIColor.systemGray6), Color(UIColor.systemGray5)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .navigationTitle("SmartStock")
        }
    }
    
    private var productInputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Назва товару", systemImage: "box.fill")
                .font(.headline)
                .foregroundColor(.gray)
            
            TextField("Введіть назву товару", text: $viewModel.productName)
                .textFieldStyle(CustomTextFieldStyle())
                .padding(.horizontal, 4)
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
    
    private var monthlySalesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Кількість проданих одиниць", systemImage: "calendar")
                .font(.headline)
                .foregroundColor(.gray)
            
            ForEach(viewModel.months, id: \.self) { month in
                VStack(spacing: 0) {
                    HStack {
                        Text(month)
                            .frame(width: 100, alignment: .leading)
                            .foregroundColor(.primary)
                            .font(.system(.body, design: .rounded))
                        
                        Spacer()
                        
                        // Степпер для вибору кількості
                        HStack(spacing: 16) {
                            Button(action: {
                                viewModel.decrementSales(for: month)
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red.opacity(0.8))
                                    .font(.title2)
                            }
                            
                            Text("\(viewModel.monthlySales[month] ?? 0)")
                                .font(.system(.body, design: .rounded))
                                .frame(width: 50)
                                .multilineTextAlignment(.center)
                            
                            Button(action: {
                                viewModel.incrementSales(for: month)
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.green.opacity(0.8))
                                    .font(.title2)
                            }
                        }
                    }
                    .padding(.vertical, 12)
                    
                    if month != viewModel.months.last {
                        Divider()
                            .background(Color.gray.opacity(0.15))
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
    
    private var predictButton: some View {
        Button(action: viewModel.predictDemand) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.headline)
                Text("Прогнозувати річний попит")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    colors: [Color.blue, Color.blue.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .disabled(viewModel.productName.isEmpty)
        .opacity(viewModel.productName.isEmpty ? 0.6 : 1)
    }
    
    private var resultSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 12) {
                Label("Прогноз на рік", systemImage: "chart.bar.fill")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(viewModel.yearlyPrediction)")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(.green)
                    Text("рекомендована кількість одиниць")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Label("Графік продажів", systemImage: "chart.xyaxis.line")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text(viewModel.productName)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                
                Chart {
                    ForEach(viewModel.months, id: \.self) { month in
                        BarMark(
                            x: .value("Місяць", month),
                            y: .value("Продажі", viewModel.monthlySales[month] ?? 0)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue.opacity(0.8), .blue.opacity(0.4)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    }
                }
                .frame(height: 200)
                .chartXAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisValueLabel {
                            Text(value.as(String.self) ?? "")
                                .font(.caption2)
                                .rotationEffect(Angle(degrees: -45))
                                .offset(y: 10)
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisValueLabel {
                            if let intValue = value.as(Int.self) {
                                Text("\(intValue)")
                                    .font(.caption2)
                            }
                        }
                    }
                }
                .padding(.bottom, 20)
            }
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}

// Кастомний стиль для текстового поля
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
    }
}

#Preview {
    ContentView()
}
