import SwiftUI

@Observable
final class GratitudeViewModel {
    var inputText: String = ""
    var gratitudes: [Gratitude] = []

    private let storage = CloudStorage.shared

    func loadGratitudes() async {
        do {
            gratitudes = try await storage.loadGratitudes()
        } catch {
            print("Failed to load gratitudes: \(error)")
        }
    }

    func submitGratitude() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        let gratitude = Gratitude(text: inputText.trimmingCharacters(in: .whitespacesAndNewlines))
        inputText = ""

        // Haptic feedback (iOS only)
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        #endif

        // Add to local array immediately for responsive UI
        withAnimation {
            gratitudes.insert(gratitude, at: 0)
        }

        // Save to iCloud in background
        Task {
            try? await storage.addGratitude(gratitude)
        }
    }
}
