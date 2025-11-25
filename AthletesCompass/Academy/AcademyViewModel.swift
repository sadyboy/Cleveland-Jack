import Foundation
import Combine

@MainActor
final class AcademyViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var featuredArticles: [Article] = []
    @Published var filteredArticles: [Article] = []
    @Published var selectedCategory: ArticleCategory? = nil
    @Published var isLoading = false
    @Published var error: AppError?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadArticles()
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        $articles
            .combineLatest($selectedCategory)
            .map { articles, category in
                guard let category = category else { return articles }
                return articles.filter { $0.category == category }
            }
            .assign(to: &$filteredArticles) 
        
        $articles
            .map { $0.filter { $0.isFeatured } }
            .assign(to: &$featuredArticles)
    }
    
    func loadArticles() {
        isLoading = true
        error = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.articles = Article.mockData
            self.isLoading = false
        }
    }
    
    func markArticleAsRead(_ article: Article) {
        print("Article marked as read: \(article.title)")
    }
}

