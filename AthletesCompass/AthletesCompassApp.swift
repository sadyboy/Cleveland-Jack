import SwiftUI


class AppState: ObservableObject {
    @Published var selectedTab: Tab = .workouts
    @Published var user: User?
    @Published var isOnboardingCompleted = false
}

enum Tab {
    case dashboard, workouts, academy, brain, progress
}


@main
struct AthletesCompassApp: App {
    
    @StateObject private var appState = AppState()
    @AppStorage("isOnboardingCompleted") private var isOnboardingCompleted = false
    @StateObject private var workoutVM = WorkoutViewModel()
    @StateObject private var academyQAViewModel = FitnessQuestViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if isOnboardingCompleted {
                    ContentView()
                        .environmentObject(workoutVM)
                        .environmentObject(academyQAViewModel)
                        .environmentObject(appState)
                } else {
                    ZStack {
                        if appState.isOnboardingCompleted {
                            Color(.black)
//                                .resizable()
                                .ignoresSafeArea()
                        }
                        PreOnboardingView(isOnboardingCompleted: $isOnboardingCompleted)
                            .environmentObject(appState)
                            .environmentObject(workoutVM)
                            .environmentObject(academyQAViewModel)
                    }
                }
            }
            .colorScheme(.dark)
            .environment(\.colorScheme, .dark)
        }
    }
    private func setupAppearance() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor(Color.primary),
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
    }
}
