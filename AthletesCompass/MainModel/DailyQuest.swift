import Foundation


struct DailyQuest: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let rewardXP: Int
    let rewardCoins: Int
    let isCompleted: Bool
}
