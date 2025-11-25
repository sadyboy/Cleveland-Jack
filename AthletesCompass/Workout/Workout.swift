import Foundation
import SwiftUI

// MARK: - Workout Model
struct Workout: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var description: String
    var duration: TimeInterval
    var difficulty: Difficulty
    var exercises: [Exercise]
    var category: WorkoutCategory
    var equipment: [Equipment]
    var imageName: String?
    var videoURL: URL?
    var isFeatured: Bool = false
    var isCompleted: Bool = false
    var dateCompleted: Date?
    var caloriesEstimate: Int?
    var targetMuscles: [MuscleGroup]
    var createdAt: Date
    var updatedAt: Date
    
    var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return minutes > 0 ? "\(minutes) min \(seconds > 0 ? "\(seconds) sec" : "")" : "\(seconds) sec"
    }
    
    var totalExercises: Int {
        exercises.count
    }
    
    var estimatedCalories: Int {
        caloriesEstimate ?? (exercises.count * 30) // Default estimation
    }
    
    // Performance metrics
    var averageCompletionTime: TimeInterval?
    var successRate: Double?
    var userRating: Double?
    
    init(id: UUID = UUID(),
         title: String,
         description: String,
         duration: TimeInterval,
         difficulty: Difficulty,
         exercises: [Exercise],
         category: WorkoutCategory,
         equipment: [Equipment] = [],
         imageName: String? = nil,
         videoURL: URL? = nil,
         isFeatured: Bool = false,
         caloriesEstimate: Int? = nil,
         targetMuscles: [MuscleGroup] = []) {
        self.id = id
        self.title = title
        self.description = description
        self.duration = duration
        self.difficulty = difficulty
        self.exercises = exercises
        self.category = category
        self.equipment = equipment
        self.imageName = imageName
        self.videoURL = videoURL
        self.isFeatured = isFeatured
        self.caloriesEstimate = caloriesEstimate
        self.targetMuscles = targetMuscles
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - Exercise Model
struct Exercise: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var instructions: String
    var videoURL: URL?
    var sets: Int?
    var reps: String?
    var restTime: TimeInterval?
    var demonstration: String?
    var tips: [String]
    var targetMuscles: [MuscleGroup]
    var equipment: [Equipment]
    var difficulty: ExerciseDifficulty
    var tempo: String? // e.g., "3-1-2" for eccentric-pause-concentric
    var rpe: Int? // Rate of Perceived Exertion 1-10
    var progression: ProgressionLevel?
    
    var formattedRestTime: String? {
        guard let restTime = restTime else { return nil }
        return restTime >= 60 ? "\(Int(restTime/60)) min" : "\(Int(restTime)) sec"
    }
    
    var totalTimeEstimate: TimeInterval? {
        guard let sets = sets, let restTime = restTime else { return nil }
        // Basic calculation: (work time + rest time) * sets
        let workTimePerSet: TimeInterval = 45 // Average 45 seconds per set
        return TimeInterval(sets) * (workTimePerSet + restTime)
    }
    
    init(id: UUID = UUID(),
         name: String,
         instructions: String,
         videoURL: URL? = nil,
         sets: Int? = nil,
         reps: String? = nil,
         restTime: TimeInterval? = nil,
         demonstration: String? = nil,
         tips: [String] = [],
         targetMuscles: [MuscleGroup] = [],
         equipment: [Equipment] = [],
         difficulty: ExerciseDifficulty = .beginner,
         tempo: String? = nil,
         rpe: Int? = nil,
         progression: ProgressionLevel? = nil) {
        self.id = id
        self.name = name
        self.instructions = instructions
        self.videoURL = videoURL
        self.sets = sets
        self.reps = reps
        self.restTime = restTime
        self.demonstration = demonstration
        self.tips = tips
        self.targetMuscles = targetMuscles
        self.equipment = equipment
        self.difficulty = difficulty
        self.tempo = tempo
        self.rpe = rpe
        self.progression = progression
    }
}


enum Difficulty: String, CaseIterable, Codable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case elite = "Elite"
    
    var color: Color {
        switch self {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        case .elite: return .purple
        }
    }
    
    var description: String {
        switch self {
        case .beginner: return "Perfect for starting your fitness journey"
        case .intermediate: return "For those with some training experience"
        case .advanced: return "Challenging workouts for experienced athletes"
        case .elite: return "Maximum intensity for peak performance"
        }
    }
    
    var icon: String {
        switch self {
        case .beginner: return "figure.walk"
        case .intermediate: return "figure.run"
        case .advanced: return "bolt"
        case .elite: return "crown"
        }
    }
}

// MARK: - Exercise Difficulty
enum ExerciseDifficulty: String, CaseIterable, Codable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    
    var description: String {
        switch self {
        case .beginner: return "Basic movement patterns"
        case .intermediate: return "Requires some coordination"
        case .advanced: return "Complex technical execution"
        }
    }
}

// MARK: - Workout Categories
enum WorkoutCategory: String, CaseIterable, Codable {
    case strength = "Strength"
    case cardio = "Cardio"
    case yoga = "Yoga"
    case hiit = "HIIT"
    case mobility = "Mobility"
    case recovery = "Recovery"
    case crossfit = "CrossFit"
    case calisthenics = "Calisthenics"
    case pilates = "Pilates"
    case sports = "Sports"
    
    var icon: String {
        switch self {
        case .strength: return "dumbbell"
        case .cardio: return "heart"
        case .yoga: return "leaf"
        case .hiit: return "bolt"
        case .mobility: return "figure.walk"
        case .recovery: return "bed.double"
        case .crossfit: return "flame"
        case .calisthenics: return "person"
        case .pilates: return "circle"
        case .sports: return "sportscourt"
        }
    }
    
    var color: Color {
        switch self {
        case .strength: return .orange
        case .cardio: return .red
        case .yoga: return .green
        case .hiit: return .purple
        case .mobility: return .blue
        case .recovery: return .indigo
        case .crossfit: return .brown
        case .calisthenics: return .teal
        case .pilates: return .pink
        case .sports: return .yellow
        }
    }
    
    var description: String {
        switch self {
        case .strength: return "Build muscle and increase power"
        case .cardio: return "Improve cardiovascular health"
        case .yoga: return "Enhance flexibility and mindfulness"
        case .hiit: return "High-intensity interval training"
        case .mobility: return "Improve joint health and range of motion"
        case .recovery: return "Active recovery and regeneration"
        case .crossfit: return "Constantly varied functional movements"
        case .calisthenics: return "Bodyweight mastery and control"
        case .pilates: return "Core strength and postural alignment"
        case .sports: return "Sport-specific conditioning"
        }
    }
}

// MARK: - Equipment
enum Equipment: String, CaseIterable, Codable {
    case none = "No Equipment"
    case dumbbells = "Dumbbells"
    case resistanceBands = "Resistance Bands"
    case yogaMat = "Yoga Mat"
    case kettlebell = "Kettlebell"
    case pullUpBar = "Pull-up Bar"
    case barbell = "Barbell"
    case weightPlates = "Weight Plates"
    case bench = "Bench"
    case trx = "TRX"
    case medicineBall = "Medicine Ball"
    case jumpRope = "Jump Rope"
    case foamRoller = "Foam Roller"
    
    var icon: String {
        switch self {
        case .none: return "xmark"
        case .dumbbells: return "dumbbell"
        case .resistanceBands: return "bandage"
        case .yogaMat: return "square"
        case .kettlebell: return "circle"
        case .pullUpBar: return "line.diagonal"
        case .barbell: return "line.horizontal.3"
        case .weightPlates: return "circle.grid.2x2"
        case .bench: return "rectangle"
        case .trx: return "lines.measurement.horizontal"
        case .medicineBall: return "circle.circle"
        case .jumpRope: return "waveform.path"
        case .foamRoller: return "cylinder"
        }
    }
}

// MARK: - Muscle Groups
enum MuscleGroup: String, CaseIterable, Codable {
    case chest = "Chest"
    case back = "Back"
    case shoulders = "Shoulders"
    case biceps = "Biceps"
    case triceps = "Triceps"
    case quadriceps = "Quadriceps"
    case hamstrings = "Hamstrings"
    case glutes = "Glutes"
    case calves = "Calves"
    case abs = "Abdominals"
    case obliques = "Obliques"
    case forearms = "Forearms"
    case traps = "Trapezius"
    case lats = "Latissimus Dorsi"
    case delts = "Deltoids"
    case core = "Core"
    case fullBody = "Full Body"
    
    var icon: String {
        switch self {
        case .chest: return "heart"
        case .back: return "arrow.turn.right.up"
        case .shoulders: return "circle"
        case .biceps: return "arm"
        case .triceps: return "arm"
        case .quadriceps: return "leg"
        case .hamstrings: return "leg"
        case .glutes: return "circle"
        case .calves: return "leg"
        case .abs: return "square"
        case .obliques: return "triangle"
        case .forearms: return "arm"
        case .traps: return "shoulder"
        case .lats: return "arrow.down.left"
        case .delts: return "circle"
        case .core: return "target"
        case .fullBody: return "person"
        }
    }
}

// MARK: - Progression Levels
enum ProgressionLevel: String, CaseIterable, Codable {
    case regression = "Regression"
    case standard = "Standard"
    case progression = "Progression"
    
    var description: String {
        switch self {
        case .regression: return "Easier variation"
        case .standard: return "Standard execution"
        case .progression: return "Advanced variation"
        }
    }
}

// MARK: - Workout Statistics
struct WorkoutStatistics: Codable {
    var totalWorkouts: Int
    var totalDuration: TimeInterval
    var caloriesBurned: Double
    var favoriteCategory: WorkoutCategory?
    var averageDifficulty: Double
    var completionRate: Double
    var streak: Int
    var personalRecords: [PersonalRecord]
}

// MARK: - Personal Record
struct PersonalRecord: Identifiable, Codable {
    let id: UUID
    var exercise: Exercise
    var value: String // e.g., "100 kg", "20 reps"
    var date: Date
    var notes: String?
}

// MARK: - Workout Session
struct WorkoutSession: Identifiable, Codable {
    let id: UUID
    var workout: Workout
    var startTime: Date
    var endTime: Date?
    var completedExercises: [CompletedExercise]
    var notes: String?
    var rating: Int?
    var perceivedExertion: Int?
    
    var duration: TimeInterval? {
        guard let endTime = endTime else { return nil }
        return endTime.timeIntervalSince(startTime)
    }
    
    var isCompleted: Bool {
        endTime != nil
    }
}

// MARK: - Completed Exercise
struct CompletedExercise: Identifiable, Codable {
    let id: UUID
    var exercise: Exercise
    var actualSets: Int
    var actualReps: [String] // Reps for each set
    var weights: [Double]? // Weight for each set
    var restTimes: [TimeInterval]? // Actual rest times
    var notes: String?
}

// MARK: - Extension for Sample Data
extension Workout {
    static var sampleFeatured: Workout {
        Workout(
            title: "Full Body Strength",
            description: "Complete strength workout targeting all major muscle groups with compound movements",
            duration: 2700, // 45 minutes
            difficulty: .intermediate,
            exercises: Exercise.sampleStrengthExercises,
            category: .strength,
            equipment: [.dumbbells, .bench],
            isFeatured: true,
            caloriesEstimate: 320,
            targetMuscles: [.chest, .back, .shoulders, .lats, .core]
        )
    }
    
    static var sampleHIIT: Workout {
        Workout(
            title: "Metabolic Conditioning",
            description: "High-intensity intervals to boost metabolism and burn fat",
            duration: 1200, // 20 minutes
            difficulty: .advanced,
            exercises: Exercise.sampleHIITExercises,
            category: .hiit,
            equipment: [.none],
            isFeatured: true,
            caloriesEstimate: 280,
            targetMuscles: [.fullBody, .core]
        )
    }
}

extension Exercise {
    static var sampleStrengthExercises: [Exercise] {
        [
            Exercise(
                name: "Barbell Squat",
                instructions: "Stand with feet shoulder-width apart, bar resting on upper back. Lower until thighs are parallel to floor, then drive back up.",
                sets: 4,
                reps: "8-12",
                restTime: 90,
                tips: ["Keep chest up", "Drive through heels", "Maintain neutral spine"],
                targetMuscles: [.quadriceps, .glutes, .hamstrings],
                equipment: [.barbell],
                difficulty: .intermediate,
                tempo: "3-1-1"
            ),
            Exercise(
                name: "Bench Press",
                instructions: "Lie on bench with feet flat. Lower bar to chest, then press back to starting position.",
                sets: 4,
                reps: "8-12",
                restTime: 90,
                tips: ["Keep shoulders packed", "Maintain arch in lower back"],
                targetMuscles: [.chest, .shoulders, .triceps],
                equipment: [.barbell, .bench],
                difficulty: .intermediate
            )
        ]
    }
    
    static var sampleHIITExercises: [Exercise] {
        [
            Exercise(
                name: "Burpees",
                instructions: "From standing, drop to plank, perform push-up, then jump back to standing with overhead clap.",
                sets: 5,
                reps: "30 sec",
                restTime: 20,
                tips: ["Maintain pace", "Full extension at top"],
                targetMuscles: [.fullBody, .core],
                equipment: [.none],
                difficulty: .intermediate
            ),
            Exercise(
                name: "Mountain Climbers",
                instructions: "In plank position, alternate bringing knees to chest in running motion.",
                sets: 5,
                reps: "30 sec",
                restTime: 20,
                tips: ["Keep core tight", "Maintain steady rhythm"],
                targetMuscles: [.core, .shoulders],
                equipment: [.none],
                difficulty: .beginner
            )
        ]
    }
}
