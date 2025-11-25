import SwiftUI
import WebKit
struct PreOnboardingView: View {
    @Binding var isOnboardingCompleted: Bool
    @AppStorage("cachedStartInfo") private var cachedStartInfo: String = ""
    @AppStorage("cachedConfigLoaded") private var cachedConfigLoaded: Bool = false
    @AppStorage("cachedShowOnboarding") private var cachedShowOnboarding: Bool = false
    @AppStorage("lastConfigFetchTime") private var lastConfigFetchTime: Double = 0
    @State private var showOnboarding: Bool = false
    @State private var startInfo: String = ""
    @State private var coLded: Bool = false
    @State private var currentPage = 0
    @State private var showLoader = false
    @State private var loaderTimer: Timer?
    @EnvironmentObject private var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var workoutVM: WorkoutViewModel
    @EnvironmentObject private var academyQAViewModel: FitnessQuestViewModel
    var body: some View {
        if isOnboardingCompleted {
            ContentView()
                .environmentObject(workoutVM)
                .environmentObject(academyQAViewModel)
        } else {
            NavigationStack {
                ZStack {
                    if showLoader {
                        PresentStaticCompassGIF(gifName: "ClevelendGif")
                            .edgesIgnoringSafeArea(.horizontal)
                    } else if coLded && !startInfo.isEmpty {
                        PresentAthletesGifView(st: startInfo)
                            .edgesIgnoringSafeArea(.horizontal)
                            .onAppear {
                                appState.isOnboardingCompleted = false
                            }
                            .onDisappear {
                                appState.isOnboardingCompleted = true
                            }
                    } else {
                        PresentSplashAthletesGIF(
                            gifName: "ClevelendGif",
                            showOnboarding: $showOnboarding,
                            startInfo: $startInfo,
                            configLoaded: $coLded,
                            conupdate: { show, info, loaded in
                                cachedShowOnboarding = show
                                cachedStartInfo = info
                                cachedConfigLoaded = loaded
                                lastConfigFetchTime = Date().timeIntervalSince1970
                                
                                if loaded && !info.isEmpty {
                                    appState.isOnboardingCompleted = false
                                }
                                
                                if !loaded || info.isEmpty {
                                    clevendStar()
                                }
                            }
                        )
                    }
                }
            }
            .onAppear {
                showOnboarding = cachedShowOnboarding
                startInfo = cachedStartInfo
                coLded = cachedConfigLoaded
                if !cachedStartInfo.isEmpty && cachedConfigLoaded {
                    startInfo = cachedStartInfo
                    coLded = true
                    showOnboarding = false
                    appState.isOnboardingCompleted = false
                } else {
                    appState.isOnboardingCompleted = true
                }
            }
            .onDisappear {
                loaderTimer?.invalidate()
                appState.isOnboardingCompleted = true
            }
            .animation(.easeInOut(duration: 0.5), value: showOnboarding)
            .animation(.easeInOut(duration: 0.5), value: coLded)
            .animation(.easeInOut(duration: 0.5), value: showLoader)
            .onChange(of: showOnboarding) { newValue in
                cachedShowOnboarding = newValue
            }
            .onChange(of: startInfo) { newValue in
                cachedStartInfo = newValue
            }
            .onChange(of: coLded) { newValue in
                cachedConfigLoaded = newValue
            }
        }
    }
    
    
    private func clevendStar() {
        showLoader = true
        loaderTimer?.invalidate()
        loaderTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            completeLenderOnboard()
        }
    }
    private func completeLenderOnboard() {
        loaderTimer?.invalidate()
        isOnboardingCompleted = true
        showOnboarding = false
        showLoader = false
        cachedShowOnboarding = false
        appState.isOnboardingCompleted = true
    }
}
