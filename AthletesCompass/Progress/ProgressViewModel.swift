import Foundation
import Combine

@MainActor
final class ProgressViewModel: ObservableObject {
    @Published var workoutHistory: [Workout] = []
    @Published var weeklyStats: WeeklyStats = .init()
    @Published var monthlyProgress: [ProgressData] = []
    @Published var isLoading = false
    
    @Published var selectedTimeFrame: TimeFrame = .week
    
    private var cancellables = Set<AnyCancellable>()
    


    func loadProgressData() {
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.workoutHistory = Workout.mockData.filter { $0.isCompleted }
            self.weeklyStats = WeeklyStats.mockData
            self.monthlyProgress = ProgressData.mockData
            self.isLoading = false
        }
    }
    
    var totalWorkouts: Int {
        workoutHistory.count
    }
    
    var totalMinutes: Int {
        workoutHistory.reduce(0) { $0 + Int($1.duration) / 60 }
    }
    
    var caloriesBurned: Double {
        workoutHistory.reduce(0) { result, workout in
            result + 300
        }
    }
}

struct WeeklyStats {
    var workoutsCompleted: Int = 0
    var totalMinutes: Int = 0
    var caloriesBurned: Double = 0
    var averageHeartRate: Double = 0
    
    static var mockData: WeeklyStats {
        WeeklyStats(
            workoutsCompleted: 4,
            totalMinutes: 120,
            caloriesBurned: 1200,
            averageHeartRate: 135
        )
    }
}

struct ProgressData: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
    let type: ProgressType
    
    static var mockData: [ProgressData] {
        var data: [ProgressData] = []
        let calendar = Calendar.current
        
        for i in 0..<30 {
            if let date = calendar.date(byAdding: .day, value: -i, to: Date()) {
                data.append(ProgressData(
                    date: date,
                    value: Double.random(in: 50...200),
                    type: .calories
                ))
            }
        }
        
        return data.sorted { $0.date < $1.date }
    }
}

enum ProgressType {
    case calories, minutes, workouts
}

enum TimeFrame {
    case week, month, year
}
