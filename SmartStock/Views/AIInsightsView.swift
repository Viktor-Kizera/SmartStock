import SwiftUI

struct AIInsightsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("AI Insights", systemImage: "brain")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 20) {
                // Demand Forecast
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .foregroundColor(.blue)
                        Text("Demand Forecast")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    
                    Text("Based on last 6 months data")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                HStack(spacing: 12) {
                    // Growth Badge
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.right")
                            .font(.caption)
                        Text("+12% Expected Growth")
                            .font(.caption)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.2))
                    .foregroundColor(.green)
                    .cornerRadius(6)
                    
                    // Optimization Badge
                    Text("Stock Optimization")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.blue)
                        .cornerRadius(6)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

#Preview {
    AIInsightsView()
        .padding()
        .background(Color.gray.opacity(0.1))
} 