//
//  DashboardScreen.swift
//  MusicDemo
//
//  Created by Atit Kayastha on 14/03/2026.
//

import SwiftUI

struct DashboardScreen: View {
    @State private var expandSheet: Bool = false
    @Namespace private var animation

    let tabs: [DashboardTabItem] = [
        .init(title: "Listen Now", image: "star"),
        .init(title: "Browse", image: "search"),
        .init(title: "Radio", image: "block")
    ]

    var body: some View {
        DashboardTabContainer(
            isSheetExpanded: $expandSheet,
            animation: animation,
            tabs: tabs
        ) { tab in
            screen(for: tab)
        } miniPlayer: {
            MiniPlayerView(
                expandSheet: $expandSheet,
                animation: animation
            )
        } expandedPlayer: {
            FullPlayerView(
                expandedSheet: $expandSheet,
                animation: animation
            )
        }
    }

    @ViewBuilder
    private func screen(for tab: DashboardTabItem) -> some View {
        switch tab.title {
        case "Listen Now":
            SongListScreen()
        case "Browse":
            sampleTabView("Browse")
        case "Radio":
            sampleTabView("Radio")
        default:
            EmptyView()
        }
    }


    func sampleTabView(_ title: String) -> some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                Text(title)
                    .padding()
            }
            .navigationTitle(title)
        }
    }
}
#Preview {
    DashboardScreen()
        .preferredColorScheme(.dark)
}
