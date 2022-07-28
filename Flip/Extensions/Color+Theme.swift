//
//  Color+Theme.swift
//  Flip
//
//  Created by Jesal Patel on 7/21/22.
//

import SwiftUI

extension Color {
    enum ThemeChoice: String, Codable, CaseIterable, ShapeStyle {
        case blue, brown, cyan, gray, green, indigo, mint, orange, pink, purple, red, teal, yellow
    }

    static func getThemeColor(_ choice: ThemeChoice) -> Color {
        switch choice {
        case .blue:
            return Color.blue
        case .brown:
            return Color.brown
        case .cyan:
            return Color.cyan
        case .gray:
            return Color.gray
        case .green:
            return Color.green
        case .indigo:
            return Color.indigo
        case .mint:
            return Color.mint
        case .orange:
            return Color.orange
        case .pink:
            return Color.pink
        case .purple:
            return Color.purple
        case .red:
            return Color.red
        case .teal:
            return Color.teal
        case .yellow:
            return Color.yellow
        }
    }
}
