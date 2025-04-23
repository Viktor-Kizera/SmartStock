import SwiftUI

struct HeaderView: View {
    @State private var isNotificationActive = false
    private let iconSize: CGFloat = 36
    private let spacing: CGFloat = 16
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: spacing) {
                // Logo and title
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: iconSize, height: iconSize)
                        
                        Image(systemName: "cube.box.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.blue)
                    }
                    
                    Text("SmartStock")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                // Notification and profile
                HStack(spacing: spacing) {
                    // Notification Button
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            isNotificationActive.toggle()
                        }
                    }) {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "bell")
                                .font(.system(size: 20))
                                .foregroundColor(.primary.opacity(0.7))
                            
                            // Notification Badge
                            Circle()
                                .fill(Color.red)
                                .frame(width: 8, height: 8)
                                .offset(x: 2, y: -2)
                        }
                    }
                    
                    // Profile Image
                    AsyncImage(url: URL(string: "https://github.com/viktorkizera.png")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Circle()
                            .fill(Color(hex: "FF6B6B"))
                            .overlay(
                                Text("VK")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white)
                            )
                    }
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
                }
            }
            .padding(.horizontal, spacing)
            .padding(.vertical, 12)
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}

// Розширення для підтримки HEX кольорів
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    HeaderView()
        .background(Color(uiColor: .systemGray6))
} 