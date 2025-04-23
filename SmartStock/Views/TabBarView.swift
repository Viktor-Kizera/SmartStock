import SwiftUI

struct TabBarView: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 20))
                            .foregroundColor(selectedTab == tab ? .blue : .gray)
                        
                        Text(tab.title)
                            .font(.system(size: 12))
                            .foregroundColor(selectedTab == tab ? .blue : .gray)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(
            Color.white
                .shadow(color: .black.opacity(0.05), radius: 15, x: 0, y: -5)
        )
    }
}

enum Tab: CaseIterable {
    case home
    case analytics
    case products
    case settings
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .analytics: return "Analytics"
        case .products: return "Products"
        case .settings: return "Settings"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .analytics: return "chart.bar.fill"
        case .products: return "cube.box.fill"
        case .settings: return "gearshape.fill"
        }
    }
}

#Preview {
    TabBarView(selectedTab: .constant(.home))
} 