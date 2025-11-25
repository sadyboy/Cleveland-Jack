import SwiftUI

struct WorkoutListView: View {
    @EnvironmentObject var viewModel: WorkoutViewModel
    @State private var showingFilters = false
    @State private var searchText = ""
    @State private var animateCards = false
    @State private var selectedWorkout: Workout?
    @State private var showingWorkoutDetail = false
    
    var filteredWorkouts: [Workout] {
        if searchText.isEmpty {
            return viewModel.filteredWorkouts
        } else {
            return viewModel.workouts.filter { workout in
                workout.title.localizedCaseInsensitiveContains(searchText) ||
                workout.description.localizedCaseInsensitiveContains(searchText) ||
                workout.category.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Header
                        headerSection
                            .offset(y: animateCards ? 0 : 50)
                            .opacity(animateCards ? 1 : 0)
                        
                        // Search Bar
                        searchSection
                            .offset(y: animateCards ? 0 : 40)
                            .opacity(animateCards ? 1 : 0)
                        
                        // Quick Stats
                        quickStatsSection
                            .offset(y: animateCards ? 0 : 30)
                            .opacity(animateCards ? 1 : 0)
                        
                        // Featured Workouts
                        if !viewModel.featuredWorkouts.isEmpty {
                            featuredSection
                                .offset(y: animateCards ? 0 : 20)
                                .opacity(animateCards ? 1 : 0)
                        }
                        
                        // All Workouts
                        workoutsGridSection
                            .offset(y: animateCards ? 0 : 20)
                            .opacity(animateCards ? 1 : 0)
                    }
                    .padding(.vertical)
                }
            }
            .navigationDestination(isPresented: $showingWorkoutDetail) {
                if let workout = selectedWorkout {
                    WorkoutDetailView(workout: workout)
                }
            }
            .sheet(isPresented: $showingFilters) {
                WorkoutFilterView(
                    selectedCategory: $viewModel.selectedCategory,
                    selectedDifficulty: $viewModel.selectedDifficulty
                )
            }
            .refreshable {
                viewModel.loadWorkouts()
            }
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.1)) {
                    animateCards = true
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("TRAINING LIBRARY")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("Master Your Craft")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // Workout Stats
                VStack(spacing: 4) {
                    Text("\(viewModel.workouts.count)")
                        .font(.system(size: 20, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("WORKOUTS")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(12)
                .background(Color.white.opacity(0.05))
                .cornerRadius(12)
            }
            .padding(.horizontal, 24)
            
            Text("Professional programs for every fitness level")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.6))
                .padding(.horizontal, 24)
        }
    }
    
    // MARK: - Search Section
    private var searchSection: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white.opacity(0.5))
                    .font(.system(size: 16))
                
                TextField("Search workouts...", text: $searchText)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white.opacity(0.5))
                            .font(.system(size: 16))
                    }
                }
            }
            .padding(16)
            .background(Color.white.opacity(0.05))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
            
            Button(action: { showingFilters.toggle() }) {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            }
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Quick Stats
    private var quickStatsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                StatPill(
                    icon: "dumbbell",
                    value: "\(viewModel.workouts.count)",
                    title: "TOTAL WORKOUTS",
                    color: .blue
                )
                
                StatPill(
                    icon: "flame",
                    value: "\(viewModel.workouts.filter { $0.isCompleted }.count)",
                    title: "COMPLETED",
                    color: .green
                )
                
                StatPill(
                    icon: "star",
                    value: "\(viewModel.featuredWorkouts.count)",
                    title: "FEATURED",
                    color: .yellow
                )
                
                StatPill(
                    icon: "clock",
                    value: "\(viewModel.workouts.map { Int($0.duration) }.reduce(0, +) / 60)",
                    title: "TOTAL MINUTES",
                    color: .orange
                )
            }
            .padding(.horizontal, 24)
        }
    }
    
    // MARK: - Featured Section
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("PREMIUM PROGRAMS")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "crown.fill")
                    .foregroundColor(.yellow)
                    .font(.title3)
            }
            .padding(.horizontal, 24)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(viewModel.featuredWorkouts) { workout in
                        FeaturedWorkoutCard(workout: workout)
                            .onTapGesture {
                                selectedWorkout = workout
                                showingWorkoutDetail = true
                            }
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
    
    // MARK: - Workouts Grid
    private var workoutsGridSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("ALL WORKOUTS")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(filteredWorkouts.count) workouts")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.horizontal, 24)
            
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.2)
                    .tint(.white)
                    .frame(height: 200)
            } else if filteredWorkouts.isEmpty {
                emptyStateSection
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(filteredWorkouts) { workout in
                        WorkoutCard(workout: workout)
                            .onTapGesture {
                                selectedWorkout = workout
                                showingWorkoutDetail = true
                            }
                            .padding(.horizontal, 24)
                    }
                }
            }
        }
    }
    
    // MARK: - Empty State
    private var emptyStateSection: some View {
        VStack(spacing: 20) {
            Image(systemName: "dumbbell")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.3))
            
            VStack(spacing: 8) {
                Text("No Workouts Found")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Try adjusting your filters or search terms")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(60)
        .background(Color.white.opacity(0.05))
        .cornerRadius(20)
        .padding(.horizontal, 24)
    }
}

// MARK: - Featured Workout Card
struct FeaturedWorkoutCard: View {
    let workout: Workout
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header with badges
            HStack {
                CategoryBadge(category: workout.category)
                Spacer()
                DifficultyBadge(difficulty: workout.difficulty)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            // Content
            VStack(alignment: .leading, spacing: 16) {
                Text(workout.title)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(workout.description)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(2)
                
                // Stats
                HStack(spacing: 20) {
                    HStack(spacing: 6) {
                        Image(systemName: "clock")
                            .font(.system(size: 14))
                        Text(workout.formattedDuration)
                            .font(.system(size: 14, weight: .semibold))
                    }
                    
                    HStack(spacing: 6) {
                        Image(systemName: "dumbbell")
                            .font(.system(size: 14))
                        Text("\(workout.exercises.count) exercises")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    
                    HStack(spacing: 6) {
                        Image(systemName: "flame")
                            .font(.system(size: 14))
                        Text("\(workout.estimatedCalories) cal")
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
                .foregroundColor(.white.opacity(0.6))
                
                // Progress indicator for completed workouts
                if workout.isCompleted {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 14))
                        
                        Text("Completed")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.green)
                        
                        Spacer()
                        
                        if let dateCompleted = workout.dateCompleted {
                            Text(dateCompleted, style: .relative)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }
                }
            }
            .padding(20)
        }
        .frame(width: 300)
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
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
    }
}

// MARK: - Workout Card
struct WorkoutCard: View {
    let workout: Workout
    @State private var isPressed = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Category Icon
            ZStack {
                Circle()
                    .fill(workout.category.color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: workout.category.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(workout.category.color)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(workout.title)
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text(workout.description)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 8) {
                        DifficultyBadge(difficulty: workout.difficulty)
                        
                        if workout.isFeatured {
                            Image(systemName: "crown.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 12))
                        }
                    }
                }
                
                // Stats and metadata
                HStack {
                    HStack(spacing: 16) {
                        HStack(spacing: 6) {
                            Image(systemName: "clock")
                                .font(.system(size: 12))
                            Text(workout.formattedDuration)
                                .font(.system(size: 12, weight: .medium))
                        }
                        
                        HStack(spacing: 6) {
                            Image(systemName: "dumbbell")
                                .font(.system(size: 12))
                            Text("\(workout.exercises.count) ex")
                                .font(.system(size: 12, weight: .medium))
                        }
                        
                        HStack(spacing: 6) {
                            Image(systemName: "flame")
                                .font(.system(size: 12))
                            Text("\(workout.estimatedCalories) cal")
                                .font(.system(size: 12, weight: .medium))
                        }
                    }
                    
                    Spacer()
                    
                    // Completion status
                    if workout.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 16))
                    }
                }
                .foregroundColor(.white.opacity(0.6))
                
                // Equipment tags
                if !workout.equipment.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(workout.equipment.prefix(3), id: \.self) { equipment in
                                Text(equipment.rawValue)
                                    .font(.system(size: 10, weight: .medium))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.white.opacity(0.1))
                                    .foregroundColor(.white.opacity(0.7))
                                    .cornerRadius(6)
                            }
                            
                            if workout.equipment.count > 3 {
                                Text("+\(workout.equipment.count - 3) more")
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(.white.opacity(0.5))
                            }
                        }
                    }
                }
            }
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
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
    }
}

// MARK: - Category Badge
struct CategoryBadge: View {
    let category: WorkoutCategory
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: category.icon)
                .font(.system(size: 12, weight: .medium))
            
            Text(category.rawValue.uppercased())
                .font(.system(size: 11, weight: .black, design: .rounded))
        }
        .foregroundColor(category.color)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(category.color.opacity(0.2))
        .cornerRadius(8)
    }
}

// MARK: - Difficulty Badge
struct DifficultyBadge: View {
    let difficulty: Difficulty
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(difficulty.color)
                .frame(width: 6, height: 6)
            
            Text(difficulty.rawValue.uppercased())
                .font(.system(size: 10, weight: .black, design: .rounded))
        }
        .foregroundColor(difficulty.color)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(difficulty.color.opacity(0.2))
        .cornerRadius(6)
    }
}

// MARK: - Stat Pill Component
struct StatPill: View {
    let icon: String
    let value: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(color)
                
                Spacer()
                
                Text(value)
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundColor(.white)
            }
            
            Text(title)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
        }
        .padding(16)
        .frame(width: 140)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}
