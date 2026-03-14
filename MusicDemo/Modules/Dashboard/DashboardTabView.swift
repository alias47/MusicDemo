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
    MiniPlayer: View,
    ExpandedPlayer: View,
    TabContent: View
>: View {
    @Binding var isSheetExpanded: Bool
    let animation: Namespace.ID

    let tabs: [DashboardTabItem]
    let miniPlayerHeight: CGFloat
    let bottomInsetSpacing: CGFloat
    let tabContent: (DashboardTabItem) -> TabContent
    let miniPlayer: () -> MiniPlayer
    let expandedPlayer: () -> ExpandedPlayer

    init(
        isSheetExpanded: Binding<Bool>,
        animation: Namespace.ID,
        tabs: [DashboardTabItem],
        miniPlayerHeight: CGFloat = 74,
        bottomInsetSpacing: CGFloat = 49,
        @ViewBuilder tabContent: @escaping (DashboardTabItem) -> TabContent,
        @ViewBuilder miniPlayer: @escaping () -> MiniPlayer,
        @ViewBuilder expandedPlayer: @escaping () -> ExpandedPlayer
    ) {
        self._isSheetExpanded = isSheetExpanded
        self.animation = animation
        self.tabs = tabs
        self.miniPlayerHeight = miniPlayerHeight
        self.bottomInsetSpacing = bottomInsetSpacing
        self.tabContent = tabContent
        self.miniPlayer = miniPlayer
        self.expandedPlayer = expandedPlayer
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
        .overlay {
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
                        miniPlayer()
                    }
                    .matchedGeometryEffect(id: "BGVIEW", in: animation)
            }
        }
        .frame(height: miniPlayerHeight)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(.gray.opacity(0.3))
                .frame(height: 1)
                .offset(y: -10)
        }
        .offset(y: -bottomInsetSpacing)
    }
}

#Preview {
    DashboardScreen()
        .preferredColorScheme(.dark)
}
