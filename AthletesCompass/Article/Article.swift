import Foundation
import SwiftUI


struct Article: Identifiable, Codable {
    let id: UUID
    var title: String
    var subtitle: String
    var content: String
    var author: String
    var publishDate: Date
    var category: ArticleCategory
    var readingTime: Int // in minutes
    var imageName: String?
    var isFeatured: Bool = false
    var difficulty: ArticleDifficulty = .beginner
    var tags: [String] = []
    var quiz: [ArticleQuizQuestion] = []
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: publishDate)
    }
    
    var timeAgo: String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day, .hour, .minute], from: publishDate, to: now)
        
        if let days = components.day, days > 0 {
            return days == 1 ? "1 day ago" : "\(days) days ago"
        } else if let hours = components.hour, hours > 0 {
            return hours == 1 ? "1 hour ago" : "\(hours) hours ago"
        } else if let minutes = components.minute, minutes > 0 {
            return minutes == 1 ? "1 minute ago" : "\(minutes) minutes ago"
        } else {
            return "Just now"
        }
    }
}

// MARK: - Enhanced Mock Data with English Content
extension Article {
    static var mockData: [Article] = [
        // Training Articles
        Article(
            id: UUID(),
            title: "Progressive Overload Mastery",
            subtitle: "The fundamental principle of strength training",
            content: """
            Progressive overload is the cornerstone of all strength and muscle growth. Without consistently challenging your muscles, progress stalls. The key is systematic progression in volume, intensity, or frequency.
            
            Methods of Progressive Overload:
            • Increase weight while maintaining reps
            • Increase reps with same weight
            • Increase sets for more volume
            • Improve form and mind-muscle connection
            • Reduce rest time between sets
            
            Weekly Progression Strategy:
            - Week 1: Establish baseline with perfect form
            - Week 2: Add 1-2 reps to each working set
            - Week 3: Increase weight by 2.5-5%
            - Week 4: Deload and consolidate gains
            
            Track every workout and aim for small, consistent improvements. Progress isn't always linear, but the trend should always be upward.
            """,
            author: "Coach Mike Johnson",
            publishDate: Date().addingTimeInterval(-86400 * 2),
            category: .training,
            readingTime: 8,
            isFeatured: true,
            difficulty: .beginner,
            tags: ["progressive overload", "strength", "programming", "basics"],
            quiz: [
                ArticleQuizQuestion(
                    question: "What is the most basic form of progressive overload?",
                    correctAnswer: "Adding more weight",
                    options: ["Adding more sets", "Adding more weight", "Changing exercises", "Increasing rest time"]
                ),
                ArticleQuizQuestion(
                    question: "How often should you typically increase weight?",
                    correctAnswer: "Every 1-2 weeks",
                    options: ["Every day", "Every 1-2 weeks", "Once a month", "Every 6 months"]
                ),
                ArticleQuizQuestion(
                    question: "What is a deload week for?",
                    correctAnswer: "Recovery and preventing overtraining",
                    options: ["Maximum intensity", "Recovery and preventing overtraining", "Testing 1RM", "Learning new exercises"]
                )
            ]
        ),
        
        Article(
            id: UUID(),
            title: "Compound vs Isolation Exercises",
            subtitle: "When to use each for maximum results",
            content: """
            Understanding when to use compound versus isolation exercises can dramatically impact your training efficiency and results.
            
            Compound Exercises:
            • Work multiple muscle groups simultaneously
            • Examples: Squats, Deadlifts, Bench Press, Pull-ups
            • Best for: Strength, functional fitness, time efficiency
            • Ideal for: Main workout movements
            
            Isolation Exercises:
            • Target single muscle groups
            • Examples: Bicep Curls, Tricep Extensions, Leg Extensions
            • Best for: Muscle definition, weak point training
            • Ideal for: Accessory work, rehabilitation
            
            Smart Programming Ratio:
            - Beginners: 80% compound, 20% isolation
            - Intermediate: 70% compound, 30% isolation  
            - Advanced: 60% compound, 40% isolation
            
            Always prioritize compound movements in your main workout, then use isolation exercises to address specific needs.
            """,
            author: "Dr. Sarah Chen",
            publishDate: Date().addingTimeInterval(-86400 * 4),
            category: .training,
            readingTime: 10,
            isFeatured: false,
            difficulty: .beginner,
            tags: ["compound", "isolation", "exercise selection", "programming"],
            quiz: [
                ArticleQuizQuestion(
                    question: "Which is a compound exercise?",
                    correctAnswer: "Squat",
                    options: ["Bicep curl", "Squat", "Tricep extension", "Calf raise"]
                ),
                ArticleQuizQuestion(
                    question: "What percentage of workout should be compound for beginners?",
                    correctAnswer: "80%",
                    options: ["50%", "60%", "80%", "90%"]
                ),
                ArticleQuizQuestion(
                    question: "When are isolation exercises most useful?",
                    correctAnswer: "Targeting specific muscle groups",
                    options: ["Building maximum strength", "Targeting specific muscle groups", "Improving cardiovascular health", "Learning proper form"]
                )
            ]
        ),
        
        Article(
            id: UUID(),
            title: "Training Frequency Optimization",
            subtitle: "How often should you train each muscle group?",
            content: """
            Training frequency is one of the most debated topics in fitness. The optimal frequency depends on your experience level, recovery capacity, and specific goals.
            
            Frequency Guidelines:
            • Beginners: 2-3 times per week (full body)
            • Intermediate: 4-5 times per week (upper/lower or push/pull/legs)
            • Advanced: 5-6 times per week (specialized splits)
            
            Key Considerations:
            - Volume per session matters more than frequency alone
            - Larger muscle groups need more recovery time
            - Listen to your body - soreness doesn't always mean growth
            - Quality over quantity always applies
            
            Sample Splits:
            Full Body (3x/week): Monday, Wednesday, Friday
            Upper/Lower (4x/week): Upper Mon/Thu, Lower Tue/Fri
            PPL (6x/week): Push, Pull, Legs, repeat
            
            The best split is the one you can consistently follow while making progress.
            """,
            author: "Coach Rachel Martinez",
            publishDate: Date().addingTimeInterval(-86400 * 1),
            category: .training,
            readingTime: 12,
            isFeatured: true,
            difficulty: .intermediate,
            tags: ["frequency", "splits", "recovery", "programming"],
            quiz: [
                ArticleQuizQuestion(
                    question: "What's the recommended frequency for beginners?",
                    correctAnswer: "2-3 times per week",
                    options: ["Every day", "2-3 times per week", "Once a week", "5-6 times per week"]
                ),
                ArticleQuizQuestion(
                    question: "Which split uses Push, Pull, Legs?",
                    correctAnswer: "PPL",
                    options: ["Full Body", "Upper/Lower", "Bro Split", "PPL"]
                ),
                ArticleQuizQuestion(
                    question: "What matters more than frequency alone?",
                    correctAnswer: "Volume per session",
                    options: ["Exercise variety", "Volume per session", "Gym equipment", "Workout duration"]
                )
            ]
        ),

        Article(
            id: UUID(),
            title: "The Science of Protein Timing",
            subtitle: "Optimize muscle synthesis with strategic nutrient timing",
            content: """
            Protein timing is one of the most underrated tools for improving muscle growth and recovery. While total daily protein intake matters most, how you distribute that protein throughout the day plays a significant role in maximizing muscle protein synthesis (MPS).
            
            The body can efficiently use around 20–40g of high-quality protein per meal. This range provides enough essential amino acids and leucine to trigger MPS without overwhelming your digestion.
            
            Key Practical Rules:
            • Eat 4–6 protein-rich meals per day
            • Include 2–3g leucine in each serving (naturally present in meat, whey, eggs)
            • Consume fast-digesting protein post-workout
            • Casein is ideal before sleep due to slow absorption
            
            By balancing protein across your day instead of “saving it for later,” you maintain an anabolic environment and accelerate recovery, strength gains, and lean muscle growth.Protein timing has evolved from simple post-workout windows...
            """,
            author: "Dr. Sarah Chen",
            publishDate: Date().addingTimeInterval(-86400 * 1),
            category: .nutrition,
            readingTime: 12,
            isFeatured: true,
            difficulty: .intermediate,
            tags: ["protein", "muscle growth", "timing", "supplements"],
            quiz: [
                ArticleQuizQuestion(
                    question: "How much protein per meal maximizes muscle protein synthesis?",
                    correctAnswer: "20-40g",
                    options: ["5-10g", "10-20g", "20-40g", "50-70g"]
                ),
                ArticleQuizQuestion(
                    question: "Which protein is ideal before sleep?",
                    correctAnswer: "Casein",
                    options: ["Whey", "Casein", "Soy", "Egg protein"]
                ),
                ArticleQuizQuestion(
                    question: "What nutrient triggers the leucine threshold?",
                    correctAnswer: "Leucine (2–3g)",
                    options: ["Creatine", "Leucine (2–3g)", "Caffeine", "Iron"]
                )
            ]
        ),
        
        Article(
            id: UUID(),
            title: "Advanced Recovery Protocols",
            subtitle: "Beyond ice baths: Modern recovery science",
            content: """
Modern recovery goes far beyond ice baths and stretching. Today athletes use a combination of physiological, neurological, and metabolic methods to shorten recovery time and improve performance.

Contrast showers stimulate circulation, flushing metabolites and reducing inflammation. Compression boots improve venous return and restore leg freshness after intense sessions. Red light therapy targets mitochondria, improving cellular repair and reducing muscle soreness.

Daily Recovery Stack:
• Morning: mobility + breathwork  
• Post-training: contrast water therapy  
• Evening: compression + low-intensity movement  
• Before bed: red light and deep relaxation  

Optimizing recovery is not about a single magical method — it's the synergy of multiple techniques timed correctly.
"""
            ,
            author: "Dr. Marcus Johnson",
            publishDate: Date().addingTimeInterval(-86400 * 3),
            category: .recovery,
            readingTime: 15,
            isFeatured: true,
            difficulty: .advanced,
            tags: ["recovery", "technology", "performance", "monitoring"],
            quiz: [
                ArticleQuizQuestion(
                    question: "What is the main benefit of contrast water therapy?",
                    correctAnswer: "Enhanced blood flow & reduced inflammation",
                    options: [
                        "Muscle damage",
                        "Enhanced blood flow & reduced inflammation",
                        "Lower VO2 max",
                        "Less sleep needed"
                    ]
                ),
                ArticleQuizQuestion(
                    question: "Which tool boosts recovery using air compression?",
                    correctAnswer: "Pneumatic compression boots",
                    options: ["Resistance bands", "Ice bath", "EMS device", "Pneumatic compression boots"]
                ),
                ArticleQuizQuestion(
                    question: "Which biomarker is commonly used to assess recovery readiness?",
                    correctAnswer: "HRV",
                    options: ["Blood pressure", "VO2 max", "HRV", "Resting glucose"]
                )
            ]
        ),
        
        Article(
            id: UUID(),
            title: "Periodization for Strength Athletes",
            subtitle: "Structuring your training for long-term progress",
            content: """
Periodization is the backbone of long-term strength development. Instead of training randomly, athletes structure their workload across cycles to prevent stagnation and overtraining.

Linear models gradually increase intensity over weeks, while undulating periodization changes intensity daily to keep the body adapting. Block training focuses on one athletic quality at a time — volume, strength, or power.

A well-built program ensures:
• Consistent progression without burnout  
• Adequate recovery between peaks  
• Focused skill development  
• Predictable strength gains  

Periodization is what separates advanced athletes from casual lifters — disciplined planning replaces guesswork.
"""
            ,
            author: "Coach Rachel Martinez",
            publishDate: Date().addingTimeInterval(-86400 * 5),
            category: .programming,
            readingTime: 18,
            isFeatured: true,
            difficulty: .intermediate,
            tags: ["periodization", "programming", "strength", "progress"],
            quiz: [
                ArticleQuizQuestion(
                    question: "Which periodization model changes intensity daily?",
                    correctAnswer: "Undulating",
                    options: ["Linear", "Block", "Undulating", "Conjugate"]
                ),
                ArticleQuizQuestion(
                    question: "What is the purpose of a deload week?",
                    correctAnswer: "Active recovery and reducing fatigue",
                    options: [
                        "Increase volume drastically",
                        "Active recovery and reducing fatigue",
                        "Test 1RM",
                        "Sprint training"
                    ]
                ),
                ArticleQuizQuestion(
                    question: "What is the main goal of the peaking phase?",
                    correctAnswer: "Maximize performance",
                    options: ["Build muscle", "Lose fat", "Maximize performance", "Improve mobility"]
                )
            ]
        ),
        
        Article(
            id: UUID(),
            title: "The Psychology of Peak Performance",
            subtitle: "Mental strategies for competition success",
            content: """
Mental preparation is often the deciding factor between good performance and greatness. Elite athletes use psychological skills to optimize focus, confidence, and emotional control during competition.

Visualization allows athletes to “train” neural pathways before real movement occurs. Self-talk can shift internal dialogue from doubt to execution. Arousal control helps maintain an ideal performance state — energized, but not overstimulated.

A solid mental routine includes:
• Visualization before key sessions  
• Positive cue words to stay focused  
• Controlled breathing to manage stress  
• Goal setting based on daily progress  

When the mind is trained as well as the body, performance becomes significantly more consistent and resilient under pressure.
"""
            ,
            author: "Dr. Benjamin Carter",
            publishDate: Date().addingTimeInterval(-86400 * 7),
            category: .psychology,
            readingTime: 14,
            difficulty: .beginner,
            tags: ["psychology", "performance", "mindset", "competition"],
            quiz: [
                ArticleQuizQuestion(
                    question: "What mental technique involves visual rehearsal?",
                    correctAnswer: "Visualization",
                    options: ["Journaling", "Meditation", "Visualization", "Self-talk"]
                ),
                ArticleQuizQuestion(
                    question: "Which performance principle follows an inverted-U curve?",
                    correctAnswer: "Arousal levels",
                    options: ["Protein intake", "Carb loading", "Arousal levels", "Sleep duration"]
                ),
                ArticleQuizQuestion(
                    question: "Self-talk improves performance by how much?",
                    correctAnswer: "5–15%",
                    options: ["1–2%", "5–15%", "20–30%", "50%"]
                )
            ]
        ),
        
        Article(
            id: UUID(),
            title: "Biomechanics of the Perfect Squat",
            subtitle: "Optimize technique for safety and performance",
            content: """
The squat is a fundamental movement pattern, but performing it safely and efficiently requires understanding biomechanics. Small anatomical differences greatly influence form.

Hip structure affects depth, femur length influences torso angle, and ankle mobility determines knee travel. Fixing knee valgus often requires strengthening the glutes and improving motor control, not just “pushing the knees out.”

Proper Squat Principles:
• Neutral spine under all loads  
• Knees track naturally over toes  
• Feet angled according to hip anatomy  
• Controlled descent with powerful drive upward  

A perfect squat is not universal — it’s individualized for each athlete’s structure and mobility.
"""
            ,
            author: "Dr. Elena Rodriguez",
            publishDate: Date().addingTimeInterval(-86400 * 2),
            category: .technique,
            readingTime: 16,
            isFeatured: true,
            difficulty: .beginner,
            tags: ["squat", "technique", "biomechanics", "form"],
            quiz: [
                ArticleQuizQuestion(
                    question: "What causes ‘knee valgus’ during squats?",
                    correctAnswer: "Weak hip abductors",
                    options: ["Weak hip abductors", "Strong glutes", "Good ankle mobility", "Deep breathing"]
                ),
                ArticleQuizQuestion(
                    question: "Which factor affects stance width?",
                    correctAnswer: "Femur length",
                    options: ["Hand size", "Haircut", "Femur length", "Wrist mobility"]
                ),
                ArticleQuizQuestion(
                    question: "Which issue describes pelvis rounding at depth?",
                    correctAnswer: "Butt wink",
                    options: ["Lockout", "Butt wink", "Valgus collapse", "Liftoff"]
                )
            ]
        ),
        
        Article(
            id: UUID(),
            title: "Wearable Technology in Sports",
            subtitle: "How smart gear is revolutionizing training",
            content: """
Wearable technology is becoming a vital tool for athletes who want to make precise decisions based on real performance data.

Heart rate variability (HRV) helps gauge recovery and readiness. GPS trackers monitor speed, distance, and workload for runners and field athletes. EMG sensors offer insights into muscle recruitment patterns, highlighting weak points or compensation.

How Athletes Use Wearables:
• HRV to adjust training intensity  
• GPS to track progress and match demands  
• Sleep trackers to improve recovery habits  
• Weekly readiness scores for programming decisions  

Wearables don’t replace intuition — they enhance it with objective data that supports smarter, safer, and more effective training.
"""
            ,
            author: "Tech Review Team",
            publishDate: Date().addingTimeInterval(-86400 * 4),
            category: .equipment,
            readingTime: 11,
            difficulty: .intermediate,
            tags: ["technology", "wearables", "data", "monitoring"],
            quiz: [
                ArticleQuizQuestion(
                    question: "Which metric is used to track recovery status?",
                    correctAnswer: "HRV",
                    options: ["Blood pressure", "RHR", "VO2 max", "HRV"]
                ),
                ArticleQuizQuestion(
                    question: "Which device measures muscle activation?",
                    correctAnswer: "EMG sensors",
                    options: ["GPS watch", "EMG sensors", "Sleep tracker", "Pedometer"]
                ),
                ArticleQuizQuestion(
                    question: "Which trend review is recommended weekly?",
                    correctAnswer: "Readiness scores",
                    options: ["Calorie burn", "Daily steps", "Readiness scores", "Water intake"]
                )
            ]
        ),
        
        Article(
            id: UUID(),
            title: "Nutritional Periodization Strategies",
            subtitle: "Aligning diet with training cycles",
            content: """
Nutritional periodization tailors your diet to match different phases of your training year, ensuring optimal performance, recovery, and physique management.

Heavy training blocks require more carbohydrates for fuel. Lower intensity phases shift towards higher fats and stable protein intake. Competition phases emphasize strategic fueling and hydration protocols.

Weekly Macro Adjustments:
• High-carb days for heavy lifts or intervals  
• Moderate carbs for technical or skill sessions  
• Low-carb days on rest days  

Matching your nutrition with training load ensures you always perform at your best while staying lean and energized.
"""
            ,
            author: "Dr. Lisa Wang",
            publishDate: Date().addingTimeInterval(-86400 * 6),
            category: .nutrition,
            readingTime: 20,
            difficulty: .advanced,
            tags: ["nutrition", "periodization", "macros", "timing"],
            quiz: [
                ArticleQuizQuestion(
                    question: "Which phase uses a caloric surplus?",
                    correctAnswer: "Off-season",
                    options: ["Competition", "Transition", "Off-season", "Pre-season"]
                ),
                ArticleQuizQuestion(
                    question: "High-carb days should align with:",
                    correctAnswer: "Intense training",
                    options: ["Rest days", "Meditation", "Intense training", "Sleep tracking"]
                ),
                ArticleQuizQuestion(
                    question: "Which supplement is ideal pre-workout?",
                    correctAnswer: "Caffeine + beta-alanine",
                    options: ["Creatine only", "Vitamin C", "Caffeine + beta-alanine", "Fish oil"]
                )
            ]
        ),
        
        Article(
            id: UUID(),
            title: "The Science of Muscle Hypertrophy",
            subtitle: "Latest research on muscle growth mechanisms",
            content: """
Hypertrophy is driven by three core mechanisms: mechanical tension, metabolic stress, and muscle damage. Effective training balances these stimuli through smart program design.

Mechanical tension — created through heavy or controlled lifting — is the primary driver. Metabolic stress (the “burn”) boosts hormonal responses and muscle swelling. Controlled muscle damage promotes remodeling during recovery.

Hypertrophy Optimization:
• 10–20 working sets per muscle weekly  
• 2–3 sessions per muscle group per week  
• 60–90 second rest for metabolic focus  
• Progressive overload as the foundation  

The most successful athletes combine strength phases, hypertrophy blocks, and metabolic work into a structured growth cycle.
"""
            ,
            author: "Dr. Michael Thompson",
            publishDate: Date().addingTimeInterval(-86400 * 8),
            category: .science,
            readingTime: 17,
            isFeatured: true,
            difficulty: .expert,
            tags: ["hypertrophy", "science", "research", "muscle growth"],
            quiz: [
                ArticleQuizQuestion(
                    question: "Which mechanism is NOT a primary hypertrophy driver?",
                    correctAnswer: "Lactic acid buildup",
                    options: ["Mechanical tension", "Metabolic stress", "Lactic acid buildup", "Muscle damage"]
                ),
                ArticleQuizQuestion(
                    question: "Optimal volume per muscle per week?",
                    correctAnswer: "10–20 sets",
                    options: ["2–4 sets", "5–8 sets", "10–20 sets", "30+ sets"]
                ),
                ArticleQuizQuestion(
                    question: "Which technique increases metabolic stress?",
                    correctAnswer: "Drop sets",
                    options: ["Paused reps", "Drop sets", "Isometrics", "Jump training"]
                )
            ]
        )
    ]
}
