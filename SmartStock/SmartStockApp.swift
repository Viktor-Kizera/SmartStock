//
//  SmartStockApp.swift
//  SmartStock
//
//  Created by Viktor Kizera on 3/25/25.
//

import SwiftUI

@main
struct SmartStockApp: App {
    @StateObject var productManager = ProductManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(productManager)
        }
    }
}
