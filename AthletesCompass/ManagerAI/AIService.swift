import Foundation

protocol AIServiceProtocol {
    func sendMessage(_ message: String) async throws -> String
}

class AIService: AIServiceProtocol {
    func sendMessage(_ message: String) async throws -> String {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        let responses = [
            "To improve results in strength training, I recommend focusing on load progression and proper technique.",
            "The optimal time for cardio is in the morning on an empty stomach or after strength training. Start with 20-30 minutes 3-4 times a week.",
            "Recovery is key to progress. Make sure you get 7-9 hours of sleep and eat properly after training.",
            "To gain muscle mass, it's important to consume adequate protein—approximately 1.6-2.2 g per kg of body weight.",
            "Don't forget to warm up before and cool down after your workout—this will reduce the risk of injury and improve results."
            ]
        
        return responses.randomElement() ?? "I'm ready to help with your questions about training and nutrition."
    }
}
