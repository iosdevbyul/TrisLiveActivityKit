import ActivityKit
import Foundation

/// ActivityKit operations shared by any app-specific ActivityAttributes type.
///
/// The host application owns its Widget Extension and its ActivityAttributes model.
@available(iOS 17.0, *)
public protocol LiveActivityServiceProtocol {
    var areActivitiesEnabled: Bool { get }

    @discardableResult
    func start<Attributes: ActivityAttributes>(
        attributes: Attributes,
        state: Attributes.ContentState,
        staleDate: Date?
    ) throws -> String

    func update<Attributes: ActivityAttributes>(
        id: String,
        as type: Attributes.Type,
        state: Attributes.ContentState,
        staleDate: Date?
    ) async throws

    func end<Attributes: ActivityAttributes>(
        id: String,
        as type: Attributes.Type,
        finalState: Attributes.ContentState?,
        dismissalPolicy: ActivityUIDismissalPolicy
    ) async throws

    func activeIDs<Attributes: ActivityAttributes>(for type: Attributes.Type) -> [String]
}
