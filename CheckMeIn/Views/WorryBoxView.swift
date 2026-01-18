import SwiftUI

struct WorryBoxView: View {
    @State private var viewModel = WorryViewModel()
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            ZStack {
                if viewModel.showFadingText {
                    Text(viewModel.fadingText)
                        .font(.title2)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .opacity(viewModel.fadeOpacity)
                }

                if !viewModel.showFadingText {
                    VStack(spacing: 16) {
                        Image(systemName: "cloud.rain.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(.blue.opacity(0.6))

                        TextField("What's worrying you?", text: $viewModel.inputText, axis: .vertical)
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .focused($isTextFieldFocused)
                            .submitLabel(.done)
                            .onSubmit {
                                viewModel.submitWorry()
                            }
                            .padding(16)
                            .frame(minHeight: 100)
                            .background {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.regularMaterial)
                            }
                            .padding(.horizontal, 24)

                        Text("Tap above to type your worry")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .onTapGesture {
                        isTextFieldFocused = true
                    }
                }
            }
            .frame(maxWidth: .infinity)

            Spacer()

            if !viewModel.inputText.isEmpty && !viewModel.showFadingText {
                Button {
                    isTextFieldFocused = false
                    viewModel.submitWorry()
                } label: {
                    Text("Let it go")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.blue)
                        }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.inputText.isEmpty)
        .animation(.easeInOut(duration: 0.3), value: viewModel.showFadingText)
        .navigationTitle("Worry Box")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        WorryBoxView()
    }
}
