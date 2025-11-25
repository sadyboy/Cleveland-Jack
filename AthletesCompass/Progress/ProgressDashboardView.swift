import SwiftUI
import Charts

struct ProgressDashboardView: View {
    @EnvironmentObject var questVM: FitnessQuestViewModel
    @EnvironmentObject var workoutVM: WorkoutViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    
                    LevelSection().environmentObject(questVM)
                    
                    QuickStatsSection(
                        questVM: questVM,
                        workoutVM: workoutVM,
                        
                    )
                    
                    ProgressChartsSection()
                    
                    WorkoutHistorySection().environmentObject(workoutVM)
                }
                .padding()
            }
            .navigationTitle("Progress")
        }
    }
}
struct LevelSection: View {
    @EnvironmentObject var questVM: FitnessQuestViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Level \(questVM.playerLevel)")
                .font(.system(size: 32, weight: .black))
                .foregroundColor(.white)
            
            ProgressBar(value: questVM.levelProgress, color: .white)
                .frame(height: 10)

        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }
}


struct QuickStatsSection: View {
    let questVM: FitnessQuestViewModel
    let workoutVM: WorkoutViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Statistics")
                .font(.title2.bold())
                .foregroundColor(.white)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                
                StatCard(
                    title: "XP",
                    value: "\(questVM.experiencePoints)",
                    subtitle: "total",
                    icon: "⭐️",
                    color: .yellow
                )
                
                StatCard(
                    title: "Coins",
                    value: "\(questVM.coins)",
                    subtitle: "earned",
                    icon: "🪙",
                    color: .green
                )
                
                StatCard(
                    title: "Quests",
                    value: "\(questVM.completedQuests)",
                    subtitle: "completed",
                    icon: "🇫🇲",
                    color: .blue
                )
                
                StatCard(
                    title: "Knowledge",
                    value: "\(questVM.knowledgeCards.filter{$0.isMastered}.count)",
                    subtitle: "mastered",
                    icon: "🧠",
                    color: .purple
                )
            }
            
        }
    
    }
}


private struct StatCards: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                Spacer()
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
            
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

private struct ProgressChartsSection: View {
    @EnvironmentObject var questVM: FitnessQuestViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("XP Progress (Last 30 Days)")
                .font(.title2.bold())
                .foregroundColor(.white)
            
            VStack {
                Chart(questVM.monthlyXP) { point in
                    
                    LineMark(
                        x: .value("Date", point.date, unit: .day),
                        y: .value("XP", point.value)
                    )
                    .foregroundStyle(.orange.gradient)
                    .interpolationMethod(.catmullRom)
                    
                    AreaMark(
                        x: .value("Date", point.date, unit: .day),
                        y: .value("XP", point.value)
                    )
                    .foregroundStyle(.orange.opacity(0.2).gradient)
                }
                .frame(height: 200)
                .padding()
            }
            .background(Color.white.opacity(0.08))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }
        .padding(.horizontal, 24)
    }
}

private struct WorkoutHistorySection: View {
    @EnvironmentObject var workoutVM: WorkoutViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Workout History")
                .font(.title2.bold())
                .foregroundColor(.white)
            
            let history = workoutVM.workouts.filter { $0.isCompleted }
            
            if history.isEmpty {
                EmptyStateView()
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(history.prefix(5)) { workout in
                        WorkoutHistoryRow(workout: workout)
                    }
                    
                    if history.count > 5 {
                        NavigationLink("Show All") {
                            WorkoutHistoryView()
                                .environmentObject(workoutVM)
                        }
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding(.top, 8)
                    }
                }
            }
        }
    }
}


private struct WorkoutHistoryRow: View {
    let workout: Workout
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(workout.title)
                    .font(.headline)
                
                HStack {
                    Label(workout.formattedDuration, systemImage: "clock")
                    Spacer()
                    if let date = workout.dateCompleted {
                        Text(date, style: .date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.title2)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

private struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("Your progress will be here")
            .font(.headline)
            .foregroundColor(.primary)

            Text("Complete workouts and track your achievements")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

struct WorkoutHistoryView: View {
    @EnvironmentObject var viewModel: ProgressViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.workoutHistory) { workout in
                VStack(alignment: .leading, spacing: 4) {
                    Text(workout.title)
                        .font(.headline)
                    
                    HStack {
                        Text(workout.category.rawValue)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        if let date = workout.dateCompleted {
                            Text(date, style: .date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Training History")
    }
}
