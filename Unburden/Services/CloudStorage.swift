import Foundation

enum StorageError: Error {
    case iCloudNotAvailable
    case fileNotFound
    case encodingFailed
    case decodingFailed
}

actor CloudStorage {
    static let shared = CloudStorage()

    private let fileManager = FileManager.default
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private init() {
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }

    private var containerURL: URL? {
        fileManager.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
    }

    private var localFallbackURL: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private func storageURL() -> URL {
        if let iCloudURL = containerURL {
            if !fileManager.fileExists(atPath: iCloudURL.path) {
                try? fileManager.createDirectory(at: iCloudURL, withIntermediateDirectories: true)
            }
            return iCloudURL
        }
        return localFallbackURL
    }

    // MARK: - Worries

    func loadWorries() async throws -> [Worry] {
        try await load(from: "worries.json")
    }

    func saveWorries(_ worries: [Worry]) async throws {
        try await save(worries, to: "worries.json")
    }

    func addWorry(_ worry: Worry) async throws {
        var worries = (try? await loadWorries()) ?? []
        worries.insert(worry, at: 0)
        try await saveWorries(worries)
    }

    // MARK: - Gratitudes

    func loadGratitudes() async throws -> [Gratitude] {
        try await load(from: "gratitudes.json")
    }

    func saveGratitudes(_ gratitudes: [Gratitude]) async throws {
        try await save(gratitudes, to: "gratitudes.json")
    }

    func addGratitude(_ gratitude: Gratitude) async throws {
        var gratitudes = (try? await loadGratitudes()) ?? []
        gratitudes.insert(gratitude, at: 0)
        try await saveGratitudes(gratitudes)
    }

    // MARK: - Moods

    func loadMoods() async throws -> [MoodEntry] {
        try await load(from: "moods.json")
    }

    func saveMoods(_ moods: [MoodEntry]) async throws {
        try await save(moods, to: "moods.json")
    }

    func addMood(_ mood: MoodEntry) async throws {
        var moods = (try? await loadMoods()) ?? []
        moods.insert(mood, at: 0)
        try await saveMoods(moods)
    }

    // MARK: - Generic File Operations

    private func load<T: Decodable>(from filename: String) async throws -> [T] {
        let fileURL = storageURL().appendingPathComponent(filename)

        guard fileManager.fileExists(atPath: fileURL.path) else {
            return []
        }

        let data = try Data(contentsOf: fileURL)
        return try decoder.decode([T].self, from: data)
    }

    private func save<T: Encodable>(_ items: [T], to filename: String) async throws {
        let fileURL = storageURL().appendingPathComponent(filename)
        let data = try encoder.encode(items)
        try data.write(to: fileURL, options: .atomic)
    }
}
