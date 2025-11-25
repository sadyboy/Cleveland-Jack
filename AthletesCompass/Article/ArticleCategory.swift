import Foundation
import SwiftUI
import Combine

enum ArticleCategory: String, CaseIterable, Codable {
    case nutrition = "Nutrition"
    case training = "Training"
    case recovery = "Recovery"
    case psychology = "Psychology"
    case equipment = "Equipment"
    case science = "Science"
    case technique = "Technique"
    case programming = "Programming"
    
    var icon: String {
        switch self {
            case .nutrition: return "fork.knife"
            case .training: return "dumbbell"
            case .recovery: return "bed.double"
            case .psychology: return "brain.head.profile"
            case .equipment: return "bag"
            case .science: return "atom"
            case .technique: return "figure.run"
            case .programming: return "chart.line.uptrend.xyaxis"
        }
    }
    
    var color: Color {
        switch self {
            case .nutrition: return .green
            case .training: return .orange
            case .recovery: return .blue
            case .psychology: return .purple
            case .equipment: return .gray
            case .science: return .red
            case .technique: return .yellow
            case .programming: return .indigo
        }
    }
    
    var description: String {
        switch self {
            case .nutrition: return "Diet and supplementation strategies"
            case .training: return "Workout techniques and programs"
            case .recovery: return "Rest and regeneration methods"
            case .psychology: return "Mental performance and mindset"
            case .equipment: return "Gear reviews and recommendations"
            case .science: return "Evidence-based research"
            case .technique: return "Movement mastery and form"
            case .programming: return "Workout planning and periodization"
        }
    }
}
