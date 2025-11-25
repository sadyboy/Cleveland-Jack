import Foundation
import SwiftUI
import Combine

enum ArticleDifficulty: String, CaseIterable, Codable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case expert = "Expert"
    
    var color: Color {
        switch self {
            case .beginner: return .green
            case .intermediate: return .orange
            case .advanced: return .red
            case .expert: return .purple
        }
    }
    
    var description: String {
        switch self {
            case .beginner: return "Fundamental concepts"
            case .intermediate: return "Some experience required"
            case .advanced: return "Complex topics"
            case .expert: return "Cutting-edge research"
        }
    }
}
