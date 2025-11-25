import SwiftUI

 struct WorkoutDetailView: View {
     let workout: Workout
     @EnvironmentObject var viewModel: WorkoutViewModel
     @State private var showingStartWorkout = false
     @State private var isStartingWorkout = false
     @State private var selectedExercise: Exercise?
     @State private var showExerciseDetail = false
     @State private var animateHeader = false
     @State private var scrollOffset: CGFloat = 0
     @State private var showWorkoutStartAnimation = false
     
     var body: some View {
         ZStack(alignment: .top) {
             // Background Layer
             Color.black.ignoresSafeArea()
             
             ScrollView {
                 GeometryReader { geometry in
                     Color.clear
                         .preference(key: ScrollOffsetKey.self,
                                   value: geometry.frame(in: .global).minY)
                 }
                 .frame(height: 0)
                 
                 VStack(spacing: 0) {
                     // Hero Header
                     HeroHeaderSection()
                         .offset(y: animateHeader ? 0 : 50)
                         .opacity(animateHeader ? 1 : 0)
                     
                     // Quick Stats
                     QuickStatsSection()
                         .offset(y: animateHeader ? 0 : 30)
                         .opacity(animateHeader ? 1 : 0)
                     
                     // Exercise List
                     ExercisesSection()
                         .padding(.top, 24)
                 }
                 .padding(.bottom, 100)
             }
             .coordinateSpace(name: "scroll")
             
             // Sticky Start Button
             VStack {
                 Spacer()
                 StickyStartButton()
                     .padding(.horizontal)
                     .padding(.bottom, 8)
                     .background(
                         LinearGradient(
                             colors: [.black.opacity(0.9), .black],
                             startPoint: .top,
                             endPoint: .bottom
                         )
                     )
             }
             
             // Workout Start Animation Overlay
             if showWorkoutStartAnimation {
                 WorkoutStartCountdownView(
                     isShowing: $showWorkoutStartAnimation,
                     onComplete: {
                         showingStartWorkout = true
                     }
                 )
                 .transition(.opacity)
             }
         }
         .navigationBarTitleDisplayMode(.inline)
         .preferredColorScheme(.dark)
         .sheet(isPresented: $showingStartWorkout) {
             ActiveWorkoutView(workout: workout)
                 .preferredColorScheme(.dark)
         }
         .sheet(item: $selectedExercise) { exercise in
             ExerciseDetailView(exercise: exercise)
                 .preferredColorScheme(.dark)
         }
         .onAppear {
             withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                 animateHeader = true
             }
         }
     }
     
     // MARK: - Hero Header
     private func HeroHeaderSection() -> some View {
         VStack(alignment: .leading, spacing: 16) {
             HStack(spacing: 12) {
                 // Difficulty Badge
                 Capsule()
                     .fill(workout.difficulty.color.opacity(0.2))
                     .frame(height: 32)
                     .overlay(
                         HStack(spacing: 6) {
                             Circle()
                                 .fill(workout.difficulty.color)
                                 .frame(width: 8, height: 8)
                             Text(workout.difficulty.rawValue.uppercased())
                                 .font(.system(size: 12, weight: .bold))
                                 .foregroundColor(workout.difficulty.color)
                         }
                         .padding(.horizontal, 12)
                     )
                 
                 // Category Badge
                 Capsule()
                     .fill(Color.white.opacity(0.1))
                     .frame(height: 32)
                     .overlay(
                         HStack(spacing: 6) {
                             Image(systemName: workout.category.icon)
                                 .font(.system(size: 12, weight: .medium))
                             Text(workout.category.rawValue.uppercased())
                                 .font(.system(size: 12, weight: .bold))
                         }
                         .foregroundColor(.white)
                         .padding(.horizontal, 12)
                     )
                 
                 Spacer()
                 
                 // Completion Status
                 if workout.isCompleted {
                     Image(systemName: "checkmark.circle.fill")
                         .font(.title3)
                         .foregroundColor(.green)
                         .transition(.scale)
                 }
             }
             
             Text(workout.title)
                 .font(.system(size: 34, weight: .black, design: .rounded))
                 .foregroundColor(.white)
                 .fixedSize(horizontal: false, vertical: true)
             
             Text(workout.description)
                 .font(.system(size: 16, weight: .medium))
                 .foregroundColor(.gray)
                 .lineSpacing(4)
                 .fixedSize(horizontal: false, vertical: true)
         }
         .padding(.horizontal, 24)
         .padding(.top, 16)
     }
     
     // MARK: - Quick Stats
     private func QuickStatsSection() -> some View {
         HStack(spacing: 16) {
             StatPills(
                 icon: "clock",
                 value: workout.formattedDuration,
                 title: "DURATION",
                 color: .blue
             )
             
             StatPills(
                 icon: "dumbbell",
                 value: "\(workout.exercises.count)",
                 title: "EXERCISES",
                 color: .green
             )
             
             StatPills(
                 icon: "flame",
                 value: "\(workout.estimatedCalories)",
                 title: "EST. CAL",
                 color: .red
             )
         }
         .padding(.horizontal, 24)
         .padding(.top, 20)
     }
     
     // MARK: - Exercises
     private func ExercisesSection() -> some View {
         VStack(alignment: .leading, spacing: 20) {
             Text("EXERCISES")
                 .font(.system(size: 18, weight: .black, design: .rounded))
                 .foregroundColor(.white)
                 .padding(.horizontal, 24)
             
             LazyVStack(spacing: 12) {
                 ForEach(Array(workout.exercises.enumerated()), id: \.offset) { index, exercise in
                     ExerciseCard(
                         exercise: exercise,
                         index: index,
                         onTap: {
                             withAnimation(.spring()) {
                                 selectedExercise = exercise
                             }
                         }
                     )
                     .padding(.horizontal, 24)
                 }
             }
         }
     }
     
     // MARK: - Sticky Start Button
     private func StickyStartButton() -> some View {
         Button {
             startWorkout()
         } label: {
             HStack(spacing: 12) {
                 if isStartingWorkout {
                     ProgressView()
                         .progressViewStyle(CircularProgressViewStyle(tint: .white))
                 } else {
                     Image(systemName: "play.fill")
                         .font(.system(size: 20, weight: .bold))
                 }
                 
                 Text(isStartingWorkout ? "PREPARING..." : "START WORKOUT")
                     .font(.system(size: 18, weight: .black, design: .rounded))
                 
                 Spacer()
                 
                 if !isStartingWorkout {
                     Image(systemName: "chevron.right")
                         .font(.system(size: 16, weight: .bold))
                 }
             }
             .foregroundColor(.black)
             .padding(.vertical, 20)
             .padding(.horizontal, 24)
             .background(
                 LinearGradient(
                     colors: [.white, .white.opacity(0.9)],
                     startPoint: .leading,
                     endPoint: .trailing
                 )
             )
             .cornerRadius(20)
             .shadow(color: .white.opacity(0.3), radius: 20, x: 0, y: 10)
         }
         .disabled(isStartingWorkout)
     }
     
     private func startWorkout() {
         isStartingWorkout = true
         
         // Haptic feedback
         let impact = UIImpactFeedbackGenerator(style: .heavy)
         impact.impactOccurred()
         
         // Show workout start animation
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
             isStartingWorkout = false
             withAnimation(.spring()) {
                 showWorkoutStartAnimation = true
             }
         }
     }
 }
// MARK: - Workout Start Countdown View
struct WorkoutStartCountdownView: View {
    @Binding var isShowing: Bool
    let onComplete: () -> Void
    
    @State private var countdown = 3
    @State private var progress: CGFloat = 1.0
    @State private var scaleEffect: CGFloat = 1.0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Animated background
            Color.black.opacity(0.95)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                // Animated circles
                ZStack {
                    ForEach(0..<3) { index in
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [.blue, .purple, .orange],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 4
                            )
                            .frame(width: 120 + CGFloat(index * 40), height: 120 + CGFloat(index * 40))
                            .scaleEffect(scaleEffect)
                            .opacity(1 - Double(index) * 0.3)
                            .animation(
                                .easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                                value: scaleEffect
                            )
                    }
                    
                    // Central icon with countdown
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 120, height: 120)
                        
                        Text("\(countdown)")
                            .font(.system(size: 60, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .scaleEffect(scaleEffect)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: countdown)
                    }
                }
                
                VStack(spacing: 16) {
                    Text("GET READY!")
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Starting your workout in")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)
                }
                
                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.white.opacity(0.3))
                            .frame(height: 4)
                        
                        RoundedRectangle(cornerRadius: 2)
                            .fill(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * progress, height: 4)
                    }
                }
                .frame(height: 4)
                .padding(.horizontal, 40)
            }
            .padding(40)
        }
        .onAppear {
            startCountdown()
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                scaleEffect = 1.2
            }
        }
        .onReceive(timer) { _ in
            if countdown > 1 {
                withAnimation(.spring()) {
                    countdown -= 1
                    progress = CGFloat(countdown - 1) / 3.0
                }
                
                // Haptic feedback for each count
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
            } else {
                // Final countdown completed
                let notification = UINotificationFeedbackGenerator()
                notification.notificationOccurred(.success)
                
                timer.upstream.connect().cancel()
                isShowing = false
                onComplete()
            }
        }
    }
    
    private func startCountdown() {
        progress = 1.0
    }
}
struct ExerciseCard: View {
    let exercise: Exercise
    let index: Int
    let onTap: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            onTap()
        }) {
            HStack(spacing: 16) {
                // Index Badge
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            colors: [.white.opacity(0.2), .white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 44, height: 44)
                    
                    Text("\(index + 1)")
                        .font(.system(size: 16, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(exercise.name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    if let sets = exercise.sets, let reps = exercise.reps {
                        Text("\(sets) sets × \(reps) reps")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    
                    if let restTime = exercise.formattedRestTime {
                        HStack(spacing: 6) {
                            Image(systemName: "timer")
                                .font(.system(size: 12))
                            Text("Rest: \(restTime)")
                                .font(.system(size: 12, weight: .medium))
                        }
                        .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(16)
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
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

// MARK: - Active Workout View
struct ActiveWorkoutView: View {
    let workout: Workout
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: WorkoutViewModel
    
    @State private var currentExerciseIndex = 0
    @State private var timeRemaining = 0
    @State private var isTimerRunning = false
    @State private var workoutStartTime = Date()
    @State private var completedExercises: Set<UUID> = []
    @State private var showCompletion = false
    @State private var exerciseStartTime = Date()
    @State private var showExerciseAnimation = false
    @State private var exerciseElapsedTime = 0
    @State private var isResting = false
    
    let mainTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var currentExercise: Exercise {
        workout.exercises[currentExerciseIndex]
    }
    
    var progress: Double {
        Double(currentExerciseIndex) / Double(workout.exercises.count)
    }
    
    var isLastExercise: Bool {
        currentExerciseIndex == workout.exercises.count - 1
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress Header
                ProgressHeader()
                
                // Exercise Content
                ExerciseContentView()
                
                // Controls
                ControlsSection()
            }
            
            if showCompletion {
                WorkoutCompletionOverlay()
            }
            
            // Exercise transition animation
            if showExerciseAnimation {
                ExerciseTransitionOverlay()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("End") {
                    completeWorkout()
                }
                .foregroundColor(.red)
            }
        }
        .onReceive(mainTimer) { _ in
            exerciseElapsedTime = Int(Date().timeIntervalSince(exerciseStartTime))
            
            if isResting && timeRemaining > 0 {
                timeRemaining -= 1
                if timeRemaining == 0 {
                    isResting = false
                }
            }
        }
        .onAppear {
            workoutStartTime = Date()
            exerciseStartTime = Date()
            startExercise()
        }
    }
    
    private func ProgressHeader() -> some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("EXERCISE \(currentExerciseIndex + 1) OF \(workout.exercises.count)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.gray)
                    
                    Text("\(Int(progress * 100))% COMPLETE")
                        .font(.system(size: 14, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // Live timer for current exercise
                Text(formatTime(exerciseElapsedTime))
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .foregroundColor(.green)
                
                if isResting {
                    Text(formatTime(timeRemaining))
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .foregroundColor(.orange)
                        .monospacedDigit()
                }
            }
            
            // Custom Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 6)
                    
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress, height: 6)
                        .cornerRadius(3)
                }
            }
            .frame(height: 6)
        }
        .padding()
        .background(Color.white.opacity(0.05))
    }
    
    private func ExerciseContentView() -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Exercise Header with animation
                VStack(alignment: .leading, spacing: 12) {
                    Text(currentExercise.name)
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .id(currentExercise.id)
                    
                    if let sets = currentExercise.sets, let reps = currentExercise.reps {
                        HStack(spacing: 16) {
                            StatBadge(icon: "square.stack.3d.up", value: "\(sets)")
                            StatBadge(icon: "repeat", value: "\(reps)")
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                // Instructions Card
                VStack(alignment: .leading, spacing: 16) {
                    Text("INSTRUCTIONS")
                        .font(.system(size: 16, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(currentExercise.instructions)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                        .lineSpacing(6)
                }
                .padding(20)
                .background(Color.white.opacity(0.05))
                .cornerRadius(16)
                .padding(.horizontal, 24)
                
                // Tips
                if !currentExercise.tips.isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("PRO TIPS")
                            .font(.system(size: 16, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        
                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(Array(currentExercise.tips.enumerated()), id: \.offset) { index, tip in
                                HStack(alignment: .top, spacing: 12) {
                                    Text("\(index + 1)")
                                        .font(.system(size: 14, weight: .black, design: .rounded))
                                        .foregroundColor(.white)
                                        .frame(width: 24, height: 24)
                                        .background(Circle().fill(Color.blue))
                                    
                                    Text(tip)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.gray)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding(20)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(16)
                    .padding(.horizontal, 24)
                }
            }
            .padding(.vertical, 24)
        }
    }
    
    private func ControlsSection() -> some View {
        VStack(spacing: 16) {
            if isResting {
                // Rest Timer with animation
                VStack(spacing: 12) {
                    Text("REST TIME")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.orange)
                    
                    Text(formatTime(timeRemaining))
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .foregroundColor(.orange)
                        .monospacedDigit()
                    
                    // Animated rest timer circle
                    RestTimerCircle(timeRemaining: timeRemaining, totalTime: Int(currentExercise.restTime ?? 60))
                    
                    Button("SKIP REST") {
                        timeRemaining = 0
                        isResting = false
                    }
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white.opacity(0.7))
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(16)
            } else {
                Button {
                    if isLastExercise {
                        completeWorkout()
                    } else {
                        moveToNextExercise()
                    }
                } label: {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20, weight: .bold))
                        
                        Text(isLastExercise ? "COMPLETE WORKOUT" : "NEXT EXERCISE")
                            .font(.system(size: 18, weight: .black, design: .rounded))
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundColor(.black)
                    .padding(.vertical, 20)
                    .padding(.horizontal, 24)
                    .background(Color.white)
                    .cornerRadius(20)
                }
            }
        }
        .padding()
        .background(Color.black)
    }
    
    // MARK: - Animation Components
    
    private func ExerciseTransitionOverlay() -> some View {
        ZStack {
            Color.black.opacity(0.9)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Image(systemName: currentExercise.difficulty == .beginner ? "figure.walk" :
                      currentExercise.difficulty == .intermediate ? "figure.run" : "bolt")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                    .scaleEffect(1.5)
                    .rotationEffect(.degrees(360))
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: false), value: showExerciseAnimation)
                
                Text("NEXT EXERCISE")
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                
                Text(currentExercise.name)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
                Text("Get ready!")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(40)
            .background(Color.white.opacity(0.05))
            .cornerRadius(25)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeOut(duration: 0.5)) {
                    showExerciseAnimation = false
                }
            }
        }
    }
    
    private func RestTimerCircle(timeRemaining: Int, totalTime: Int) -> some View {
        ZStack {
            Circle()
                .stroke(Color.orange.opacity(0.3), lineWidth: 6)
                .frame(width: 80, height: 80)
            
            Circle()
                .trim(from: 0, to: CGFloat(timeRemaining) / CGFloat(totalTime))
                .stroke(
                    LinearGradient(colors: [.orange, .red], startPoint: .top, endPoint: .bottom),
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                .frame(width: 80, height: 80)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1), value: timeRemaining)
        }
    }
    
    // MARK: - Helper Methods
    
    private func startExercise() {
        exerciseStartTime = Date()
        exerciseElapsedTime = 0
        isResting = false
    }
    
    private func startRestPeriod() {
        if let restTime = currentExercise.restTime {
            timeRemaining = Int(restTime)
            isResting = true
            
            // Haptic feedback for rest start
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }
    }
    
    private func moveToNextExercise() {
        completedExercises.insert(currentExercise.id)
        
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        // Show exercise transition animation
        withAnimation(.spring()) {
            showExerciseAnimation = true
        }
        
        // Start rest period before next exercise
        startRestPeriod()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if currentExerciseIndex < workout.exercises.count - 1 {
                withAnimation(.spring()) {
                    currentExerciseIndex += 1
                    startExercise()
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeOut(duration: 0.5)) {
                    showExerciseAnimation = false
                }
            }
        }
    }
    
    private func completeWorkout() {
        let endTime = Date()
        let duration = endTime.timeIntervalSince(workoutStartTime)
        let calories = Double(workout.estimatedCalories)
        
  
        
        // Mark as completed
        viewModel.markWorkoutAsCompleted(workout)
        
        // Celebration haptic
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.success)
        
        showCompletion = true
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    // MARK: - Workout Completion Overlay
    private func WorkoutCompletionOverlay() -> some View {
        ZStack {
            Color.black.opacity(0.95)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Celebration animation
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [.yellow, .orange], startPoint: .top, endPoint: .bottom))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 16) {
                    Text("WORKOUT COMPLETE!")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("You crushed it! 💪")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)
                    
                    // Workout summary
                    VStack(spacing: 12) {
                        SummaryRow(icon: "clock", title: "Total Time", value: formatTime(Int(Date().timeIntervalSince(workoutStartTime))))
                        SummaryRow(icon: "dumbbell", title: "Exercises", value: "\(workout.exercises.count)")
                        SummaryRow(icon: "flame", title: "Calories", value: "\(workout.estimatedCalories)")
                    }
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(16)
                }
                
                Button("DISMISS") {
                    dismiss()
                }
                .font(.system(size: 16, weight: .black, design: .rounded))
                .foregroundColor(.black)
                .padding(.vertical, 16)
                .padding(.horizontal, 32)
                .background(Color.white)
                .cornerRadius(25)
            }
            .padding(40)
        }
        .transition(.opacity)
    }
}

// MARK: - Supporting Views
struct SummaryRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .frame(width: 20)
                
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
    }
}

// MARK: - Stat Badge
private func StatBadge(icon: String, value: String) -> some View {
    HStack(spacing: 8) {
        Image(systemName: icon)
            .font(.system(size: 14, weight: .bold))
        Text(value)
            .font(.system(size: 16, weight: .black, design: .rounded))
    }
    .foregroundColor(.white)
    .padding(.horizontal, 12)
    .padding(.vertical, 8)
    .background(Color.white.opacity(0.1))
    .cornerRadius(8)
}

// MARK: - Scroll Offset Key
struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}



// MARK: - Lottie Animation View (Placeholder)
struct LottieAnimationView: View {
    let animationName: String
    
    var body: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(colors: [.yellow, .orange], startPoint: .top, endPoint: .bottom))
                .frame(width: 120, height: 120)
            
            Image(systemName: "trophy.fill")
                .font(.system(size: 50))
                .foregroundColor(.white)
        }
    }
}


// MARK: - Exercise Detail View
struct ExerciseDetailView: View {
    let exercise: Exercise
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 12) {
                        Text(exercise.name)
                            .font(.system(size: 32, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        
                        if let sets = exercise.sets, let reps = exercise.reps {
                            HStack(spacing: 16) {
                                StatBadge(icon: "square.stack.3d.up", value: "\(sets) SETS")
                                StatBadge(icon: "repeat", value: "\(reps) REPS")
                                
                                if let restTime = exercise.formattedRestTime {
                                    StatBadge(icon: "timer", value: restTime)
                                }
                            }
                        }
                    }
                    
                    // Instructions
                    VStack(alignment: .leading, spacing: 16) {
                        Text("EXECUTION")
                            .font(.system(size: 18, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text(exercise.instructions)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                            .lineSpacing(6)
                    }
                    
                    // Tips
                    if !exercise.tips.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("EXPERT TIPS")
                                .font(.system(size: 18, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                            
                            LazyVStack(alignment: .leading, spacing: 12) {
                                ForEach(Array(exercise.tips.enumerated()), id: \.offset) { index, tip in
                                    HStack(alignment: .top, spacing: 12) {
                                        Text("\(index + 1)")
                                            .font(.system(size: 14, weight: .black, design: .rounded))
                                            .foregroundColor(.white)
                                            .frame(width: 24, height: 24)
                                            .background(Circle().fill(Color.blue))
                                        
                                        Text(tip)
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.gray)
                                            .fixedSize(horizontal: false, vertical: true)
                                        
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(24)
            }
        }
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
    
     func StatBadge(icon: String, value: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .bold))
            Text(value)
                .font(.system(size: 16, weight: .black, design: .rounded))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.1))
        .cornerRadius(8)
    }
}

// MARK: - Updated WorkoutFilterView
struct WorkoutFilterView: View {
    @Binding var selectedCategory: WorkoutCategory?
    @Binding var selectedDifficulty: Difficulty?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Category Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("CATEGORY")
                                .font(.system(size: 16, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                ForEach(WorkoutCategory.allCases, id: \.self) { category in
                                    CategoryFilterButton(
                                        category: category,
                                        isSelected: selectedCategory == category,
                                        action: { selectedCategory = category }
                                    )
                                }
                            }
                        }
                        
                        // Difficulty Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("DIFFICULTY")
                                .font(.system(size: 16, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                                ForEach(Difficulty.allCases, id: \.self) { difficulty in
                                    DifficultyFilterButton(
                                        difficulty: difficulty,
                                        isSelected: selectedDifficulty == difficulty,
                                        action: { selectedDifficulty = difficulty }
                                    )
                                }
                            }
                        }
                        
                        // Reset Button
                        Button("Reset Filters") {
                            selectedCategory = nil
                            selectedDifficulty = nil
                            dismiss()
                        }
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.red)
                        .padding(.top, 20)
                    }
                    .padding(24)
                }
            }
            .navigationTitle("FILTERS")
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

struct CategoryFilterButton: View {
    let category: WorkoutCategory
    let isSelected: Bool
    let action: () -> Void
    
    private var categoryColor: Color {
        switch category {
        case .strength: return .orange
        case .cardio: return .red
        case .yoga: return .green
        case .hiit: return .purple
        case .mobility: return .blue
        case .recovery: return .indigo
        case .crossfit: return .brown
        case .calisthenics: return .teal
        case .pilates: return .pink
        case .sports: return .yellow
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: category.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isSelected ? .black : .white)
                
                Text(category.rawValue)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(isSelected ? .black : .white)
            }
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .background(
                isSelected ? Color.white : Color.white.opacity(0.1)
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
        }
    }
}


// Enhanced Category Badge component
struct CategoryBadgese: View {
    let category: WorkoutCategory
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: category.icon)
                .font(.system(size: 12, weight: .medium))
            
            Text(category.rawValue.uppercased())
                .font(.system(size: 12, weight: .bold))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(category.color)
        .cornerRadius(8)
    }
}

// Updated StatPill with proper colors
struct StatPills: View {
    let icon: String
    let value: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 16, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                
                Text(title)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

struct DifficultyFilterButton: View {
    let difficulty: Difficulty
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(difficulty.rawValue)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(isSelected ? Color.black : difficulty.color)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(
                    isSelected ? difficulty.color : difficulty.color.opacity(0.1)
                )
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(difficulty.color.opacity(0.3), lineWidth: 1)
                )
        }
    }
}
