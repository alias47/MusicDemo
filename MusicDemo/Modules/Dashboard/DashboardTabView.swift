//
//  DashboardTabView.swift
//  MusicDemo
//
//  Created by Atit Kayastha on 14/03/2026.
//

import SwiftUI

struct DashboardTabItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let image: String
}

struct DashboardTabContainer<
    BottomView: View,
    ExpandedPlayer: View,
    TabContent: View
>: View {
    @Binding var isSheetExpanded: Bool
    let animation: Namespace.ID

    let tabs: [DashboardTabItem]
    let bottomViewHeight: CGFloat
    let bottomInsetSpacing: CGFloat
    let tabContent: (DashboardTabItem) -> TabContent
    let bottomView: () -> BottomView
    let expandedPlayer: () -> ExpandedPlayer

    init(
        isSheetExpanded: Binding<Bool>,
        animation: Namespace.ID,
        tabs: [DashboardTabItem],
        bottomViewHeight: CGFloat = 74,
        bottomInsetSpacing: CGFloat = 49,
        @ViewBuilder tabContent: @escaping (DashboardTabItem) -> TabContent,
        @ViewBuilder bottomView: @escaping () -> BottomView,
        @ViewBuilder expandedPlayer: @escaping () -> ExpandedPlayer
    ) {
        self._isSheetExpanded = isSheetExpanded
        self.animation = animation
        self.tabs = tabs
        self.bottomViewHeight = bottomViewHeight
        self.bottomInsetSpacing = bottomInsetSpacing
        self.tabContent = tabContent
        self.bottomView = bottomView
        self.expandedPlayer = expandedPlayer
        
        TabBarAppearance.apply()
    }

    var body: some View {
        TabView {
            ForEach(tabs) { tab in
                tabContent(tab)
                    .tabItem {
                        Image(tab.image)
                    }
            }
        }
        .tint(.red)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(.ultraThickMaterial, for: .tabBar)
        .toolbar(isSheetExpanded ? .hidden : .visible, for: .tabBar)
        .safeAreaInset(edge: .bottom) {
            customBottomSheet()
        }
        .overlay(alignment: .bottom) {
            if isSheetExpanded {
                expandedPlayer()
                    .transition(
                        .asymmetric(
                            insertion: .identity,
                            removal: .offset(y: -5)
                        )
                    )
            }
        }
    }

    @ViewBuilder
    private func customBottomSheet() -> some View {
        ZStack {
            if isSheetExpanded {
                Rectangle()
                    .fill(.clear)
            } else {
                Rectangle()
                    .fill(.clear)
                    .overlay {
                        bottomView()
                    }
                    .matchedGeometryEffect(id: "BGVIEW", in: animation)
            }
        }
        .frame(height: bottomViewHeight)
        .offset(y: -bottomInsetSpacing)
    }
}

#Preview {
    DashboardScreen()
        .preferredColorScheme(.dark)
}

enum TabBarAppearance {
    static func apply() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.shadowColor = UIColor.white.withAlphaComponent(0.18)
        appearance.shadowImage = UIImage()

        UITabBar.appearance().standardAppearance = appearance

        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
