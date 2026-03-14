//
//  ExpandedBottomSheet.swift
//  MusicDemo
//
//  Created by Atit Kayastha on 14/03/2026.
//

import SwiftUI

struct FullPlayerView: View {
    @Binding var expandedSheet: Bool
    var animation: Namespace.ID

    @State private var animatedContent: Bool = false

    @State private var offsetY: CGFloat = 0
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets

            ZStack {
                RoundedRectangle(cornerRadius: animatedContent ? deviceCornerRadius : 0, style: .continuous)
                    .fill(.ultraThickMaterial)
                    .overlay(content: {
                        RoundedRectangle(cornerRadius: animatedContent ? deviceCornerRadius : 0, style: .continuous)
                            .fill(.ultraThickMaterial)
                            .opacity(animatedContent ? 1 : 0)
                    })
                    .overlay(alignment: .top) {
                        MiniPlayerView(expandSheet: $expandedSheet, animation: animation)
                            .allowsHitTesting(false)
                            .opacity(animatedContent ? 0 : 1)
                    }
                    .matchedGeometryEffect(id: "BGVIEW", in: animation)
                VStack(spacing: 15) {


                    // Hero banner
                    GeometryReader {
                        let size = $0.size

                        Image(.album)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: animatedContent ? 15 : 5, style: .continuous))
                    }
                    // For square view
                    .matchedGeometryEffect(id: "ARTWORK", in: animation)
                    .frame(height: size.width - 50)
                    .padding(.vertical, size.height < 700 ? 10 : 30)
                }
                .padding(.top, safeArea.top + (safeArea.bottom == 0 ? 10 : 0))
                .padding(.bottom, safeArea.bottom == 0 ? 10 : safeArea.bottom)
                .padding(.horizontal, 25)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .clipped()
            }
            .contentShape(Rectangle())
            .offset(y: offsetY)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        let translationY = value.translation.height
                        offsetY = (translationY > 0 ? translationY : 0)
                    }).onEnded({ _ in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if offsetY > size.height * 0.2 {
                                expandedSheet = false
                                animatedContent = false
                            } else {
                                offsetY = .zero
                            }
                        }
                        offsetY = .zero
                    })
            )
            .ignoresSafeArea(.container, edges: .all)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.35)) {
                animatedContent = true
            }
        }
    }
}

#Preview {
    FullPlayerPreviewWrapper()
        .preferredColorScheme(.dark)
}

private struct FullPlayerPreviewWrapper: View {
    @State private var expandedSheet = true
    @Namespace private var animation

    var body: some View {
        FullPlayerView(
            expandedSheet: $expandedSheet,
            animation: animation
        )
    }
}
