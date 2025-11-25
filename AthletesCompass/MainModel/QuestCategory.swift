import Foundation
import SwiftUI

// MARK: - Data Models
struct QuestCategory: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let icon: String
    let color: Color
    let completed: Int
    let total: Int
}
