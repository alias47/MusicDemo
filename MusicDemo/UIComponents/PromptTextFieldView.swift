//
//  PromptTextFieldView.swift
//  MusicDemo
//
//  Created by Atit Kayastha on 17/03/2026.
//

import SwiftUI

struct PromptView: View {
    @Binding var text: String
    @Binding var isFocused: Bool
    var onSend: (String) -> Void

    var body: some View {
        PromptTextFieldView(
            text: $text,
            isFocused: $isFocused,
            onSend: onSend
        )
    }
}

struct PromptTextFieldView: View {
    @Binding var text: String
    @Binding var isFocused: Bool
    var onSend: (String) -> Void

    @State private var textViewHeight: CGFloat = 50

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image("plus")
                .resizable()
                .frame(width: 24, height: 24)

            ZStack(alignment: .topLeading) {
                if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text("Create song")
                        .foregroundStyle(Color(uiColor: .systemGray2))
                        .font(.system(size: 16))
                        .padding(.top, 15)
                        .allowsHitTesting(false)
                }

                AppTextView(
                    text: $text,
                    calculatedHeight: $textViewHeight,
                    isFirstResponder: $isFocused,
                    minHeight: 50,
                    maxHeight: 120,
                    placeholder: "Create song"
                )
                .frame(height: textViewHeight)
            }

            Button {
                Haptic.impact(.rigid)
                onSend(text)
            } label: {
                Image(systemName: "arrow.up")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.black)
                    .frame(width: 30, height: 30)
                    .background(text.isEmpty ? Color.createButton : Color.white)
                    .clipShape(Circle())
            }
            .disabled(text.isEmpty)
        }
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.black)
        )
        .overlay {
            ShapeGlow(shape: RoundedRectangle(cornerRadius: 24))
                .opacity(isFocused ? 1 : 0)
                .animation(.easeOut(duration: 0.18), value: isFocused)
                .allowsHitTesting(false)
        }
        .padding(.horizontal)
    }
}
