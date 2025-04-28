//
//  SmartStockApp.swift
//  SmartStock
//
//  Created by Viktor Kizera on 3/25/25.
//

import SwiftUI
import UserNotifications

@main
struct SmartStockApp: App {
    @StateObject var productManager = ProductManager()
    
    init() {
        // Запит дозволу на локальні сповіщення
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
        // Встановлюємо делегат для показу сповіщень у foreground
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(productManager)
        }
    }
}

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationDelegate()
    private override init() { super.init() }
    // Показуємо сповіщення навіть коли додаток активний
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
}
