import Foundation

struct Challenge: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let target: Int
    let currentProgress: Int
    let timeRemaining: String
    let rewardXP: Int
    let rewardCoins: Int
}
