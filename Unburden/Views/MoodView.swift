import SwiftUI

struct MoodView: View {
    @State private var viewModel = MoodViewModel()
    @State private var selectedMoodThisSession: MoodType?
    @State private var showConfirmation = false

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack(spacing: 24) {
            // Header
            if showConfirmation, let mood = selectedMoodThisSession {
                VStack(spacing: 8) {
                    Text("Mood logged!")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text(mood.emoji)
                        .font(.system(size: 64))

                    Text(mood.label)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .padding(.top, 20)
                .transition(.opacity)
            } else {
                VStack(spacing: 8) {
                    Text("How are you feeling?")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text("Select a mood below")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 40)
            }

            Divider()
                .padding(.horizontal, 40)

            // Mood grid
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(MoodType.allCases, id: \.self) { mood in
                    MoodButton(
                        mood: mood,
                        isSelected: selectedMoodThisSession == mood
                    ) {
                        selectMood(mood)
                    }
                }
            }
            .padding(.horizontal, 20)

            Spacer()
        }
        .animation(.easeInOut(duration: 0.3), value: showConfirmation)
        .navigationTitle("Mood")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onAppear {
            // Reset selection each time view appears
            selectedMoodThisSession = nil
            showConfirmation = false
        }
    }

    private func selectMood(_ mood: MoodType) {
        selectedMoodThisSession = mood
        showConfirmation = true
        viewModel.selectMood(mood)

        // Reset after 2 seconds so user can select again
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(2))
            withAnimation {
                selectedMoodThisSession = nil
                showConfirmation = false
            }
        }
    }
}

struct MoodButton: View {
    let mood: MoodType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(mood.emoji)
                    .font(.system(size: 36))

                Text(mood.label)
                    .font(.caption)
                    .foregroundStyle(isSelected ? .primary : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? .orange.opacity(0.2) : .clear)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? .orange : .clear, lineWidth: 2)
                    }
            }
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: isSelected)
    }
}

#Preview {
    NavigationStack {
        MoodView()
    }
}
