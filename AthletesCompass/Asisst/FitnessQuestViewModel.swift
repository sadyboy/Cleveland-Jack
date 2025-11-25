import Foundation
import SwiftUI
import Combine
// MARK: - ViewModel
@MainActor
final class FitnessQuestViewModel: ObservableObject {
    @Published var playerLevel = 5
    @Published var experiencePoints = 50 {
        didSet {
            generateMonthlyXP()
        }
    }
    @Published var coins = 40
    @Published var completedQuests = 13
    @Published var totalQuests = 50
    @Published var levelProgress: Double = 0.65
    @Published var isLoading = false
    @Published var showProfile = false
    @Published var shouldCelebrate = false
    
    // Quest data
    @Published var questCategories: [QuestCategory] = []
    @Published var currentChallenge: Challenge?
    @Published var dailyQuests: [DailyQuest] = []
    @Published var knowledgeCards: [KnowledgeCarde] = []
    @Published var earnedAchievements: [UUID] = []
    @Published var allAchievements: [Achievement] = []
    @Published var monthlyXP: [ProgressPoint] = []
    var timeUntilReset: String {
        "4h 23m"
    }
    @Published var masteredKnowledge: Int = 0

    init() {
        loadGameData()
        generateMonthlyXP()
    }
    func updateAllStats() {
        updateLevelProgress()
           updateMasteredKnowledge()
           updateCompletedQuests()
    }
    func updateMasteredKnowledge() {
        masteredKnowledge = knowledgeCards.filter { $0.isMastered }.count
    }
    
   
    func loadGameData() {
        isLoading = true
        
        // Simulate loading game data
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            
            self.questCategories = [
                QuestCategory(name: "Strength", description: "Power lifting quests", icon: "dumbbell", color: .white, completed: 8, total: 12),
                QuestCategory(name: "Cardio", description: "Endurance challenges", icon: "heart", color: .white, completed: 5, total: 10),
                QuestCategory(name: "Nutrition", description: "Diet mastery", icon: "fork.knife", color: .white, completed: 6, total: 8),
                QuestCategory(name: "Recovery", description: "Rest & regeneration", icon: "bed.double", color: .white, completed: 4, total: 8)
            ]
            
            self.currentChallenge = Challenge(
                title: "Weekly Strength Challenge",
                description: "Complete 15 strength training sessions this week",
                target: 15,
                currentProgress: 9,
                timeRemaining: "3 days",
                rewardXP: 250,
                rewardCoins: 100
            )
            
            self.dailyQuests = [
                DailyQuest(title: "Morning Workout", icon: "sunrise", rewardXP: 25, rewardCoins: 10, isCompleted: true),
                DailyQuest(title: "Drink 2L Water", icon: "drop", rewardXP: 15, rewardCoins: 5, isCompleted: false),
                DailyQuest(title: "Learn 3 Facts", icon: "brain", rewardXP: 20, rewardCoins: 8, isCompleted: false),
                DailyQuest(title: "Stretch Session", icon: "figure.walk", rewardXP: 10, rewardCoins: 3, isCompleted: true)
            ]
            
            // 10 quiz questions for each category
            self.knowledgeCards = [
                // Training Questions (10)
                KnowledgeCarde(questionNumber: 1, question: "What's the optimal rest time between sets for muscle growth?", answer: "60-90 seconds for hypertrophy training allows sufficient recovery while maintaining metabolic stress.", category: .training, isMastered: false),
                KnowledgeCarde(questionNumber: 2, question: "How many times per week should you train each muscle group?", answer: "2-3 times per week is optimal for most trainees to maximize muscle protein synthesis.", category: .training, isMastered: true),
                KnowledgeCarde(questionNumber: 3, question: "What is progressive overload?", answer: "Gradually increasing training stress over time by adding weight, reps, or sets to force adaptation.", category: .training, isMastered: false),
                KnowledgeCarde(questionNumber: 4, question: "What's the difference between compound and isolation exercises?", answer: "Compound exercises work multiple muscle groups (squats, bench), while isolation target one muscle (bicep curls).", category: .training, isMastered: false),
                KnowledgeCarde(questionNumber: 5, question: "How important is proper form during exercises?", answer: "Critical - proper form prevents injury and ensures target muscles are effectively engaged.", category: .training, isMastered: true),
                KnowledgeCarde(questionNumber: 6, question: "What's the mind-muscle connection?", answer: "Consciously focusing on the target muscle during exercise to improve activation and results.", category: .training, isMastered: false),
                KnowledgeCarde(questionNumber: 7, question: "How long should a typical workout last?", answer: "45-75 minutes is ideal. Longer sessions can increase cortisol levels and hinder recovery.", category: .training, isMastered: false),
                KnowledgeCarde(questionNumber: 8, question: "What is training to failure?", answer: "Performing reps until you cannot complete another with proper form. Best used sparingly.", category: .training, isMastered: false),
                KnowledgeCarde(questionNumber: 9, question: "How do you prevent workout plateaus?", answer: "Regularly change exercises, rep ranges, and training variables to shock the muscles.", category: .training, isMastered: false),
                KnowledgeCarde(questionNumber: 10, question: "What's the best time of day to workout?", answer: "Whenever you can be consistent. Morning workouts may boost metabolism throughout the day.", category: .training, isMastered: false),
                
                // Nutrition Questions (10)
                KnowledgeCarde(questionNumber: 1, question: "What's the optimal protein intake for muscle growth?", answer: "1.6-2.2g per kg of body weight daily supports maximum muscle protein synthesis.", category: .nutrition, isMastered: true),
                KnowledgeCarde(questionNumber: 2, question: "How important are carbohydrates for workout performance?", answer: "Very important - carbs provide glycogen, the primary fuel source for intense training.", category: .nutrition, isMastered: false),
                KnowledgeCarde(questionNumber: 3, question: "What's the anabolic window after workouts?", answer: "The 1-2 hour post-workout period where nutrient uptake is enhanced for recovery.", category: .nutrition, isMastered: false),
                KnowledgeCarde(questionNumber: 4, question: "How much water should athletes drink daily?", answer: "3-4 liters minimum, more if training intensely or in hot environments.", category: .nutrition, isMastered: false),
                KnowledgeCarde(questionNumber: 5, question: "What are essential amino acids?", answer: "The 9 amino acids your body cannot produce that must come from food for muscle repair.", category: .nutrition, isMastered: false),
                KnowledgeCarde(questionNumber: 6, question: "Is timing meals around workouts important?", answer: "Yes - pre-workout carbs fuel performance, post-workout protein aids recovery.", category: .nutrition, isMastered: true),
                KnowledgeCarde(questionNumber: 7, question: "What role do healthy fats play in fitness?", answer: "Fats support hormone production, joint health, and energy for longer workouts.", category: .nutrition, isMastered: false),
                KnowledgeCarde(questionNumber: 8, question: "How does fiber intake affect athletes?", answer: "Important for digestion but timing around workouts matters to avoid discomfort.", category: .nutrition, isMastered: false),
                KnowledgeCarde(questionNumber: 9, question: "What are the benefits of meal timing?", answer: "Spreading protein across 4-6 meals maximizes muscle synthesis throughout the day.", category: .nutrition, isMastered: false),
                KnowledgeCarde(questionNumber: 10, question: "How do you calculate maintenance calories?", answer: "Body weight (kg) × 30 + training calories. Adjust based on goals and progress.", category: .nutrition, isMastered: false),
                
                // Recovery Questions (10)
                KnowledgeCarde(questionNumber: 1, question: "How much sleep do athletes need for optimal recovery?", answer: "7-9 hours quality sleep. Growth hormone peaks during deep sleep stages.", category: .recovery, isMastered: false),
                KnowledgeCarde(questionNumber: 2, question: "What causes muscle soreness (DOMS)?", answer: "Micro-tears in muscle fibers and inflammation, not lactic acid buildup.", category: .recovery, isMastered: false),
                KnowledgeCarde(questionNumber: 3, question: "How effective is foam rolling for recovery?", answer: "Very effective - reduces muscle tension, improves circulation, and enhances mobility.", category: .recovery, isMastered: false),
                KnowledgeCarde(questionNumber: 4, question: "What's the ideal time to stretch?", answer: "After workouts when muscles are warm. Dynamic stretching pre-workout, static post-workout.", category: .recovery, isMastered: true),
                KnowledgeCarde(questionNumber: 5, question: "How does stress affect recovery?", answer: "High cortisol from stress impairs protein synthesis and increases muscle breakdown.", category: .recovery, isMastered: false),
                KnowledgeCarde(questionNumber: 6, question: "What are deload weeks?", answer: "Reduced training volume every 4-8 weeks to allow supercompensation and prevent overtraining.", category: .recovery, isMastered: false),
                KnowledgeCarde(questionNumber: 7, question: "How important is hydration for recovery?", answer: "Critical - water transports nutrients, removes waste, and supports cellular functions.", category: .recovery, isMastered: false),
                KnowledgeCarde(questionNumber: 8, question: "What's active recovery?", answer: "Light exercise like walking or yoga that promotes blood flow without stressing muscles.", category: .recovery, isMastered: false),
                KnowledgeCarde(questionNumber: 9, question: "How do cold showers affect recovery?", answer: "Reduce inflammation and soreness but may blunt some muscle growth adaptations.", category: .recovery, isMastered: false),
                KnowledgeCarde(questionNumber: 10, question: "What signs indicate overtraining?", answer: "Persistent fatigue, decreased performance, mood changes, and increased resting heart rate.", category: .recovery, isMastered: false)
            ]
            
            self.allAchievements = [
                Achievement(title: "First Workout", icon: "1.circle", color: .white, description: "Complete your first workout"),
                Achievement(title: "Week Warrior", icon: "7.circle", color: .white, description: "7 consecutive workout days"),
                Achievement(title: "Knowledge Master", icon: "brain", color: .white, description: "Master 50 knowledge cards"),
                Achievement(title: "Strength Pro", icon: "dumbbell", color: .white, description: "Reach level 10 in strength"),
                Achievement(title: "Cardio King", icon: "heart", color: .white, description: "Complete 30 cardio sessions"),
                Achievement(title: "Quest Complete", icon: "flag", color: .white, description: "Finish all main quests")
            ]
            
            self.earnedAchievements = [self.allAchievements[0].id, self.allAchievements[1].id]
            
            self.isLoading = false
        }
    }
    
    func generateMonthlyXP() {
        monthlyXP = (0..<30).compactMap { offset in
            if let date = Calendar.current.date(byAdding: .day, value: -offset, to: Date()) {
                let value = Double.random(in: 50...250) + Double(experiencePoints) * 0.002
                return ProgressPoint(date: date, value: value)
            }
            return nil
        }.sorted { $0.date < $1.date }
    }
    
    func completeChallenge(_ challenge: Challenge) {
        experiencePoints += challenge.rewardXP
        coins += challenge.rewardCoins
        completedQuests += 1

        updateAllStats()
        shouldCelebrate = true
    }
    
    func updateCompletedQuests() {
        completedQuests = dailyQuests.filter { $0.isCompleted }.count
    }
    
    func completeDailyQuest(_ quest: DailyQuest) {
        experiencePoints += quest.rewardXP
        coins += quest.rewardCoins
        updateLevelProgress()
        updateCompletedQuests()
    }
    
    func masterCard(_ card: KnowledgeCarde) {
        if let index = knowledgeCards.firstIndex(where: { $0.id == card.id }) {
            knowledgeCards[index] = KnowledgeCarde(
                questionNumber: knowledgeCards[index].questionNumber,
                question: knowledgeCards[index].question,
                answer: knowledgeCards[index].answer,
                category: knowledgeCards[index].category,
                isMastered: true
            )
        }

        experiencePoints += 10
        coins += 5
        
        updateAllStats()
    }
    
    func studyAllCards() {
        experiencePoints += 30
        coins += 15
        updateLevelProgress()
    }
    
    private func updateLevelProgress() {
        let progress = Double(experiencePoints % 1000) / 1000.0
        levelProgress = progress
        
        if progress == 0 && experiencePoints > (playerLevel * 1000) {
            playerLevel += 1
            shouldCelebrate = true
        }
    }
}
extension KnowledgeCarde {
    static var sampleCards: [KnowledgeCard] = [
        KnowledgeCard(
            question: "What's the optimal protein intake for muscle growth?",
            answer: "Research recommends 1.6-2.2g of protein per kg of body weight daily for optimal muscle protein synthesis. Spread intake across 4-6 meals for maximum absorption.",
            category: .nutrition,
            isMastered: false
        ),
        
        KnowledgeCard(
            question: "How long should you rest between sets for hypertrophy?",
            answer: "60-90 seconds rest between sets is ideal for muscle growth. This allows sufficient recovery while maintaining metabolic stress.",
            category: .training,
            isMastered: true
        ),
        
        KnowledgeCard(
            question: "What's the most effective post-workout recovery method?",
            answer: "Active recovery, proper nutrition (protein + carbs), and quality sleep are the most effective. Foam rolling and contrast showers can also help.",
            category: .recovery,
            isMastered: false
        ),
        
        KnowledgeCard(
            question: "How does the mind-muscle connection affect growth?",
            answer: "Focusing on the target muscle during exercises can increase activation by 10-20%, leading to better muscle development and technique.",
            category: .psychology,
            isMastered: false
        ),
        
        KnowledgeCard(
            question: "What's the proper squat depth for maximum benefits?",
            answer: "Going to parallel (hips at knee level) or slightly below engages maximum muscle fibers while maintaining spinal safety.",
            category: .technique,
            isMastered: true
        ),
        
        KnowledgeCard(
            question: "What causes muscle soreness (DOMS)?",
            answer: "Delayed Onset Muscle Soreness is caused by micro-tears in muscle fibers and inflammation, not lactic acid buildup.",
            category: .science,
            isMastered: false
        ),
        
        KnowledgeCard(
            question: "How many times per week should you train each muscle group?",
            answer: "2-3 times per week is optimal for most trainees. Beginners can benefit from full-body workouts 3x weekly.",
            category: .training,
            isMastered: false
        ),
        
        KnowledgeCard(
            question: "What's the role of carbohydrates in performance?",
            answer: "Carbs provide glycogen for energy. Timing intake around workouts can improve performance and recovery.",
            category: .nutrition,
            isMastered: true
        ),
        
        KnowledgeCard(
            question: "How important is sleep for muscle recovery?",
            answer: "Critical. Growth hormone peaks during deep sleep, and protein synthesis occurs most efficiently during rest.",
            category: .recovery,
            isMastered: false
        ),
        
        KnowledgeCard(
            question: "What's progressive overload and why is it important?",
            answer: "Gradually increasing training stress over time. It's the fundamental principle for continuous strength and muscle gains.",
            category: .training,
            isMastered: true
        )
    ]
}
