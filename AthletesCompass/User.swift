import Foundation

struct User: Codable, Identifiable {
    let id: UUID
    var name: String
    var email: String
    var fitnessLevel: FitnessLevel
    var goals: [Goal]
    var joinDate: Date
    var statistics: UserStatistics
    
    init(id: UUID = UUID(), name: String, email: String, fitnessLevel: FitnessLevel = .beginner) {
        self.id = id
        self.name = name
        self.email = email
        self.fitnessLevel = fitnessLevel
        self.goals = []
        self.joinDate = Date()
        self.statistics = UserStatistics()
    }
}

struct UserStatistics: Codable {
    var totalWorkouts: Int = 0
    var totalMinutes: Int = 0
    var caloriesBurned: Double = 0
    var currentStreak: Int = 0
    var bestStreak: Int = 0
}

enum FitnessLevel: String, CaseIterable, Codable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case professional = "Professional"
}

struct Goal: Codable, Identifiable {
    let id: UUID
    var title: String
    var target: Double
    var current: Double
    var unit: String
    var deadline: Date?
    var isCompleted: Bool { current >= target }
}
