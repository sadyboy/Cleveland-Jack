import Foundation

struct ArticleQuizQuestion: Identifiable, Codable {
    let id = UUID()
    let question: String
    let correctAnswer: String
    let options: [String]?
}
