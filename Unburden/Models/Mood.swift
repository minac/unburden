import Foundation

enum MoodType: String, Codable, CaseIterable {
    case happy
    case calm
    case anxious
    case sad
    case angry
    case tired
    case energetic
    case neutral

    var emoji: String {
        switch self {
        case .happy: return "😊"
        case .calm: return "😌"
        case .anxious: return "😰"
        case .sad: return "😢"
        case .angry: return "😠"
        case .tired: return "😴"
        case .energetic: return "⚡"
        case .neutral: return "😐"
        }
    }

    var label: String {
        rawValue.capitalized
    }
}

struct MoodEntry: Codable, Identifiable {
    let id: UUID
    let mood: MoodType
    let timestamp: Date

    init(id: UUID = UUID(), mood: MoodType, timestamp: Date = Date()) {
        self.id = id
        self.mood = mood
        self.timestamp = timestamp
    }
}
