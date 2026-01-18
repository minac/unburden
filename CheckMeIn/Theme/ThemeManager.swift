import SwiftUI

enum AppTheme: String {
    case light
    case dark

    var colorScheme: ColorScheme {
        switch self {
        case .light: return .light
        case .dark: return .dark
        }
    }

    var icon: String {
        switch self {
        case .light: return "moon.fill"
        case .dark: return "sun.max.fill"
        }
    }

    mutating func toggle() {
        self = self == .light ? .dark : .light
    }
}

@Observable
final class ThemeManager {
    static let shared = ThemeManager()

    private let userDefaultsKey = "app_theme"

    var currentTheme: AppTheme {
        didSet {
            UserDefaults.standard.set(currentTheme.rawValue, forKey: userDefaultsKey)
        }
    }

    private init() {
        if let savedTheme = UserDefaults.standard.string(forKey: userDefaultsKey),
           let theme = AppTheme(rawValue: savedTheme) {
            self.currentTheme = theme
        } else {
            self.currentTheme = .light
        }
    }

    func toggle() {
        currentTheme.toggle()
    }
}
