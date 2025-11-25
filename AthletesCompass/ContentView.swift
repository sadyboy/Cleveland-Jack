import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject private var workoutVM: WorkoutViewModel
    @EnvironmentObject private var academyQAViewModel: FitnessQuestViewModel
    var body: some View {
        VStack {
            MainTabView()
                .environmentObject(workoutVM)
                .environmentObject(academyQAViewModel)
                .environmentObject(appState)
            
        }
    }

}
