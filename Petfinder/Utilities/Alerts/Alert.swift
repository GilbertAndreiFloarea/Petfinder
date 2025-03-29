import SwiftUI

private enum AlertText: String {
    // Titles
    case serverErrorTitle = "Server Error"
    case authErrorTitle = "Authentication Error"

    // Messages
    case invalidData = "The data received from the server was invalid. Please contact support."
    case invalidResponse = "Invalid response from the server. Please try again later or contact support."
    case invalidURL = "There was an issue connecting to the server. If this persists, please contact support."
    case unableToComplete = "Unable to complete your request at this time. Please check your internet connection."
    case invalidToken = "Your session has expired or the token is invalid."
}

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext {
    
    private static let okButton = Alert.Button.default(Text("OK"))
    
    // MARK: - Network Alerts
    struct Network {
        static let invalidData = AlertItem(
            title: Text(AlertText.serverErrorTitle.rawValue),
            message: Text(AlertText.invalidData.rawValue),
            dismissButton: okButton
        )

        static let invalidResponse = AlertItem(
            title: Text(AlertText.serverErrorTitle.rawValue),
            message: Text(AlertText.invalidResponse.rawValue),
            dismissButton: okButton
        )

        static let invalidURL = AlertItem(
            title: Text(AlertText.serverErrorTitle.rawValue),
            message: Text(AlertText.invalidURL.rawValue),
            dismissButton: okButton
        )

        static let unableToComplete = AlertItem(
            title: Text(AlertText.serverErrorTitle.rawValue),
            message: Text(AlertText.unableToComplete.rawValue),
            dismissButton: okButton
        )

        static let invalidToken = AlertItem(
            title: Text(AlertText.authErrorTitle.rawValue),
            message: Text(AlertText.invalidToken.rawValue),
            dismissButton: okButton
        )
    }
}
