import ActivityKit
import Foundation

/// A reusable, UI-independent ActivityKit service.
///
/// The app must include an ActivityConfiguration in its Widget Extension and set
/// NSSupportsLiveActivities to YES in the app's Info.plist.
@available(iOS 17.0, *)
public struct LiveActivityService: LiveActivityServiceProtocol {
    public init() {}

    public var areActivitiesEnabled: Bool {
        ActivityAuthorizationInfo().areActivitiesEnabled
    }

    @discardableResult
    public func start<Attributes: ActivityAttributes>(
        attributes: Attributes,
        state: Attributes.ContentState,
        staleDate: Date? = nil
    ) throws -> String {
        guard areActivitiesEnabled else {
            throw LiveActivityError.activitiesDisabled
        }

        let content = ActivityContent(state: state, staleDate: staleDate)
        let activity = try Activity<Attributes>.request(
            attributes: attributes,
            content: content,
            pushType: nil
        )
        return activity.id
    }

    public func update<Attributes: ActivityAttributes>(
        id: String,
        as type: Attributes.Type,
        state: Attributes.ContentState,
        staleDate: Date? = nil
    ) async throws {
        guard let activity = Activity<Attributes>.activities.first(where: { $0.id == id }) else {
            throw LiveActivityError.activityNotFound(id)
        }
        await activity.update(ActivityContent(state: state, staleDate: staleDate))
    }

    public func end<Attributes: ActivityAttributes>(
        id: String,
        as type: Attributes.Type,
        finalState: Attributes.ContentState? = nil,
        dismissalPolicy: ActivityUIDismissalPolicy = .default
    ) async throws {
        guard let activity = Activity<Attributes>.activities.first(where: { $0.id == id }) else {
            throw LiveActivityError.activityNotFound(id)
        }

        let content = finalState.map { ActivityContent(state: $0, staleDate: nil) }
        await activity.end(content, dismissalPolicy: dismissalPolicy)
    }

    public func activeIDs<Attributes: ActivityAttributes>(
        for type: Attributes.Type
    ) -> [String] {
        Activity<Attributes>.activities.map(\.id)
    }
}
