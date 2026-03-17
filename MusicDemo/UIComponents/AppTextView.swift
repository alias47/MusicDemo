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
        textView.keyboardAppearance = .dark

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
