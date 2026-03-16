//
//  MiniPlayer.swift
//  MusicDemo
//
//  Created by Atit Kayastha on 14/03/2026.
//

import SwiftUI

struct MiniPlayerView: View {
    let task: MusicTaskItem
    @Binding var expandSheet: Bool
    var animation: Namespace.ID

    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                if !expandSheet {
                    GeometryReader {
                        let size = $0.size
                        Image(task.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: expandSheet ? 15 : 12, style: .continuous))
                    }
                    .matchedGeometryEffect(id: "ARTWORK", in: animation)
                }
            }
            .frame(width: 56, height: 56)

            Text(task.title)
                .fontWeight(.semibold)
                .lineLimit(1)
                .padding(.horizontal, 12)

            Spacer(minLength: 0)

            HStack(spacing: 16) {
                Button {
                } label: {
                    Image(.previous)
                        .resizable()
                        .frame(width: 24, height: 24)
                }

                Button {
                } label: {
                    Image(.pause)
                        .resizable()
                        .frame(width: 24, height: 24)
                }

                Button {
                } label: {
                    Image(.next)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            .frame(alignment: .trailing)
            .padding(.trailing, 24)
        }
        .padding(8)
        .foregroundStyle(.primary)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            openPlayer()
        }
        .gesture(
            DragGesture(minimumDistance: 20)
                .onEnded { value in
                    let isSwipeUp = value.translation.height < -40
                    let isMostlyVertical = abs(value.translation.height) > abs(value.translation.width)

                    if isSwipeUp && isMostlyVertical {
                        openPlayer()
                    }
                }
        )
        .padding(.bottom, 70)
    }

    private func openPlayer() {
        withAnimation(.easeInOut(duration: 0.3)) {
            expandSheet = true
        }
    }
}

private struct MiniPlayerPreviewWrapper: View {
    @Namespace private var animation

    var body: some View {
        VStack {
            MiniPlayerView(
                task: MusicTaskItem(title: "", subtitle: "", state: .completed, image: .beatles, imageColor: .red), expandSheet: .constant(false),
                animation: animation
            )
        }
    }
}

#Preview {
    MiniPlayerPreviewWrapper()
        .preferredColorScheme(.dark)
}
