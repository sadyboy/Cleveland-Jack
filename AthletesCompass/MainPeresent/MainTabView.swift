import SwiftUI

struct MainDashboardView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var workoutVM = WorkoutViewModel()
    @StateObject private var academyQAViewModel = FitnessQuestViewModel()
    @State private var showingOnboarding = !UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    @State private var activeCard: DashboardCard?
    @State private var showingDetail = false
    @State private var animateElements = false
    @State private var showingQuiz = false
    @State private var openProfivelView = false
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Black background
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Header with greeting
                        headerSection
                            .offset(y: animateElements ? 0 : 50)
                            .opacity(animateElements ? 1 : 0)
                        
                        // Quick stats
                        quickStatsSection
                            .offset(y: animateElements ? 0 : 30)
                            .opacity(animateElements ? 1 : 0)
                        
                        // Main feature cards
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(DashboardCard.allCases, id: \.self) { card in
                                DashboardCardView(card: card, isActive: activeCard == card)
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                            activeCard = card
                                            showingDetail = true
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal)
                        .offset(y: animateElements ? 0 : 20)
                        .opacity(animateElements ? 1 : 0)
                        
                        // AI Recommendations with Quiz
                        aiRecommendationSection
                            .offset(y: animateElements ? 0 : 20)
                            .opacity(animateElements ? 1 : 0)
                        
                        // Upcoming workouts
                        upcomingWorkoutsSection
                            .offset(y: animateElements ? 0 : 20)
                            .opacity(animateElements ? 1 : 0)
                    }
                    .padding(.vertical)
                }
                
                // Floating quick start button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        quickStartButton
                            .padding(.trailing, 20)
                            .padding(.bottom, 30)
                    }
                }
            }
            .navigationDestination(isPresented: $showingDetail) {
                if let card = activeCard {
                    card.destinationView
                        .environmentObject(workoutVM)
                }
            }
            .sheet(isPresented: $showingOnboarding) {
                InteractiveOnboardingView()
            }
            .fullScreenCover(isPresented: $showingQuiz) {
                FitnessQuizView()
                    .environmentObject(academyQAViewModel)
            }
            .fullScreenCover(isPresented: $openProfivelView, content: {
                PlayerProfileView(viewModel: academyQAViewModel)
            })
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.1)) {
                    animateElements = true
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Components
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(getGreeting())
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("Your Fitness Companion")
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // User avatar with premium design
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.white.opacity(0.1), .white.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 52, height: 52)
                    
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        .frame(width: 52, height: 52)
                    
                    Text("Y")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .onTapGesture {
                            openProfivelView = true
                        }
                }
            }
            .padding(.horizontal, 24)
            
            Text("Ready for new achievements?")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.6))
                .padding(.horizontal, 24)
        }
    }
    
    private var quickStatsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                StatCard(
                    title: "XP",
                    value: "\(academyQAViewModel.experiencePoints)",
                    subtitle: "total",
                    icon: "⭐️",
                    color: .yellow
                )

                StatCard(
                    title: "Coins",
                    value: "\(academyQAViewModel.coins)",
                    subtitle: "earned",
                    icon: "🎖️",
                    color: .green
                )

                StatCard(
                    title: "Quests",
                    value: "\(academyQAViewModel.completedQuests)",
                    subtitle: "completed",
                    icon: "🇫🇲",
                    color: .blue
                )

                StatCard(
                    title: "Knowledge",
                    value: "\(academyQAViewModel.knowledgeCards.filter{$0.isMastered}.count)",
                    subtitle: "mastered",
                    icon: "🧠",
                    color: .purple
                )
            }
            .padding(.horizontal, 24)
        }
    }
    
    private var aiRecommendationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Library of Knowledge")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "brain.head.profile")
                    .foregroundColor(.white.opacity(0.7))
                    .font(.title3)
            }
            .padding(.horizontal, 24)
            
            // Interactive Quiz Card
            Button(action: {
                showingQuiz = true
            }) {
                InteractiveQuizCard()
                    .padding(.horizontal, 24)
            }
            .buttonStyle(ScaleButtonStyle())
        }
    }
    private var upcomingWorkoutsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("UPCOMING WORKOUTS")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                NavigationLink("View All", destination: WorkoutListView().environmentObject(workoutVM))
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.horizontal, 24)
            
            if let nextWorkout = workoutVM.featuredWorkouts.first {
                UpcomingWorkoutCard(workout: nextWorkout)
                    .padding(.horizontal, 24)
            } else {
                EmptyWorkoutCard()
                    .padding(.horizontal, 24)
            }
        }
    }
    
    private var quickStartButton: some View {
        Button(action: {
            // Quick start workout
            if let workout = workoutVM.featuredWorkouts.first {
                activeCard = .workouts
                showingDetail = true
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: "play.fill")
                    .font(.system(size: 18, weight: .bold))
                
                Text("QUICK START")
                    .font(.system(size: 16, weight: .black, design: .rounded))
            }
            .foregroundColor(.black)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [.white, .white.opacity(0.9)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(25)
            .shadow(color: .white.opacity(0.3), radius: 15, x: 0, y: 8)
            .scaleEffect(animateElements ? 1 : 0.8)
        }
    }
    
    private func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12: return "GOOD MORNING"
        case 12..<17: return "GOOD AFTERNOON"
        case 17..<22: return "GOOD EVENING"
        default: return "GOOD NIGHT"
        }
    }
}

// MARK: - Card Components

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(color)
                
                Spacer()
                
                Text(value)
                    .font(.system(size: 22, weight: .black, design: .rounded))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white.opacity(0.8))
                
                Text(subtitle)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .padding(20)
        .frame(width: 130)
        .background(
            LinearGradient(
                colors: [Color.white.opacity(0.08), Color.white.opacity(0.02)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

struct DashboardCardView: View {
    let card: DashboardCard
    let isActive: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.1), Color.white.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                
                Circle()
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    .frame(width: 60, height: 60)
                
                Image(systemName: card.iconName)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 6) {
                Text(card.title)
                    .font(.system(size: 16, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(card.subtitle)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, minHeight: 160)
        .background(
            LinearGradient(
                colors: [Color.white.opacity(0.08), Color.white.opacity(0.02)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(isActive ? Color.white.opacity(0.3) : Color.white.opacity(0.1), lineWidth: isActive ? 2 : 1)
        )
        .scaleEffect(isActive ? 1.02 : 1.0)
        .shadow(color: .black.opacity(0.2), radius: isActive ? 10 : 5, x: 0, y: isActive ? 8 : 4)
    }
}

struct RecommendationCard: View {
    let title: String
    let message: String
    let type: RecommendationType
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(type.color.opacity(0.9))
                    .frame(width: 44, height: 44)
                
                Image(systemName: type.iconName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(message)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [Color.white.opacity(0.08), Color.white.opacity(0.02)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

struct UpcomingWorkoutCard: View {
    let workout: Workout
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: workout.category.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(workout.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                HStack {
                    Label(workout.formattedDuration, systemImage: "⏱️")
                        .font(.system(size: 13, weight: .medium))
                    Spacer()
                    DifficultyBadge(difficulty: workout.difficulty)
                }
                .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
            
            Image(systemName: "play.circle.fill")
                .font(.title2)
                .foregroundColor(.white)
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [Color.white.opacity(0.08), Color.white.opacity(0.02)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

struct EmptyWorkoutCard: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "dumbbell")
                .font(.system(size: 24))
                .foregroundColor(.white.opacity(0.3))
            
            VStack(spacing: 6) {
                Text("No Workouts Scheduled")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Add workouts to your schedule")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(40)
        .background(
            LinearGradient(
                colors: [Color.white.opacity(0.05), Color.white.opacity(0.02)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

// MARK: - Data Models

enum DashboardCard: CaseIterable {
    case workouts, academy, brain, progress
    
    var title: String {
        switch self {
        case .workouts: return "WORKOUTS"
        case .academy: return "ACADEMY"
        case .brain: return "BRAIN"
        case .progress: return "PROGRESS"
        }
    }
    
    var subtitle: String {
        switch self {
        case .workouts: return "Personalized Programs"
        case .academy: return "Knowledge Base"
        case .brain: return "Brain Library"
        case .progress: return "Analytics & Goals"
        }
    }
    
    var iconName: String {
        switch self {
        case .workouts: return "dumbbell"
        case .academy: return "book.closed"
        case .brain: return "brain.head.profile"
        case .progress: return "chart.line.uptrend.xyaxis"
        }
    }
    
    @ViewBuilder
    var destinationView: some View {
        switch self {
        case .workouts:
            WorkoutListView()
        case .academy:
            AcademyView()
        case .brain:
                FitnessQuestView()
        case .progress:
            ProgressDashboardView()
        }
    }
}

enum RecommendationType {
    case recovery, strength, nutrition, motivation
    
    var iconName: String {
        switch self {
        case .recovery: return "bed.double"
        case .strength: return "dumbbell"
        case .nutrition: return "fork.knife"
        case .motivation: return "brain.head.profile"
        }
    }
    
    var color: Color {
        switch self {
        case .recovery: return .blue
        case .strength: return .orange
        case .nutrition: return .green
        case .motivation: return .purple
        }
    }
}

// MARK: - Onboarding

struct InteractiveOnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep = 0
    
    private let onboardingSteps = [
        OnboardingStep(
            title: "Welcome to ATHLETE'S COMPASS",
            description: "Your premium fitness companion designed to guide you to peak performance",
            icon: "heart.fill",
            color: .white
        ),
        OnboardingStep(
            title: "Smart Training Programs",
            description: "AI-powered workouts tailored to your goals, level, and progress",
            icon: "dumbbell.fill",
            color: .white
        ),
        OnboardingStep(
            title: "Expert  Library Brain",
            description: "Get instant answers to all your fitness and nutrition questions",
            icon: "brain.head.profile",
            color: .white
        ),
        OnboardingStep(
            title: "Advanced Progress Tracking",
            description: "Comprehensive analytics and insights to maximize your results",
            icon: "chart.line.uptrend.xyaxis",
            color: .white
        )
    ]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 50) {
                // Progress indicator
                HStack(spacing: 8) {
                    ForEach(0..<onboardingSteps.count, id: \.self) { index in
                        Capsule()
                            .fill(index == currentStep ? Color.white : Color.white.opacity(0.3))
                            .frame(width: index == currentStep ? 24 : 8, height: 4)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: currentStep)
                    }
                }
                
                // Content
                TabView(selection: $currentStep) {
                    ForEach(0..<onboardingSteps.count, id: \.self) { index in
                        OnboardingStepView(step: onboardingSteps[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Buttons
                HStack {
                    if currentStep > 0 {
                        Button("Back") {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                currentStep -= 1
                            }
                        }
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    if currentStep < onboardingSteps.count - 1 {
                        Button("Continue") {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                currentStep += 1
                            }
                        }
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                    } else {
                        Button("Get Started") {
                            UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                            dismiss()
                        }
                        .font(.system(size: 16, weight: .black, design: .rounded))
                        .foregroundColor(.black)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .cornerRadius(25)
                    }
                }
                .padding(.horizontal, 40)
            }
            .padding(.vertical, 60)
        }
        .preferredColorScheme(.dark)
    }
}

struct OnboardingStep {
    let title: String
    let description: String
    let icon: String
    let color: Color
}

struct OnboardingStepView: View {
    let step: OnboardingStep
    
    var body: some View {
        VStack(spacing: 40) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: step.icon)
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 20) {
                Text(step.title)
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(step.description)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .lineSpacing(4)
            }
        }
        .padding(20)
    }
}

// MARK: - Updated MainTabView

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject private var workoutVM: WorkoutViewModel
    @EnvironmentObject private var academyQAViewModel: FitnessQuestViewModel
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            MainDashboardView()
                .environmentObject(workoutVM)
                .environmentObject(academyQAViewModel)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(Tab.dashboard)
            
            WorkoutListView()
                .environmentObject(workoutVM)
                .tabItem {
                    Label("Workouts", systemImage: "dumbbell")
                }
                .tag(Tab.workouts)
            
            AcademyView()
                .tabItem {
                    Label("Academy", systemImage: "book.closed")
                }
                .tag(Tab.academy)
            
            FitnessQuestView()
                .environmentObject(academyQAViewModel)
                .tabItem {
                    Label("Brain", systemImage: "brain.head.profile")
                }
                .tag(Tab.brain)
            
            ProgressDashboardView()
                .tabItem {
                    Label("Progress", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(Tab.progress)
                .environmentObject(workoutVM)
                .environmentObject(academyQAViewModel)
        }
        .preferredColorScheme(.dark)
        .accentColor(.white)
    }
}

// MARK: - Difficulty Badge Component

struct FitnessQuizView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var academyQAViewModel: FitnessQuestViewModel
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: String?
    @State private var showResult = false
    @State private var isCorrect = false
    @State private var score = 0
    @State private var quizCompleted = false
    @State private var answerAnimation = false
    @State private var particleSystem = ParticleSystem()
    @State private var celebration = false
    
    let quizQuestions = [
        QuizQuestion(
            question: "Which protein is best absorbed after a workout?",
            options: ["Casein", "Whey", "Soy", "Egg"],
            correctAnswer: "Whey",
            explanation: "Whey protein is rapidly absorbed, making it ideal for the post-workout window.",
            category: "Nutrition",
            difficulty: "Easy"
        ),
        QuizQuestion(
            question: "How many sets per muscle group are optimal for growth?",
            options: ["5-8", "10-15", "15-20", "20-25"],
            correctAnswer: "10-15",
            explanation: "10-15 sets per week per muscle group are optimal for hypertrophy.",
            category: "Training",
            difficulty: "Medium"
        ),
        QuizQuestion(
            question: "Which heart rate zone is considered the fat-burning zone?",
            options: ["50-60% of maximum", "60-70% of maximum", "70-80% of maximum", "80-90% of maximum"],
            correctAnswer: "60-70% of maximum",
            explanation: "In this zone, the body uses fat as its primary energy source.",
            category: "Cardio",
            difficulty: "Easy"
        ),
        QuizQuestion(
            question: "How much time do muscles need for recovery?",
            options: ["12-24 hours", "24-48 hours", "48-72 hours", "72-96 hours"],
            correctAnswer: "48-72 hours",
            explanation: "Most muscles require 48-72 hours for complete recovery.",
            category: "Recovery",
            difficulty: "Medium"
        ),
        QuizQuestion(
            question: "What is a 'calorie deficit'?",
            options: ["Consuming fewer calories than burned", "Consuming more calories than burned", "Calorie balance", "Avoiding carbohydrates"],
            correctAnswer: "Consuming fewer calories than burned",
            explanation: "Calorie deficit is the foundation of weight loss.",
            category: "Nutrition",
            difficulty: "Easy"
        ),
        QuizQuestion(
            question: "Which mineral is important for muscle contractions?",
            options: ["Iron", "Calcium", "Magnesium", "Zinc"],
            correctAnswer: "Calcium",
            explanation: "Calcium plays a key role in the mechanism of muscle contractions.",
            category: "Nutrition",
            difficulty: "Hard"
        ),
        QuizQuestion(
            question: "What is 'progressive overload'?",
            options: ["Increasing weights", "Increasing sets", "Any increase in load", "Changing exercises"],
            correctAnswer: "Any increase in load",
            explanation: "Progression can be in weights, sets, repetitions, or decreasing rest time.",
            category: "Training",
            difficulty: "Medium"
        ),
        QuizQuestion(
            question: "How much water should you drink per day with active training?",
            options: ["1-1.5 liters", "2-3 liters", "3-4 liters", "4+ liters"],
            correctAnswer: "3-4 liters",
            explanation: "Active training requires increased hydration - 3-4 liters per day.",
            category: "Nutrition",
            difficulty: "Easy"
        ),
        QuizQuestion(
            question: "What is 'lactic acid'?",
            options: ["Toxin", "Glucose breakdown product", "Protein", "Vitamin"],
            correctAnswer: "Glucose breakdown product",
            explanation: "Lactic acid is a product of anaerobic glycolysis and an energy source.",
            category: "Physiology",
            difficulty: "Hard"
        ),
        QuizQuestion(
            question: "Which type of cardio is best for preserving muscle mass?",
            options: ["Long-distance running", "HIIT", "Swimming", "Cycling"],
            correctAnswer: "HIIT",
            explanation: "HIIT has less impact on muscle mass compared to steady-state cardio.",
            category: "Cardio",
            difficulty: "Medium"
        ),
        QuizQuestion(
            question: "How much protein is needed daily for muscle growth?",
            options: ["0.8 g/kg", "1.2-1.6 g/kg", "2.0-2.5 g/kg", "3.0+ g/kg"],
            correctAnswer: "1.2-1.6 g/kg",
            explanation: "1.2-1.6 g of protein per kg of body weight is optimal for muscle growth.",
            category: "Nutrition",
            difficulty: "Medium"
        ),
        QuizQuestion(
            question: "What is a 'motor unit'?",
            options: ["Muscle group", "Neuron + muscle fibers", "Training day", "Sports equipment"],
            correctAnswer: "Neuron + muscle fibers",
            explanation: "A motor unit is a motor neuron and the muscle fibers it innervates.",
            category: "Physiology",
            difficulty: "Hard"
        ),
        QuizQuestion(
            question: "Which hormone is called the 'growth hormone'?",
            options: ["Testosterone", "Insulin", "Somatotropin", "Cortisol"],
            correctAnswer: "Somatotropin",
            explanation: "Somatotropin is the growth hormone that stimulates muscle and bone development.",
            category: "Physiology",
            difficulty: "Medium"
        ),
        QuizQuestion(
            question: "What is more important for weight loss?",
            options: ["Diet", "Training", "Sleep", "All of the above"],
            correctAnswer: "All of the above",
            explanation: "For effective weight loss, diet, training, sleep, and recovery are all important.",
            category: "Weight Loss",
            difficulty: "Easy"
        ),
        QuizQuestion(
            question: "How many repetitions are optimal for strength?",
            options: ["1-5", "6-12", "12-15", "15-20"],
            correctAnswer: "1-5",
            explanation: "Low repetitions with heavy weight develop strength.",
            category: "Training",
            difficulty: "Medium"
        ),
        QuizQuestion(
            question: "What is 'glycogen'?",
            options: ["Fat", "Protein", "Carbohydrate storage", "Vitamin"],
            correctAnswer: "Carbohydrate storage",
            explanation: "Glycogen is the storage form of carbohydrates in muscles and liver.",
            category: "Nutrition",
            difficulty: "Hard"
        ),
        QuizQuestion(
            question: "How often should you change your training program?",
            options: ["Every week", "Every 4-8 weeks", "Every 3 months", "Never"],
            correctAnswer: "Every 4-8 weeks",
            explanation: "Changing the program every 4-8 weeks prevents adaptation.",
            category: "Training",
            difficulty: "Easy"
        ),
        QuizQuestion(
            question: "What is 'supercompensation'?",
            options: ["Overtraining", "Recovery + improvement", "Muscle pain", "Plateau effect"],
            correctAnswer: "Recovery + improvement",
            explanation: "Supercompensation is the period when the body becomes stronger after recovery.",
            category: "Training",
            difficulty: "Hard"
        ),
        QuizQuestion(
            question: "Which vitamin is important for bone health?",
            options: ["Vitamin C", "Vitamin D", "Vitamin B12", "Vitamin K"],
            correctAnswer: "Vitamin D",
            explanation: "Vitamin D helps calcium absorption and is important for bones.",
            category: "Nutrition",
            difficulty: "Easy"
        ),
        QuizQuestion(
            question: "What does VO2 max measure?",
            options: ["Strength", "Endurance", "Max oxygen consumption", "Flexibility"],
            correctAnswer: "Max oxygen consumption",
            explanation: "VO2 max is the maximum oxygen consumption, an indicator of aerobic endurance.",
            category: "Cardio",
            difficulty: "Hard"
        )
    ]
    
    var currentQuestion: QuizQuestion {
        quizQuestions[currentQuestionIndex]
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AnimatedBackground()
                ScrollView {
                    if quizCompleted {
                        QuizCompletionView(score: score, totalQuestions: quizQuestions.count) {
                            dismiss()
                        }
                        .environmentObject(academyQAViewModel)
                    } else {
                        VStack(spacing: 25) {
                            QuizHeaderView(
                                currentQuestion: currentQuestionIndex + 1,
                                totalQuestions: quizQuestions.count,
                                score: score,
                                category: currentQuestion.category,
                                difficulty: currentQuestion.difficulty
                            )
                            
                            QuestionCardView(
                                question: currentQuestion,
                                selectedAnswer: $selectedAnswer,
                                showResult: showResult,
                                isCorrect: isCorrect,
                                answerAnimation: answerAnimation
                            )
                            .zIndex(1)
                            
                            Spacer()
                            
                            ActionButtonView(
                                selectedAnswer: selectedAnswer,
                                showResult: showResult,
                                isLastQuestion: currentQuestionIndex == quizQuestions.count - 1,
                                onAction: handleAnswer
                            )
                            .padding(.horizontal, 24)
                            .padding(.bottom, 30)
                        }
                    }
                    
                    if celebration {
                        ParticleOverlay(particleSystem: particleSystem)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        CloseButton {
                            dismiss()
                        }
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    private func handleAnswer() {
        if showResult {
            goToNextQuestion()
        } else {
            checkAnswer()
        }
    }
    
    private func checkAnswer() {
        isCorrect = selectedAnswer == currentQuestion.correctAnswer
        if isCorrect {
            score += 1
            triggerCelebration()
        }
        showResult = true
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            answerAnimation = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                answerAnimation = false
            }
        }
    }
    
    private func goToNextQuestion() {
        if currentQuestionIndex < quizQuestions.count - 1 {
            withAnimation(.easeInOut(duration: 0.5)) {
                currentQuestionIndex += 1
                selectedAnswer = nil
                showResult = false
            }
        } else {
            withAnimation(.easeInOut(duration: 0.5)) {
                quizCompleted = true
            }
            academyQAViewModel.experiencePoints += score * 15
            academyQAViewModel.coins += score * 5
        }
    }
    
    private func triggerCelebration() {
        celebration = true
        particleSystem.emitParticles(count: 50)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeOut(duration: 0.5)) {
                celebration = false
            }
        }
    }
}

struct AnimatedBackground: View {
    @State private var gradientRotation = 0.0
    
    var body: some View {
        ZStack {
            AngularGradient(
                gradient: Gradient(colors: [
                    .purple.opacity(0.3),
                    .blue.opacity(0.3),
                    .green.opacity(0.3),
                    .orange.opacity(0.3),
                    .purple.opacity(0.3)
                ]),
                center: .center,
                angle: .degrees(gradientRotation)
            )
            .blur(radius: 50)
            .ignoresSafeArea()
            
            ForEach(0..<15, id: \.self) { index in
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: CGFloat.random(in: 2...8))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                gradientRotation = 360
            }
        }
    }
}

struct QuizHeaderView: View {
    let currentQuestion: Int
    let totalQuestions: Int
    let score: Int
    let category: String
    let difficulty: String
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Fitness Quiz")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 12) {
                        BadgeView(text: category, color: .blue)
                        BadgeView(text: difficulty, color: difficultyColor)
                    }
                }
                
                Spacer()
                
                ScoreView(score: score)
            }
            .padding(.horizontal, 24)
            
            ProgressBarView(
                progress: Double(currentQuestion) / Double(totalQuestions),
                currentQuestion: currentQuestion,
                totalQuestions: totalQuestions
            )
            .padding(.horizontal, 24)
        }
    }
    
    private var difficultyColor: Color {
        switch difficulty {
            case "Easy": return .green
            case "Medium": return .orange
            case "Hard": return .red
        default: return .gray
        }
    }
}

struct BadgeView: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color.opacity(0.3))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color.opacity(0.5), lineWidth: 1)
            )
    }
}

struct ScoreView: View {
    let score: Int
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(score)")
                .font(.system(size: 24, weight: .black, design: .rounded))
                .foregroundColor(.white)
            
            Text("Points")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(12)
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}

struct ProgressBarView: View {
    let progress: Double
    let currentQuestion: Int
    let totalQuestions: Int
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Questions \(currentQuestion) from \(totalQuestions)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                
                Spacer()
                
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.white.opacity(0.2))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [.purple, .blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress, height: 8)
                        .cornerRadius(4)
                        .shadow(color: .blue.opacity(0.3), radius: 4, x: 0, y: 2)
                    
                    HStack(spacing: 0) {
                        ForEach(0..<totalQuestions, id: \.self) { index in
                            Circle()
                                .fill(index < currentQuestion ? Color.white : Color.white.opacity(0.3))
                                .frame(width: 6, height: 6)
                                .padding(.horizontal, (geometry.size.width - CGFloat(totalQuestions) * 6) / CGFloat(totalQuestions * 2))
                        }
                    }
                }
            }
            .frame(height: 8)
        }
    }
}

struct QuestionCardView: View {
    let question: QuizQuestion
    @Binding var selectedAnswer: String?
    let showResult: Bool
    let isCorrect: Bool
    let answerAnimation: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Question")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
                
                Text(question.question)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(4)
            }
            
            LazyVStack(spacing: 12) {
                ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                    AnswerOptionView(
                        option: option,
                        index: index,
                        isSelected: selectedAnswer == option,
                        isCorrect: option == question.correctAnswer,
                        showResult: showResult,
                        onSelect: { selectedAnswer = option }
                    )
                }
            }
            
            if showResult {
                ExplanationView(
                    isCorrect: isCorrect,
                    explanation: question.explanation
                )
            }
        }
        .padding(28)
        .background(
            LinearGradient(
                colors: [Color.white.opacity(0.1), Color.white.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .padding(.horizontal, 24)
        .scaleEffect(answerAnimation ? 1.02 : 1.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: answerAnimation)
        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
    }
}

struct AnswerOptionView: View {
    let option: String
    let index: Int
    let isSelected: Bool
    let isCorrect: Bool
    let showResult: Bool
    let onSelect: () -> Void
    
    @State private var bounce = false
    @State private var glow = false
    
    var backgroundColor: Color {
        if showResult {
            if isCorrect {
                return .green.opacity(0.3)
            } else if isSelected && !isCorrect {
                return .red.opacity(0.3)
            }
            return Color.white.opacity(0.05)
        }
        return isSelected ? Color.blue.opacity(0.3) : Color.white.opacity(0.05)
    }
    
    var borderColor: Color {
        if showResult {
            if isCorrect {
                return .green
            } else if isSelected && !isCorrect {
                return .red
            }
        }
        return isSelected ? .blue : .white.opacity(0.2)
    }
    
    var icon: String {
        if showResult {
            if isCorrect {
                return "checkmark.circle.fill"
            } else if isSelected && !isCorrect {
                return "xmark.circle.fill"
            }
        }
        return isSelected ? "circle.fill" : "circle"
    }
    
    var iconColor: Color {
        if showResult {
            if isCorrect {
                return .green
            } else if isSelected && !isCorrect {
                return .red
            }
        }
        return isSelected ? .blue : .white.opacity(0.5)
    }
    
    var body: some View {
        Button(action: {
            if !showResult {
                onSelect()
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    bounce = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    bounce = false
                }
            }
        }) {
            HStack(spacing: 16) {
                Text("\(["A", "B", "C", "D"][index])")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white.opacity(0.7))
                    .frame(width: 24)
                
                Text(option)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(4)
                
                Spacer()
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(iconColor)
            }
            .padding(20)
            .background(backgroundColor)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(borderColor, lineWidth: showResult ? 2 : 1)
            )
            .overlay(
                Group {
                    if isSelected && !showResult {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.blue, lineWidth: 2)
                            .scaleEffect(glow ? 1.1 : 1.0)
                            .opacity(glow ? 0.5 : 0.2)
                            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: glow)
                    }
                }
            )
        }
        .scaleEffect(bounce ? 0.95 : 1.0)
        .onAppear {
            if isSelected && !showResult {
                glow = true
            }
        }
        .onChange(of: isSelected) { newValue in
            glow = newValue && !showResult
        }
    }
}

struct ExplanationView: View {
    let isCorrect: Bool
    let explanation: String
    
    @State private var appear = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(isCorrect ? .green : .red)
                
                Text(isCorrect ? "Correct!" : "Not quite")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(isCorrect ? .green : .red)
                
                Spacer()
            }
            
            Text(explanation)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(4)
        }
        .padding(20)
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
        .scaleEffect(appear ? 1.0 : 0.8)
        .opacity(appear ? 1.0 : 0.0)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3)) {
                appear = true
            }
        }
    }
}

struct ActionButtonView: View {
    let selectedAnswer: String?
    let showResult: Bool
    let isLastQuestion: Bool
    let onAction: () -> Void
    
    @State private var hover = false
    
    var buttonText: String {
        if showResult {
        return isLastQuestion ? "End quiz 🏆": "Next question →"
        } else {
        return "Confirm answer"
        }
    }
    
    var isEnabled: Bool {
        selectedAnswer != nil
    }
    
    var body: some View {
        Button(action: onAction) {
            HStack(spacing: 12) {
                Text(buttonText)
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                
                if showResult && !isLastQuestion {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                Group {
                    if isEnabled {
                        LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .scaleEffect(hover ? 1.05 : 1.0)
                    } else {
                        LinearGradient(
                            colors: [.gray, .gray.opacity(0.7)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    }
                }
            )
            .cornerRadius(20)
            .shadow(
                color: isEnabled ? .blue.opacity(0.4) : .clear,
                radius: hover ? 20 : 10,
                x: 0,
                y: hover ? 10 : 5
            )
            .scaleEffect(hover ? 1.02 : 1.0)
        }
        .disabled(!isEnabled)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                hover = hovering && isEnabled
            }
        }
    }
}

class ParticleSystem: ObservableObject {
    @Published var particles: [Particle] = []
    
    func emitParticles(count: Int) {
        for _ in 0..<count {
            particles.append(Particle())
        }
    }
}

struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint = .zero
    var velocity: CGSize = .zero
    var life: Double = 1.0
    var color: Color = [.red, .blue, .green, .yellow, .purple, .orange].randomElement()!
}

struct ParticleOverlay: View {
    @ObservedObject var particleSystem: ParticleSystem
    
    var body: some View {
        ZStack {
            ForEach(particleSystem.particles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: 6, height: 6)
                    .position(particle.position)
                    .opacity(particle.life)
            }
        }
        .onAppear {
            for i in particleSystem.particles.indices {
                particleSystem.particles[i].position = CGPoint(
                    x: UIScreen.main.bounds.width / 2,
                    y: UIScreen.main.bounds.height / 2
                )
                particleSystem.particles[i].velocity = CGSize(
                    width: CGFloat.random(in: -200...200),
                    height: CGFloat.random(in: -200...200)
                )
            }
            
            Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { timer in
                var allDead = true
                
                for i in self.particleSystem.particles.indices {
                    self.particleSystem.particles[i].position.x += self.particleSystem.particles[i].velocity.width * 0.016
                    self.particleSystem.particles[i].position.y += self.particleSystem.particles[i].velocity.height * 0.016
                    self.particleSystem.particles[i].life -= 0.016
                    
                    if self.particleSystem.particles[i].life > 0 {
                        allDead = false
                    }
                }
                
                if allDead {
                    timer.invalidate()
                    self.particleSystem.particles.removeAll()
                }
            }
        }
    }
}

struct CloseButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white.opacity(0.7))
                .frame(width: 32, height: 32)
                .background(Color.white.opacity(0.1))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

struct QuizQuestion {
    let question: String
    let options: [String]
    let correctAnswer: String
    let explanation: String
    let category: String
    let difficulty: String
}

struct InteractiveQuizCard: View {
    @State private var isPulsing = false
    @State private var isRotating = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Animated icon
            ZStack {
                Circle()
                    .fill(Color.purple.opacity(0.9))
                    .frame(width: 44, height: 44)
                    .scaleEffect(isPulsing ? 1.1 : 1.0)
                
                // Rotating circles
                ForEach(0..<3) { index in
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        .frame(width: 44, height: 44)
                        .scaleEffect(isPulsing ? 1.5 : 0.5)
                        .opacity(isPulsing ? 0 : 1)
                        .rotationEffect(.degrees(isRotating ? 360 : 0))
                }
                
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Daily Fitness Quiz")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Test your knowledge and earn XP!")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(2)
            }
            
            Spacer()
            
            // Animated arrow
            Image(systemName: "play.circle.fill")
                .font(.title2)
                .foregroundColor(.white)
                .rotationEffect(.degrees(isRotating ? 90 : 0))
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [Color.purple.opacity(0.2), Color.blue.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.purple.opacity(0.3), lineWidth: 1)
        )
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isPulsing.toggle()
            }
            
            withAnimation(Animation.linear(duration: 4).repeatForever(autoreverses: false)) {
                isRotating = true
            }
        }
    }
}



struct QuizCompletionView: View {
    let score: Int
    let totalQuestions: Int
    let onDismiss: () -> Void
    @EnvironmentObject var academyQAViewModel: FitnessQuestViewModel
    @State private var confetti = false
    @State private var scaleEffect = false
    
    var percentage: Double {
        Double(score) / Double(totalQuestions)
    }
    
    var performanceText: String {
        switch percentage {
        case 0.8...1.0: return "Excellent! 🎯"
        case 0.6..<0.8: return "Great job! 👍"
        case 0.4..<0.6: return "Good effort! 💪"
        default: return "Keep learning! 📚"
        }
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Trophy icon with confetti
            ZStack {
                if confetti {
                    ForEach(0..<20, id: \.self) { index in
                        ConfettiParticle(index: index)
                    }
                }
                
                Image(systemName: percentage > 0.7 ? "trophy.fill" : "brain.head.profile")
                    .font(.system(size: 80))
                    .foregroundColor(percentage > 0.7 ? .yellow : .blue)
                    .scaleEffect(scaleEffect ? 1.1 : 1.0)
            }
            .frame(height: 120)
            
            VStack(spacing: 16) {
                Text("Quiz Complete!")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                
                Text(performanceText)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white.opacity(0.8))
                
                Text("\(score)/\(totalQuestions) Correct")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }
            
            // XP Award
            HStack(spacing: 12) {
                Text("⭐️")
                    .foregroundColor(.yellow)
                
                Text("+\(score * 10) XP Earned!")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.yellow)
            }
            .padding()
            .background(Color.yellow.opacity(0.2))
            .cornerRadius(12)
            
            Spacer()
            
            Button("Continue Training") {
                onDismiss()
            }
            .font(.system(size: 18, weight: .black, design: .rounded))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    colors: [.purple, .blue],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .padding(.horizontal, 24)
            .padding(.bottom, 30)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                scaleEffect = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeOut(duration: 1)) {
                    confetti = true
                }
            }
        }
    }
}

struct ConfettiParticle: View {
    let index: Int
    @State private var animation = false
    
    let colors: [Color] = [.red, .blue, .green, .yellow, .purple, .orange]
    
    var body: some View {
        Circle()
            .fill(colors.randomElement() ?? .white)
            .frame(width: 8, height: 8)
            .offset(
                x: animation ? CGFloat.random(in: -100...100) : 0,
                y: animation ? CGFloat.random(in: -100...100) : 0
            )
            .opacity(animation ? 0 : 1)
            .animation(
                Animation.easeOut(duration: 1.5)
                    .delay(Double(index) * 0.1),
                value: animation
            )
            .onAppear {
                animation = true
            }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}


