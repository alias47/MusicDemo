//
//  TabBar.swift
//  MusicDemo
//
//  Created by Atit Kayastha on 17/03/2026.
//

import SwiftUI

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
