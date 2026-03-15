//
//  PromptView.swift
//  MusicDemo
//
//  Created by Atit Kayastha on 14/03/2026.
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
