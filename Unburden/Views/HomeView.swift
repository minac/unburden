import SwiftUI

struct HomeView: View {
    @State private var themeManager = ThemeManager.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    NavigationLink(destination: WorryBoxView()) {
                        BoxCard(
                            title: "Worry Box",
                            subtitle: "Let go of what's troubling you",
                            icon: "cloud.rain.fill",
                            color: .blue
                        )
                    }

                    NavigationLink(destination: GratitudeBoxView()) {
                        BoxCard(
                            title: "Gratitude Box",
                            subtitle: "Celebrate the good things",
                            icon: "heart.fill",
                            color: .pink
                        )
                    }

                    NavigationLink(destination: MoodView()) {
                        BoxCard(
                            title: "Mood",
                            subtitle: "How are you feeling?",
                            icon: "face.smiling.fill",
                            color: .orange
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
            }
            .navigationTitle("Unburden")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            themeManager.toggle()
                        }
                    } label: {
                        Image(systemName: themeManager.currentTheme.icon)
                            .font(.title2)
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
        .preferredColorScheme(themeManager.currentTheme.colorScheme)
    }
}

struct BoxCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundStyle(color)
                .frame(width: 50)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.body)
                .foregroundStyle(.tertiary)
        }
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(.regularMaterial)
        }
    }
}

#Preview {
    HomeView()
}
