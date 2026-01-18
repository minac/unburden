import SwiftUI

@Observable
final class WorryViewModel {
    var inputText: String = ""
    var showFadingText: Bool = false
    var fadingText: String = ""
    var fadeOpacity: Double = 1.0

    private let storage = CloudStorage.shared

    func submitWorry() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        let worry = Worry(text: inputText.trimmingCharacters(in: .whitespacesAndNewlines))
        fadingText = inputText
        inputText = ""
        showFadingText = true
        fadeOpacity = 1.0

        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()

        // Save to iCloud in background
        Task {
            try? await storage.addWorry(worry)
        }

        // Fade animation over 3 seconds
        withAnimation(.easeOut(duration: 3.0)) {
            fadeOpacity = 0.0
        }

        // Reset after fade completes
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(3.0))
            showFadingText = false
            fadingText = ""
            fadeOpacity = 1.0
        }
    }
}
