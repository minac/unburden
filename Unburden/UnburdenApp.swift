import SwiftUI

@main
struct UnburdenApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
            #if os(macOS)
                .frame(minWidth: 400, minHeight: 500)
            #endif
        }
        #if os(macOS)
        .defaultSize(width: 500, height: 600)
        .windowResizability(.contentSize)
        #endif
    }
}
