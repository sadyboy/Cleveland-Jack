import Foundation
import SwiftUI

// MARK: - Enums
enum QACategory: String, CaseIterable {
    case training = "Training"
    case nutrition = "Nutrition"
    case recovery = "Recovery"
    case psychology = "Mindset"
    case technique = "Technique"
    case science = "Science"
    
    var icon: String {
        switch self {
        case .training: return "dumbbell"
        case .nutrition: return "fork.knife"
        case .recovery: return "bed.double"
        case .psychology: return "brain.head.profile"
        case .technique: return "figure.run"
        case .science: return "atom"
        }
    }
    
    var color: Color {
        switch self {
        case .training: return .orange
        case .nutrition: return .green
        case .recovery: return .blue
        case .psychology: return .purple
        case .technique: return .yellow
        case .science: return .red
        }
    }
    
    var description: String {
        switch self {
        case .training: return "Workout techniques and programs"
        case .nutrition: return "Diet and supplementation"
        case .recovery: return "Rest and regeneration"
        case .psychology: return "Mental performance"
        case .technique: return "Movement mastery"
        case .science: return "Evidence-based research"
        }
    }
}
