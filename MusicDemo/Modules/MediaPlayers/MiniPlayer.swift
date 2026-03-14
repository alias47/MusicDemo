//
//  MiniPlayer.swift
//  MusicDemo
//
//  Created by Atit Kayastha on 14/03/2026.
//

import SwiftUI

struct MiniPlayerView: View {
    @Binding var expandSheet: Bool
    var animation: Namespace.ID

    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                if !expandSheet {
                    GeometryReader {
                        let size = $0.size
                        Image(.album)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: expandSheet ? 15 : 12, style: .continuous))
                    }
                    .matchedGeometryEffect(id: "ARTWORK", in: animation)
                }
            }
            .frame(width: 56, height: 56)

            Spacer(minLength: 0)
            Text("Look What you made me do")
                .fontWeight(.semibold)
                .lineLimit(1)
                .padding(.horizontal, 12)

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
            withAnimation(.easeInOut(duration: 0.3)) {
                expandSheet.toggle()
            }
        }
        .padding(.bottom, 30)
    }
}

private struct MiniPlayerPreviewWrapper: View {
    @Namespace private var animation

    var body: some View {
        VStack {
            MiniPlayerView(
                expandSheet: .constant(false),
                animation: animation
            )
        }
    }
}

#Preview {
    MiniPlayerPreviewWrapper()
        .preferredColorScheme(.dark)
}
