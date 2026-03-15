//
//  DashboardScreen.swift
//  MusicDemo
//
//  Created by Atit Kayastha on 14/03/2026.
//

import SwiftUI

struct DashboardScreen: View {
    @StateObject private var keyboard = KeyboardObserver()
    @State private var expandSheet: Bool = false
    @Namespace private var animation
    @State private var showMiniMedia: Bool = false

    @State private var showPromptView = false
    @State private var showGradient = false
    @State private var isFocused = false
    @State private var text = ""
    @State private var showCreateButton = true

    @State private var gradientShift: CGFloat = -1
    @State private var glowAngle: Double = 0

    @StateObject private var songListViewModel = SongListViewModel()

    let tabs: [DashboardTabItem] = [
        .init(title: "Listen Now", image: "star"),
        .init(title: "Browse", image: "search"),
        .init(title: "Radio", image: "block"),
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            mainDashboard

            keyboardGradient

            if showPromptView {
                promptView
                    .padding(.bottom, 8)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(10)
            }
        }
    }

    // MARK: Main Dashboard

    private var mainDashboard: some View {
        DashboardTabContainer(
            isSheetExpanded: $expandSheet,
            animation: animation,
            tabs: tabs
        ) { tab in
            // Tab screens
            screen(for: tab)
        } bottomView: {
            VStack {
                // Create prompt
                if showCreateButton {
                    createButton
                        .transition(.opacity)
                }

                if !showPromptView, let selectedTask = songListViewModel.selectedTask {
                    MiniPlayerView(
                        task: selectedTask,
                        expandSheet: $expandSheet,
                        animation: animation
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            // Full Media player view
        } expandedPlayer: {
            FullPlayerView(
                expandedSheet: $expandSheet,
                animation: animation
            )
        }
        .simultaneousGesture(
            TapGesture().onEnded {
                if showPromptView {
                    dismissPrompt()
                }
            }
        )
    }

    // MARK: Prompt View

    private var promptView: some View {
        PromptView(
            text: $text,
            isFocused: $isFocused
        ) { prompt in
            submitPrompt(prompt)
        }
    }

    @ViewBuilder
    private var keyboardGradient: some View {
        if showGradient {
            Rectangle()
                .fill(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            .gradientOrange,
                            .gradientPink,
                            .gradientOrange,
                        ]),
                        center: .center,
                        startAngle: .degrees(glowAngle),
                        endAngle: .degrees(glowAngle + 360)
                    )
                )
                .ignoresSafeArea(.keyboard)
                .frame(maxHeight: 0)
                .scaleEffect(x: 1.3, y: 1.5, anchor: .bottom)
                .blur(radius: 60)
                .opacity(0.80)
                .allowsHitTesting(false)
                .onAppear {
                    glowAngle = 0
                    withAnimation(
                        .linear(duration: 4)
                            .repeatForever(autoreverses: false)
                    ) {
                        glowAngle = 360
                    }
                }
        }
    }

    // MARK: Create Button

    private var createButton: some View {
        Button {
            guard showCreateButton else { return }
            Haptic.impact(.light)
            withAnimation(.easeOut(duration: 0.18)) {
                showCreateButton = false
                showPromptView = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                isFocused = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.24) {
                showGradient = true
            }

        } label: {
            HStack(spacing: 8) {
                Image(.gradientStar)
                    .resizable()
                    .frame(width: 20, height: 20)

                Text("Create")
                    .font(.system(size: 14, weight: .bold))
            }
            .frame(width: 104, height: 44)
            .foregroundStyle(.white)
            .background(.ultraThinMaterial)
            .cornerRadius(100)
        }
        .buttonStyle(.plain)
    }

    // MARK: Tab screens

    @ViewBuilder
    private func screen(for tab: DashboardTabItem) -> some View {
        switch tab.title {
        case "Listen Now":
            SongListScreen(viewModel: songListViewModel)

        case "Browse":
            sampleTabView("Browse")

        case "Radio":
            sampleTabView("Radio")

        default:
            EmptyView()
        }
    }

    private func sampleTabView(_ title: String) -> some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                Text(title)
                    .padding()
            }
            .navigationTitle(title)
        }
    }

    // MARK: Create prompt action

    private func submitPrompt(_ prompt: String) {
        let trimmed = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        songListViewModel.startNewGeneration(title: trimmed)
        text = ""
        dismissPrompt()
    }

    // MARK: Dissmiss Keyboard

    func dismissPrompt() {
        showGradient = false
        isFocused = false

        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            withAnimation(.easeOut(duration: 0.15)) {
                showPromptView = false
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
            withAnimation(.easeOut(duration: 0.12)) {
                showCreateButton = true
            }
        }
    }
}

#Preview {
    DashboardScreen()
        .preferredColorScheme(.dark)
}

import Combine
import SwiftUI

final class KeyboardObserver: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0
    @Published var isVisible: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        let willChange = NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
        let willHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)

        willChange
            .merge(with: willHide)
            .receive(on: RunLoop.main)
            .sink { [weak self] notification in
                guard let self else { return }

                if notification.name == UIResponder.keyboardWillHideNotification {
                    self.keyboardHeight = 0
                    self.isVisible = false
                    return
                }

                guard
                    let userInfo = notification.userInfo,
                    let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                else {
                    return
                }

                let screenHeight = UIScreen.main.bounds.height
                let height = max(0, screenHeight - frame.minY)

                self.keyboardHeight = height
                self.isVisible = height > 0
            }
            .store(in: &cancellables)
    }
}
