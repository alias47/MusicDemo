//
//  AppTextView.swift
//  MusicDemo
//
//  Created by Atit Kayastha on 14/03/2026.
//

import SwiftUI

struct AppTextView: UIViewRepresentable {
    @Binding var text: String
    @Binding var calculatedHeight: CGFloat
    @Binding var isFirstResponder: Bool

    var minHeight: CGFloat = 40
    var maxHeight: CGFloat = 120
    var placeholder: String = "Create song"

    func makeCoordinator() -> Coordinator {
        Coordinator(
            text: $text,
            height: $calculatedHeight,
            isFirstResponder: $isFirstResponder,
            minHeight: minHeight,
            maxHeight: maxHeight,
            placeholder: placeholder
        )
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()

        textView.delegate = context.coordinator
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 0, bottom: 10, right: 0)
        textView.textContainer.lineFragmentPadding = 0
        textView.font = .systemFont(ofSize: 16)
        textView.textColor = .white
        textView.tintColor = .white
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.text = text

        DispatchQueue.main.async {
            recalculateHeight(view: textView)
        }

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
            uiView.textColor = .white
        }

        if isFirstResponder && !uiView.isFirstResponder {
            DispatchQueue.main.async {
                uiView.becomeFirstResponder()
            }
        } else if !isFirstResponder && uiView.isFirstResponder {
            DispatchQueue.main.async {
                uiView.resignFirstResponder()
            }
        }

        recalculateHeight(view: uiView)
    }

    private func recalculateHeight(view: UITextView) {
        let targetSize = CGSize(width: view.bounds.width, height: .greatestFiniteMagnitude)
        let fittingSize = view.sizeThatFits(targetSize)
        let newHeight = min(max(fittingSize.height, minHeight), maxHeight)

        if calculatedHeight != newHeight {
            calculatedHeight = newHeight
        }

        view.isScrollEnabled = fittingSize.height > maxHeight
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        @Binding var height: CGFloat
        @Binding var isFirstResponder: Bool

        let minHeight: CGFloat
        let maxHeight: CGFloat
        let placeholder: String

        init(
            text: Binding<String>,
            height: Binding<CGFloat>,
            isFirstResponder: Binding<Bool>,
            minHeight: CGFloat,
            maxHeight: CGFloat,
            placeholder: String
        ) {
            _text = text
            _height = height
            _isFirstResponder = isFirstResponder
            self.minHeight = minHeight
            self.maxHeight = maxHeight
            self.placeholder = placeholder
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            isFirstResponder = false
        }

        func textViewDidChange(_ textView: UITextView) {
            text = textView.text

            let targetSize = CGSize(width: textView.bounds.width, height: .greatestFiniteMagnitude)
            let fittingSize = textView.sizeThatFits(targetSize)
            let newHeight = min(max(fittingSize.height, minHeight), maxHeight)

            if height != newHeight {
                height = newHeight
            }

            textView.isScrollEnabled = fittingSize.height > maxHeight
        }
    }
}

import SwiftUI

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
                    .background(.ultraThinMaterial)
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
