import SwiftUI


 struct FitnessQuestView: View {
    @StateObject private var viewModel = FitnessQuestViewModel()
    @State private var showCelebration = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerSection
                    
                    if viewModel.isLoading {
                        loadingView
                    } else {
                        ScrollView {
                            VStack(spacing: 24) {
                                progressSection
                                
                                if viewModel.currentChallenge != nil {
                                    currentChallengeSection
                                }
                                
                                dailyQuestsSection
                                
                                knowledgeCardsSection
                                
                                achievementsSection
                            }
                            .padding(.vertical)
                        }
                    }
                }
                
                // Celebration overlay
                if showCelebration {
                    CelebrationOverlay(isShowing: $showCelebration)
                }
            }
            .navigationTitle("Fitness Quest")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.showProfile.toggle()
                    } label: {
                        Image(systemName: "person.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showProfile) {
                PlayerProfileView(viewModel: viewModel)
            }
            .onChange(of: viewModel.shouldCelebrate) { shouldCelebrate in
                if shouldCelebrate {
                    showCelebration = true
                    viewModel.shouldCelebrate = false
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("FITNESS QUEST")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("Level \(viewModel.playerLevel)")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // XP and coins
                VStack(spacing: 8) {
                    HStack(spacing: 12) {
                        HStack(spacing: 6) {
                            Text("🇫🇲")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                            
                            Text("\(viewModel.experiencePoints)")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        
                        HStack(spacing: 6) {
                            Text("🪙")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                            
                            Text("\(viewModel.coins)")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                    }
                    
                    // Progress to next level
                    ProgressBar(value: viewModel.levelProgress, color: .white)
                        .frame(height: 6)
                }
                .padding(12)
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
            }
            .padding(.horizontal, 24)
        }
        .padding(.vertical, 16)
        .background(Color.white.opacity(0.05))
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ProgressView()
                .scaleEffect(1.5)
                .tint(.white)
            
            VStack(spacing: 12) {
                Text("Preparing Your Quest")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Loading challenges and rewards...")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
        }
    }
    
    // MARK: - Progress Section
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Quest Progress")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(viewModel.completedQuests)/\(viewModel.totalQuests)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(.horizontal, 24)
            
            // Quest progress bars
            VStack(spacing: 12) {
                ForEach(viewModel.questCategories) { category in
                    QuestCategoryRow(category: category, viewModel: viewModel)
                }
            }
            .padding(.horizontal, 24)
        }
    }
    
    // MARK: - Current Challenge
    private var currentChallengeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Active Challenge")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "flame.fill")
                    .foregroundColor(.white)
                    .font(.title3)
            }
            .padding(.horizontal, 24)
            
            if let challenge = viewModel.currentChallenge {
                CurrentChallengeCard(challenge: challenge, viewModel: viewModel)
                    .padding(.horizontal, 24)
            }
        }
    }
    
    // MARK: - Daily Quests
    private var dailyQuestsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Daily Quests")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("Resets in \(viewModel.timeUntilReset)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.horizontal, 24)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.dailyQuests) { quest in
                        DailyQuestCard(quest: quest, viewModel: viewModel)
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
    
    // MARK: - Knowledge Cards
    private var knowledgeCardsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Fitness Quiz")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                // Stats
                HStack(spacing: 12) {
                    let masteredCount = viewModel.knowledgeCards.filter { $0.isMastered }.count
                    let totalCount = viewModel.knowledgeCards.count
                    
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                        
                        Text("\(masteredCount)/\(totalCount)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    
                    Button("Study All") {
                        viewModel.studyAllCards()
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 24)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(viewModel.knowledgeCards) { card in
                        KnowledgeCardView(card: card, viewModel: viewModel)
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
    
    // MARK: - Achievements
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Achievements")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(viewModel.earnedAchievements.count)/\(viewModel.allAchievements.count)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(.horizontal, 24)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(viewModel.allAchievements.prefix(6)) { achievement in
                    AchievementBadge(achievement: achievement, isEarned: viewModel.earnedAchievements.contains(achievement.id))
                }
            }
            .padding(.horizontal, 24)
        }
    }
}
struct KnowledgeCarde: Identifiable {
    let id = UUID()
    let questionNumber: Int
    let question: String
    let answer: String
    let category: QACategory
    let isMastered: Bool
}
struct KnowledgeCard: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
    let category: QACategory
    let isMastered: Bool
    let difficulty: KnowledgeDifficulty = .intermediate
}
// MARK: - Knowledge Card View
 struct KnowledgeCardView: View {
    let card: KnowledgeCarde
    @ObservedObject var viewModel: FitnessQuestViewModel
    @State private var flipDegree: Double = 0
    @State private var showAnswer = false
    
    var body: some View {
        VStack(spacing: 0) {
            if !showAnswer {
                cardFront
            } else {
                cardBack
            }
        }
        .frame(width: 280, height: 200)
        .onTapGesture {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showAnswer.toggle()
            }
        }
    }
    
    private var cardFront: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with category
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: card.category.icon)
                        .font(.system(size: 12, weight: .medium))
                    
                    Text(card.category.rawValue.uppercased())
                        .font(.system(size: 11, weight: .black, design: .rounded))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.white.opacity(0.2))
                .cornerRadius(6)
                
                Spacer()
                
                // Question number
                Text("Q\(card.question)")
                    .font(.system(size: 12, weight: .black, design: .rounded))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            // Question
            Text(card.question)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            // Mastery status and flip hint
            HStack {
                if card.isMastered {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                        
                        Text("Mastered")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                    }
                } else {
                    HStack(spacing: 6) {
                        Image(systemName: "lightbulb")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                        
                        Text("Tap to reveal answer")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                
                Spacer()
                
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(card.isMastered ? Color.white.opacity(0.5) : Color.white.opacity(0.1), lineWidth: 1)
        )
    }
    
    private var cardBack: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Text("ANSWER")
                    .font(.system(size: 12, weight: .black, design: .rounded))
                    .foregroundColor(.white.opacity(0.7))
                
                Spacer()
                
                Button(action: {
                    viewModel.masterCard(card)
                    // Flip back after mastering
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.spring()) {
                            showAnswer = false
                        }
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: card.isMastered ? "checkmark.seal.fill" : "seal")
                            .font(.system(size: 12))
                        
                        Text(card.isMastered ? "Mastered" : "Mark Mastered")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(6)
                }
                .disabled(card.isMastered)
            }
            
            // Answer content
            ScrollView {
                Text(card.answer)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
            
            // Flip back hint
            HStack {
                Spacer()
                HStack(spacing: 6) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.system(size: 12))
                    
                    Text("Tap to see question")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
                Spacer()
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.08))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Achievement Badge
struct AchievementBadge: View {
    let achievement: Achievement
    let isEarned: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(isEarned ? achievement.color : Color.white.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: achievement.icon)
                    .font(.system(size: 20))
                    .foregroundColor(isEarned ? .black : .green.opacity(0.3))
            }
            
            Text(achievement.title)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .opacity(isEarned ? 1.0 : 0.5)
    }
}

// MARK: - Progress Bar
struct ProgressBar: View {
    let value: Double
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.white.opacity(0.2))
                    .frame(height: geometry.size.height)
                
                Rectangle()
                    .fill(color)
                    .frame(width: geometry.size.width * CGFloat(value), height: geometry.size.height)
                    .cornerRadius(geometry.size.height / 2)
            }
            .cornerRadius(geometry.size.height / 2)
        }
    }
}

// MARK: - Celebration Overlay
struct CelebrationOverlay: View {
    @Binding var isShowing: Bool
    @State private var animateParticles = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.yellow)
                    .scaleEffect(animateParticles ? 1.2 : 0.8)
                    .rotationEffect(.degrees(animateParticles ? 360 : 0))
                
                VStack(spacing: 12) {
                    Text("Quest Complete!")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("You've earned rewards and leveled up!")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                
                Button("Continue Quest") {
                    withAnimation(.spring()) {
                        isShowing = false
                    }
                }
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.black)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(Color.yellow)
                .cornerRadius(25)
            }
            .padding(40)
            .background(Color.white.opacity(0.05))
            .cornerRadius(30)
            .padding(40)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                animateParticles = true
            }
        }
    }
}

// MARK: - Player Profile View
struct PlayerProfileView: View {
    @ObservedObject var viewModel: FitnessQuestViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Player stats
                        VStack(spacing: 16) {
                            Text("Quest Master")
                                .font(.system(size: 24, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("Level \(viewModel.playerLevel)")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white.opacity(0.7))
                            
                            HStack(spacing: 20) {
                                StatBox(title: "Total XP", value: "\(viewModel.experiencePoints)", icon: "⭐️", color: .yellow)
                                StatBox(title: "Coins", value: "\(viewModel.coins)", icon: "🎖️", color: .green)
                                StatBox(title: "Quests", value: "\(viewModel.completedQuests)", icon: "🇫🇲", color: .blue)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(16)
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Player Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct StatBox: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 18, weight: .black, design: .rounded))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}


// MARK: - Quest Category Row
 struct QuestCategoryRow: View {
    let category: QuestCategory
    @ObservedObject var viewModel: FitnessQuestViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: category.icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.name.uppercased())
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
                
                Text(category.description)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(category.completed)/\(category.total)")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                ProgressBar(value: Double(category.completed) / Double(category.total), color: .white)
                    .frame(width: 60, height: 4)
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}


// MARK: - Current Challenge Card
struct CurrentChallengeCard: View {
    let challenge: Challenge
    @ObservedObject var viewModel: FitnessQuestViewModel
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(challenge.title.uppercased())
                        .font(.system(size: 14, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(challenge.description)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(2)
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text("\(challenge.currentProgress)/\(challenge.target)")
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("GOAL")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            
            ProgressBar(value: Double(challenge.currentProgress) / Double(challenge.target), color: .orange)
                .frame(height: 8)
            
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "clock")
                        .font(.system(size: 12))
                    Text("\(challenge.timeRemaining) left")
                        .font(.system(size: 12, weight: .medium))
                }
                
                Spacer()
                
                HStack(spacing: 6) {
                    Text("⭐️")
                        .font(.system(size: 12))
                    Text("+\(challenge.rewardXP) XP")
                        .font(.system(size: 12, weight: .medium))
                }
                
                Spacer()
                
                HStack(spacing: 6) {
                    Text("🎖️")
                        .font(.system(size: 12))
                    Text("+\(challenge.rewardCoins)")
                        .font(.system(size: 12, weight: .medium))
                }
            }
            .foregroundColor(.white.opacity(0.6))
            
            Button(action: {
                withAnimation(.spring()) {
                    viewModel.completeChallenge(challenge)
                }
            }) {
                Text("Complete Challenge")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.orange)
                    .cornerRadius(12)
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [Color.orange.opacity(0.15), Color.orange.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.orange.opacity(0.3), lineWidth: 2)
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
    }
}

// MARK: - Daily Quest Card
struct DailyQuestCard: View {
    let quest: DailyQuest
    @ObservedObject var viewModel: FitnessQuestViewModel
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: quest.icon)
                    .font(.system(size: 20))
                    .foregroundColor(quest.isCompleted ? .green : .blue)
                
                Spacer()
                
                if quest.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.green)
                }
            }
            
            Text(quest.title)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text("⭐️")
                        .font(.system(size: 12))
                    Text("+\(quest.rewardXP) XP")
                        .font(.system(size: 12, weight: .medium))
                }
                
                HStack(spacing: 8) {
                    Text("🎖️")
                        .font(.system(size: 12))
                    Text("+\(quest.rewardCoins)")
                        .font(.system(size: 12, weight: .medium))
                }
            }
            .foregroundColor(.white.opacity(0.7))
            
            if !quest.isCompleted {
                Button(action: {
                    withAnimation(.spring()) {
                        viewModel.completeDailyQuest(quest)
                    }
                }) {
                    Text("Complete")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
        }
        .padding(16)
        .frame(width: 140, height: 180)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(quest.isCompleted ? Color.green.opacity(0.3) : Color.white.opacity(0.1), lineWidth: 1)
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
    }
}

