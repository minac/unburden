import SwiftUI

struct MoodView: View {
    @State private var viewModel = MoodViewModel()

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack(spacing: 24) {
            // Current mood display
            if let lastMood = viewModel.lastMood {
                VStack(spacing: 8) {
                    Text("Current mood")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text(lastMood.mood.emoji)
                        .font(.system(size: 64))

                    Text(lastMood.mood.label)
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text(lastMood.timestamp.relativeFormatted)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                .padding(.top, 20)
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
                        isSelected: viewModel.lastMood?.mood == mood
                    ) {
                        viewModel.selectMood(mood)
                    }
                }
            }
            .padding(.horizontal, 20)

            Spacer()
        }
        .navigationTitle("Mood")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadMoods()
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
