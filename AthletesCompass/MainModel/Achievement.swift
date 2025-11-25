import Foundation
import SwiftUI

struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
    let description: String
}
