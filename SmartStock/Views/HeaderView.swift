import SwiftUI

struct HeaderView: View {
    @State private var isNotificationActive = false
    @State private var showSettings = false
    private let iconSize: CGFloat = 36
    private let spacing: CGFloat = 16
    @State private var boxRotation: Double = 0
    @State private var isBadgePulsing: Bool = false
    
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
                            .rotationEffect(.degrees(boxRotation))
                            .animation(.easeInOut(duration: 0.7), value: boxRotation)
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
                                .frame(width: isBadgePulsing ? 6 : 8, height: isBadgePulsing ? 6 : 8)
                                .offset(x: 2, y: -2)
                                .animation(.easeInOut(duration: 0.4), value: isBadgePulsing)
                        }
                    }
                    .sheet(isPresented: $isNotificationActive) {
                        NotificationListView()
                    }
                    
                    // Profile Image
                    Button(action: { showSettings = true }) {
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
                    .buttonStyle(PlainButtonStyle())
                    .sheet(isPresented: $showSettings) {
                        SettingsView()
                    }
                }
            }
            .padding(.horizontal, spacing)
            .padding(.vertical, 12)
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
        .onAppear {
            func animateBox() {
                let sequence: [Double] = [60, -45, 90, -60, 0]
                var idx = 0
                func next() {
                    if idx < sequence.count {
                        withAnimation(.easeInOut(duration: 0.7)) {
                            boxRotation = sequence[idx]
                        }
                        idx += 1
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            next()
                        }
                    }
                }
                next()
                DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
                    animateBox()
                }
            }
            animateBox()
            func animateBadge() {
                withAnimation(.easeInOut(duration: 0.4)) {
                    isBadgePulsing = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        isBadgePulsing = false
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                    animateBadge()
                }
            }
            animateBadge()
        }
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

// Додаю заглушку для NotificationListView
struct NotificationListView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Image(systemName: "bell.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.blue)
                    .padding(.top, 32)
                Text("Сповіщення")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Тут будуть зберігатися всі ваші push-сповіщення.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Spacer()
            }
            .navigationTitle("Сповіщення")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Закрити") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    HeaderView()
        .background(Color(uiColor: .systemGray6))
} 