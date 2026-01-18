import SwiftUI

@Observable
final class MoodViewModel {
    var moods: [MoodEntry] = []

    var lastMood: MoodEntry? {
        moods.first
    }

    private let storage = CloudStorage.shared

    func loadMoods() async {
        do {
            moods = try await storage.loadMoods()
        } catch {
            print("Failed to load moods: \(error)")
        }
    }

    func selectMood(_ moodType: MoodType) {
        let entry = MoodEntry(mood: moodType)

        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()

        // Update local array immediately
        withAnimation {
            moods.insert(entry, at: 0)
        }

        // Save to iCloud in background
        Task {
            try? await storage.addMood(entry)
        }
    }
}
