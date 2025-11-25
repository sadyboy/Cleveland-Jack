import Foundation

enum AppError: Error, LocalizedError {
    case networkError(String)
    case healthKitError(String)
    case subscriptionError(String)
    case unknownError
    
    var errorDescription: String? {
    switch self {
    case .networkError(let message):
    return "Network error: \(message)"
    case .healthKitError(let message):
    return "HealthKit error: \(message)"
    case .subscriptionError(let message):
    return "Subscription error: \(message)"
    case .unknownError:
    return "Unknown error"
    }
    }
}
