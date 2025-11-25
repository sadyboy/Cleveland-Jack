import SwiftUI

struct AcademyView: View {
    @StateObject private var viewModel = AcademyViewModel()
    @State private var selectedArticle: Article?
    @State private var showingArticleDetail = false
    @State private var searchText = ""
    @State private var animateCards = false
    
    var filteredArticles: [Article] {
        if searchText.isEmpty {
            return viewModel.filteredArticles
        } else {
            return viewModel.articles.filter { article in
                article.title.localizedCaseInsensitiveContains(searchText) ||
                article.subtitle.localizedCaseInsensitiveContains(searchText) ||
                article.author.localizedCaseInsensitiveContains(searchText)
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
                        
                        // Category Filter
                        categoryFilterSection
                            .offset(y: animateCards ? 0 : 30)
                            .opacity(animateCards ? 1 : 0)
                        
                        // Featured Articles
                        if !viewModel.featuredArticles.isEmpty {
                            featuredSection
                                .offset(y: animateCards ? 0 : 20)
                                .opacity(animateCards ? 1 : 0)
                        }
                        
                        // All Articles
                        articlesGridSection
                            .offset(y: animateCards ? 0 : 20)
                            .opacity(animateCards ? 1 : 0)
                    }
                    .padding(.vertical)
                }
            }
            .navigationDestination(isPresented: $showingArticleDetail) {
                if let article = selectedArticle {
                    ArticleDetailView(article: article)
                }
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
                    Text("KNOWLEDGE ACADEMY")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("Elevate Your Game")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // Learning Stats
                VStack(spacing: 4) {
                    Text("\(viewModel.articles.count)")
                        .font(.system(size: 20, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("ARTICLES")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(12)
                .background(Color.white.opacity(0.05))
                .cornerRadius(12)
            }
            .padding(.horizontal, 24)
            
            Text("Expert insights to maximize your performance")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.6))
                .padding(.horizontal, 24)
        }
    }
    
    // MARK: - Search Section
    private var searchSection: some View {
        HStack {
            Text("🔎")
                .foregroundColor(.white.opacity(0.5))
                .font(.system(size: 16))
            
            TextField("Search articles...", text: $searchText)
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
        .padding(.horizontal, 24)
    }
    
    // MARK: - Category Filter
    private var categoryFilterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(ArticleCategory.allCases, id: \.self) { category in
                    CategoryChip(
                        category: category,
                        isSelected: viewModel.selectedCategory == category,
                        action: {
                            withAnimation(.spring()) {
                                if viewModel.selectedCategory == category {
                                    viewModel.selectedCategory = nil
                                } else {
                                    viewModel.selectedCategory = category
                                }
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 24)
        }
    }
    
    // MARK: - Featured Section
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("FEATURED INSIGHTS")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "sparkles")
                    .foregroundColor(.yellow)
                    .font(.title3)
            }
            .padding(.horizontal, 24)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(viewModel.featuredArticles) { article in
                        FeaturedArticleCard(article: article)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedArticle = article
                                showingArticleDetail = true
                            }
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
    
    // MARK: - Articles Grid
    private var articlesGridSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("ALL ARTICLES")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(filteredArticles.count) articles")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.horizontal, 24)
            
            LazyVStack(spacing: 16) {
                ForEach(filteredArticles) { article in
                    ArticleCard(article: article)
                        .onTapGesture {
                            selectedArticle = article
                            showingArticleDetail = true
                        }
                        .padding(.horizontal, 24)
                }
            }
        }
    }
}


// MARK: - Featured Article Card
struct FeaturedArticleCard: View {
    let article: Article
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header with category
            HStack {
                CategoryBadges(category: article.category)
                Spacer()
                
                Text("⭐️")
                    .foregroundColor(.yellow)
                    .font(.system(size: 12))
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            // Content
            VStack(alignment: .leading, spacing: 12) {
                Text(article.title)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(article.subtitle)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(2)
                
                // Meta information
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "clock")
                            .font(.system(size: 12))
                        Text("\(article.readingTime) min")
                            .font(.system(size: 12, weight: .medium))
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 6) {
                        Image(systemName: "person.circle")
                            .font(.system(size: 12))
                        Text(article.author)
                            .font(.system(size: 12, weight: .medium))
                            .lineLimit(1)
                    }
                }
                .foregroundColor(.white.opacity(0.5))
            }
            .padding(20)
        }
        .frame(width: 280)
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

// MARK: - Article Card
struct ArticleCard: View {
    let article: Article
    @State private var isPressed = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Category Icon
            ZStack {
                Circle()
                    .fill(article.category.color.opacity(0.2))
                    .frame(width: 44, height: 44)
                
                Image(systemName: article.category.icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(article.category.color)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(article.title)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text(article.subtitle)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    if article.isFeatured {
                        Image(systemName: "sparkles")
                            .foregroundColor(.yellow)
                            .font(.system(size: 12))
                    }
                }
                
                // Meta information
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "clock")
                            .font(.system(size: 12))
                        Text("\(article.readingTime) min read")
                            .font(.system(size: 12, weight: .medium))
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 6) {
                        Image(systemName: "person.circle")
                            .font(.system(size: 12))
                        Text(article.author)
                            .font(.system(size: 12, weight: .medium))
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    Text(article.publishDate, style: .relative)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                }
                .foregroundColor(.white.opacity(0.5))
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
struct CategoryBadges: View {
    let category: ArticleCategory
    
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

// MARK: - Article Detail View
struct ArticleDetailView: View {
    let article: Article
    @Environment(\.dismiss) private var dismiss
    @State private var animateContent = false
    @State private var showingQuiz = false
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            CategoryBadges(category: article.category)
                            Spacer()
                            if article.isFeatured {
                                Image(systemName: "sparkles")
                                    .foregroundColor(.yellow)
                                    .font(.title3)
                            }
                        }
                        
                        Text(article.title)
                            .font(.system(size: 32, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text(article.subtitle)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                            .lineSpacing(4)
                    }
                    .offset(y: animateContent ? 0 : 30)
                    .opacity(animateContent ? 1 : 0)
                    
                    // Meta information
                    HStack(spacing: 20) {
                        HStack(spacing: 8) {
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(.white.opacity(0.7))
                            Text(article.author)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        HStack(spacing: 8) {
                            Image(systemName: "clock")
                                .foregroundColor(.white.opacity(0.7))
                            Text("\(article.readingTime) min read")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        HStack(spacing: 8) {
                            Image(systemName: "calendar")
                                .foregroundColor(.white.opacity(0.7))
                            Text(article.publishDate, style: .relative)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    .offset(y: animateContent ? 0 : 20)
                    .opacity(animateContent ? 1 : 0)
                    
                    // Content
                    Text(article.content)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white.opacity(0.8))
                        .lineSpacing(6)
                        .offset(y: animateContent ? 0 : 20)
                        .opacity(animateContent ? 1 : 0)
                }
                .padding(24)
                Button(action: { showingQuiz = true }) {
                    Text("Take Quiz")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow)
                        .cornerRadius(12)
                }
                .padding(.top, 16)
            }
        
        }
        .sheet(isPresented: $showingQuiz) {
            ArticleQuizView(article: article)
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
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.1)) {
                animateContent = true
            }
        }
        
    }
}

struct ArticleQuizView: View {
    let article: Article
    
    @State private var currentIndex = 0
    @State private var selectedOption: String? = nil
    @State private var answers: [UUID: String] = [:]
    @State private var showResults = false
    @State private var animateChoice = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                QuizProgressHeader(
                    currentIndex: currentIndex,
                    total: article.quiz.count
                )
                
                Spacer()
                
                QuizQuestionCard(
                    question: article.quiz[currentIndex],
                    selectedOption: $selectedOption,
                    animateChoice: $animateChoice,
                    onSelect: { option in
                        handleSelection(option)
                    }
                )
                .padding(.horizontal)
                
                Spacer()
                
                QuizNextButton(
                    isLast: currentIndex == article.quiz.count - 1,
                    action: goNext
                )
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
        }
        .sheet(isPresented: $showResults) {
            QuizResultView(article: article, selectedAnswers: answers)
        }
    }
    
    private func handleSelection(_ option: String) {
        let q = article.quiz[currentIndex]
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            selectedOption = option
            answers[q.id] = option
            animateChoice.toggle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            goNext()
        }
    }
    
    private func goNext() {
        if currentIndex < article.quiz.count - 1 {
            selectedOption = nil
            currentIndex += 1
        } else {
            showResults = true
        }
    }
}
struct QuizProgressHeader: View {
    let currentIndex: Int
    let total: Int
    
    var body: some View {
        VStack {
            Text("Question \(currentIndex + 1) of \(total)")
                .font(.headline)
                .foregroundColor(.white.opacity(0.7))
            
            ProgressView(value: Double(currentIndex + 1),
                         total: Double(total))
            .tint(.white)
            .padding(.horizontal)
        }
    }
}
struct QuizQuestionCard: View {
    let question: ArticleQuizQuestion
    @Binding var selectedOption: String?
    @Binding var animateChoice: Bool
    
    let onSelect: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Text(question.question)
                .font(.title2.bold())
                .foregroundColor(.white)
            
            ForEach(question.options!, id: \.self) { option in
                QuizAnswerButton(
                    option: option,
                    isSelected: selectedOption == option,
                    animate: animateChoice
                ) {
                    onSelect(option)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(20)
    }
}
struct QuizAnswerButton: View {
    let option: String
    let isSelected: Bool
    let animate: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(isSelected ? .yellow : .white)
                    .font(.system(size: 22))
                
                Text(option)
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .medium))
                
                Spacer()
            }
            .padding()
            .background(
                isSelected
                ? Color.white.opacity(0.15)
                : Color.white.opacity(0.05)
            )
            .cornerRadius(12)
            .scaleEffect(isSelected && animate ? 0.96 : 1.0)
        }
    }
}
struct QuizNextButton: View {
    let isLast: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(isLast ? "Finish Quiz" : "Next")
                .font(.headline.bold())
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
        }
    }
}


 struct QuizResultView: View {
    let article: Article
    let selectedAnswers: [UUID: String]
    @Environment(\.dismiss) private var dismiss
    
    @State private var animate = false
    
    var score: Int {
        article.quiz.filter { q in
            selectedAnswers[q.id] == q.correctAnswer
        }.count
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    
                    // Score
                    VStack(spacing: 10) {
                        Text("Your Score")
                            .font(.title.bold())
                            .foregroundColor(.white)
                        
                        Text("\(score) / \(article.quiz.count)")
                            .font(.system(size: 48, weight: .black))
                            .foregroundColor(score >= article.quiz.count / 2 ? .green : .red)
                            .scaleEffect(animate ? 1.1 : 1)
                    }
                    .padding(.top, 20)
                    .onAppear {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                            animate = true
                        }
                    }
                    
                    // Answer Review
                    VStack(spacing: 20) {
                        ForEach(article.quiz) { q in
                            VStack(alignment: .leading, spacing: 8) {
                                
                                HStack {
                                    Text(q.question)
                                        .foregroundColor(.white)
                                        .font(.headline)
                                    Spacer()
                                    
                                    let isCorrect = selectedAnswers[q.id] == q.correctAnswer
                                    
                                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .foregroundColor(isCorrect ? .green : .red)
                                        .font(.title2)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Your answer: \(selectedAnswers[q.id] ?? "-")")
                                        .foregroundColor(.white.opacity(0.7))
                                    
                                    if selectedAnswers[q.id] != q.correctAnswer {
                                        Text("Correct: \(q.correctAnswer)")
                                            .foregroundColor(.yellow)
                                    }
                                }
                                .font(.subheadline)
                            }
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Continue button
                    Button("Continue") {
                        dismiss()
                    }
                    .font(.headline.bold())
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    Spacer(minLength: 40)
                }
            }
        }
    }
}

