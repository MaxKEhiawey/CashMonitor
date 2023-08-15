//
//  InterFontModifier.swift
//  CashMonitor
//
//  Created by AMALITECH MACBOOK on 13/08/2023.
//

import SwiftUI

enum InterFontType: String {
    case black = "Inter-Black"
    case bold = "Inter-Bold"
    case extraBold = "Inter-ExtraBold"
    case extraLight = "Inter-ExtraLight"
    case light = "Inter-Light"
    case medium = "Inter-Medium"
    case regular = "Inter-Regular"
    case semiBold = "Inter-SemiBold"
    case thin = "Inter-Thin"
}

struct InterFont: ViewModifier {

    var type: InterFontType
    var size: CGFloat

    init(_ type: InterFontType = .regular, size: CGFloat = 16) {
        self.type = type
        self.size = size
    }

    func body(content: Content) -> some View {
        content.font(Font.custom(type.rawValue, size: size))
    }
}
struct CapsuleButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(
                Capsule()
                    .fill(Color("main_color"))
            )
    }
}

extension View {
    func capsuleButtonStyle() -> some View {
        self.modifier(CapsuleButtonModifier())
    }
}
