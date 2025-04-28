import SwiftUI

// Додаю модель для сповіщення
struct AppNotification: Identifiable, Codable {
    let id: UUID
    let title: String
    let body: String
    let date: Date
    var isRead: Bool = false
    var productEmoji: String? = nil // emoji товару
    
    init(title: String, body: String, isRead: Bool = false, productEmoji: String? = nil) {
        self.id = UUID()
        self.title = title
        self.body = body
        self.date = Date()
        self.isRead = isRead
        self.productEmoji = productEmoji
    }
}

// Менеджер для зберігання сповіщень
class NotificationManager: ObservableObject {
    @Published var notifications: [AppNotification] = [] {
        didSet { save() }
    }
    private let key = "app_notifications"
    
    init() {
        load()
    }
    
    func add(_ notification: AppNotification) {
        notifications.insert(notification, at: 0)
    }
    
    private func save() {
        if let data = try? JSONEncoder().encode(notifications) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    private func load() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([AppNotification].self, from: data) {
            notifications = decoded
        }
    }
}

struct HeaderView: View {
    @State private var isNotificationActive = false
    @State private var showSettings = false
    @EnvironmentObject var notificationManager: NotificationManager
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
                            .environmentObject(notificationManager)
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

// Оновлений NotificationListView
struct NotificationListView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var notificationManager: NotificationManager
    @State private var notifications: [AppNotification] = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Text("Notifications")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 24)
                        .padding(.leading)
                    Spacer()
                    Button(action: {
                        notificationManager.notifications.removeAll()
                        notifications.removeAll()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "trash")
                            Text("Clear All")
                        }
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color.red.opacity(0.08))
                        .cornerRadius(10)
                    }
                    .padding(.top, 24)
                    .padding(.trailing)
                    .opacity(notifications.isEmpty ? 0.3 : 1)
                    .disabled(notifications.isEmpty)
                }
                .padding(.bottom, 18)
                if notifications.isEmpty {
                    Spacer()
                    Image(systemName: "bell.slash")
                        .font(.system(size: 56))
                        .foregroundColor(.gray.opacity(0.25))
                        .padding(.top, 32)
                    Text("No notifications yet")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.top, 8)
                    Text("All your push notifications will appear here.")
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Spacer()
                } else {
                    List {
                        ForEach(notifications) { notif in
                            NotificationCardView(notification: notif)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    if !notif.isRead {
                                        Button {
                                            if let idx = notifications.firstIndex(where: { $0.id == notif.id }) {
                                                notifications[idx].isRead = true
                                                if let globalIdx = notificationManager.notifications.firstIndex(where: { $0.id == notif.id }) {
                                                    notificationManager.notifications[globalIdx].isRead = true
                                                }
                                            }
                                        } label: {
                                            VStack(spacing: 1) {
                                                Image(systemName: "checkmark")
                                                    .font(.system(size: 16, weight: .semibold))
                                                Text("Read")
                                                    .font(.caption2)
                                            }
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 2)
                                        }
                                        .tint(.blue)
                                    }
                                    Button(role: .destructive) {
                                        notifications.removeAll { $0.id == notif.id }
                                        notificationManager.notifications.removeAll { $0.id == notif.id }
                                    } label: {
                                        VStack(spacing: 1) {
                                            Image(systemName: "trash")
                                                .font(.system(size: 16, weight: .semibold))
                                            Text("Delete")
                                                .font(.caption2)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 2)
                                    }
                                }
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets())
                        }
                    }
                    .listStyle(.plain)
                    .background(Color(.systemGray6))
                }
            }
            .background(Color(.systemGray6).ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
            .onAppear {
                notifications = notificationManager.notifications
            }
        }
    }
}

struct NotificationCardView: View {
    var notification: AppNotification
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.12))
                    .frame(width: 38, height: 38)
                if let emoji = notification.productEmoji {
                    Text(emoji)
                        .font(.system(size: 22))
                        .frame(width: 22, height: 22)
                } else {
                    Image(systemName: "bell.fill")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.blue)
                }
            }
            VStack(alignment: .leading, spacing: 5) {
                Text(notification.title)
                    .font(.system(size: 21, weight: notification.isRead ? .regular : .bold))
                ForEach(notification.body.components(separatedBy: "|").map { $0.trimmingCharacters(in: .whitespaces) }, id: \.self) { line in
                    HStack(alignment: .center, spacing: 5) {
                        if line.starts(with: "Name:") && notification.productEmoji != nil {
                            let name = line.replacingOccurrences(of: "Name:", with: "").trimmingCharacters(in: .whitespaces)
                            Text("Name:")
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                                .fontWeight(notification.isRead ? .regular : .semibold)
                            if !name.isEmpty {
                                Text(notification.productEmoji! + " " + name)
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                                    .fontWeight(notification.isRead ? .regular : .semibold)
                            }
                        } else {
                            Text(line)
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                                .fontWeight(notification.isRead ? .regular : .semibold)
                        }
                    }
                }
                Text(notification.date, style: .time)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer(minLength: 0)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 15)
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 1)
        .padding(.vertical, 3)
    }
}

#Preview {
    HeaderView()
        .background(Color(uiColor: .systemGray6))
} 