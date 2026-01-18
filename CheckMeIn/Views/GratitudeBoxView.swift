import SwiftUI

struct GratitudeBoxView: View {
    @State private var viewModel = GratitudeViewModel()
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            // Input section
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    TextField("What are you grateful for?", text: $viewModel.inputText)
                        .textFieldStyle(.plain)
                        .focused($isTextFieldFocused)
                        .submitLabel(.done)
                        .onSubmit {
                            viewModel.submitGratitude()
                        }

                    if !viewModel.inputText.isEmpty {
                        Button {
                            isTextFieldFocused = false
                            viewModel.submitGratitude()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.pink)
                        }
                    }
                }
                .padding(16)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.regularMaterial)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

            Divider()
                .padding(.horizontal, 20)

            // List section
            if viewModel.gratitudes.isEmpty {
                VStack(spacing: 16) {
                    Spacer()
                    Image(systemName: "heart.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(.pink.opacity(0.3))
                    Text("No gratitudes yet")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Text("Start by adding something you're grateful for")
                        .font(.subheadline)
                        .foregroundStyle(.tertiary)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .padding(.horizontal, 40)
            } else {
                ScrollViewReader { proxy in
                    List {
                        ForEach(viewModel.gratitudes) { gratitude in
                            GratitudeRow(gratitude: gratitude)
                                .id(gratitude.id)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
                        }
                    }
                    .listStyle(.plain)
                    .onChange(of: viewModel.gratitudes.count) { _, _ in
                        if let firstId = viewModel.gratitudes.first?.id {
                            withAnimation {
                                proxy.scrollTo(firstId, anchor: .top)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Gratitude Box")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadGratitudes()
        }
    }
}

struct GratitudeRow: View {
    let gratitude: Gratitude

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(gratitude.text)
                .font(.body)

            Text(gratitude.timestamp.relativeFormatted)
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(.regularMaterial)
        }
    }
}

extension Date {
    var relativeFormatted: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(self) {
            return "Today"
        } else if calendar.isDateInYesterday(self) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            return formatter.string(from: self)
        }
    }
}

#Preview {
    NavigationStack {
        GratitudeBoxView()
    }
}
