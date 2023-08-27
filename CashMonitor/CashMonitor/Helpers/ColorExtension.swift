//
//  ColorExtension.swift
//  CashMonitor
//
//  Created by AMALITECH MACBOOK on 13/08/2023.
//

import SwiftUI

extension Color {

    static let mainColor = Color("main_color")
    static let primaryColor = Color("primary")
    static let secondaryColor = Color("secondary")
    static let textPrimaryColor = Color("textPrimary_33_F2")
    static let textSecondaryColor = Color("textSecondary_4F_F2")
    static let placeholderColor = Color(UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1.0))

    static let mainGreen = Color(UIColor(red: 111/255, green: 207/255, blue: 151/255, alpha: 1.0))
    static let mainRed = Color(UIColor(red: 235/255, green: 87/255, blue: 87/255, alpha: 1.0))

    init(hex: String, alpha: Double = 1) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") { cString.remove(at: cString.startIndex) }

        let scanner = Scanner(string: cString)
        scanner.currentIndex = scanner.string.startIndex
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let red = (rgbValue & 0xff0000) >> 16
        let green = (rgbValue & 0xff00) >> 8
        let blue = rgbValue & 0xff
        self.init(.sRGB,
                  red: Double(red) / 0xff,
                  green: Double(green) / 0xff,
                  blue: Double(blue) / 0xff,
                  opacity: alpha)
    }
}

extension UIColor {

    static let primaryColor = UIColor(named: "primary")

    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}
