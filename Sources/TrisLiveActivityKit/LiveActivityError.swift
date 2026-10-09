import Foundation

public enum LiveActivityError: Error, Equatable, LocalizedError {
    case activitiesDisabled
    case activityNotFound(String)

    public var errorDescription: String? {
        switch self {
        case .activitiesDisabled:
            return "Live Activities are disabled for this app or device."
        case .activityNotFound(let id):
            return "Live Activity not found: \(id)"
        }
    }
}
