import Foundation
import SwiftUI

class TabRouter: ObservableObject {
    @Published var selectedTab: Tab = .home
    @Published var scrollToSalesPerformance: Bool = false
} 