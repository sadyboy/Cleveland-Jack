import Foundation
import Combine

@MainActor
final class WorkoutViewModel: ObservableObject {
    @Published var workouts: [Workout] = []
    @Published var filteredWorkouts: [Workout] = []
    @Published var featuredWorkouts: [Workout] = []
    @Published var selectedCategory: WorkoutCategory? = nil
    @Published var selectedDifficulty: Difficulty? = nil
    @Published var isLoading = false
    @Published var error: AppError?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadWorkouts()
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        $workouts
            .combineLatest($selectedCategory, $selectedDifficulty)
            .map { workouts, category, difficulty in
                var filtered = workouts
                
                if let category = category {
                    filtered = filtered.filter { $0.category == category }
                }
                
                if let difficulty = difficulty {
                    filtered = filtered.filter { $0.difficulty == difficulty }
                }
                
                return filtered
            }
            .assign(to: &$filteredWorkouts)
        
        $workouts
            .map { $0.filter { $0.isFeatured } }
            .assign(to: &$featuredWorkouts)
    }
    
    func loadWorkouts() {
        isLoading = true
        error = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.workouts = Workout.mockData
            self.isLoading = false
        }
    }
    
    func markWorkoutAsCompleted(_ workout: Workout) {
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts[index].isCompleted = true
            workouts[index].dateCompleted = Date()
        }
    }
    
    func resetFilters() {
        selectedCategory = nil
        selectedDifficulty = nil
    }
}

// MARK: - Mock Data
extension Workout {
    static var mockData: [Workout] = [
        Workout(
            id: UUID(),
            title: "Strength Workout for Beginners",
            description: "Basic Workout for Overall Strength",
            duration: 1800,
            difficulty: .beginner,
            exercises: [
                Exercise(
                    id: UUID(),
                    name: "Squats",
                    instructions: "Stand with feet shoulder-width apart. Lower into a squat and rise back up.",
                    sets: 3,
                    reps: "12-15",
                    restTime: 60,
                    demonstration: "Keep your back straight, knees behind toes",
                    tips: ["Breathe deeply", "Control the movement"]
                )
            ],
            category: .strength,
            equipment: [.none],
            isFeatured: true
        ),

        Workout(
            id: UUID(),
            title: "HIIT Intervals",
            description: "High-Intensity Interval Training for Fat Burning",
            duration: 1200,
            difficulty: .intermediate,
            exercises: [
                Exercise(
                    id: UUID(),
                    name: "Burpee",
                    instructions: "From standing, drop to plank, perform push-up, jump explosively upward.",
                    sets: 4,
                    reps: "30 sec",
                    restTime: 20,
                    tips: ["Keep the pace", "Don’t skip steps"]
                )
            ],
            category: .hiit,
            equipment: [.none],
            isFeatured: true
        ),

        // -----------------------
        // New Workouts Below
        // -----------------------

        Workout(
            id: UUID(),
            title: "Core Stability Routine",
            description: "Strengthen your core with focused exercises",
            duration: 1500,
            difficulty: .beginner,
            exercises: [
                Exercise(
                    id: UUID(),
                    name: "Plank Hold",
                    instructions: "Hold plank position on elbows keeping body straight.",
                    sets: 3,
                    reps: "45 sec",
                    restTime: 30,
                    tips: ["Engage your core", "Don’t let hips drop"]
                ),
                Exercise(
                    id: UUID(),
                    name: "Russian Twist",
                    instructions: "Sit, lean back slightly, rotate torso side to side.",
                    sets: 3,
                    reps: "20",
                    restTime: 20
                )
            ],
            category: .cardio,
            equipment: [.none],
            isFeatured: false
        ),

        Workout(
            id: UUID(),
            title: "Full Body Mobility Flow",
            description: "Improve flexibility and joint control",
            duration: 1800,
            difficulty: .beginner,
            exercises: [
                Exercise(
                    id: UUID(),
                    name: "Cat-Cow",
                    instructions: "Alternate arching and rounding your back while on all fours.",
                    sets: 2,
                    reps: "15",
                    restTime: 10
                ),
                Exercise(
                    id: UUID(),
                    name: "Hip Circles",
                    instructions: "Move your hips in a circular motion while standing.",
                    sets: 2,
                    reps: "10 per side",
                    restTime: 10
                )
            ],
            category: .mobility,
            equipment: [.none],
            isFeatured: false
        ),

        Workout(
            id: UUID(),
            title: "Endurance Run Prep",
            description: "Light cardio warm-up for longer running days",
            duration: 2400,
            difficulty: .intermediate,
            exercises: [
                Exercise(
                    id: UUID(),
                    name: "Jog in Place",
                    instructions: "Light jogging motion on the spot.",
                    sets: 3,
                    reps: "3 min",
                    restTime: 30
                ),
                Exercise(
                    id: UUID(),
                    name: "High Knees",
                    instructions: "Bring your knees high while running in place.",
                    sets: 3,
                    reps: "45 sec",
                    restTime: 20
                )
            ],
            category: .cardio,
            equipment: [.none],
            isFeatured: false
        ),

        Workout(
            id: UUID(),
            title: "Upper Body Strength",
            description: "Compound pushes and pulls",
            duration: 2100,
            difficulty: .intermediate,
            exercises: [
                Exercise(
                    id: UUID(),
                    name: "Push-Ups",
                    instructions: "Lower your body until elbows reach 90 degrees, then push back.",
                    sets: 4,
                    reps: "10-15",
                    restTime: 60,
                    tips: ["Keep elbows at 45°", "Engage your core"]
                ),
                Exercise(
                    id: UUID(),
                    name: "Bent-Over Rows",
                    instructions: "Bend your back slightly and pull dumbbells toward waist.",
                    sets: 4,
                    reps: "12",
                    restTime: 60,
                    tips: ["Keep back neutral"]
                )
            ],
            category: .strength,
            equipment: [.dumbbells],
            isFeatured: false
        ),

        Workout(
            id: UUID(),
            title: "Leg Day Builder",
            description: "Develop power and muscle in legs",
            duration: 2700,
            difficulty: .advanced,
            exercises: [
                Exercise(
                    id: UUID(),
                    name: "Lunges",
                    instructions: "Step forward, lower hips until both knees at 90°.",
                    sets: 4,
                    reps: "12 per leg",
                    restTime: 40
                ),
                Exercise(
                    id: UUID(),
                    name: "Glute Bridge",
                    instructions: "Lift hips upwards from a lying position.",
                    sets: 4,
                    reps: "20",
                    restTime: 30
                )
            ],
            category: .strength,
            equipment: [.none],
            isFeatured: false
        )
    ]
}
