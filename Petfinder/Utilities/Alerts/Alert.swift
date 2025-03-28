import SwiftUI

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
            title: Text("Server Error"),
            message: Text("The data received from the server was invalid. Please contact support."),
            dismissButton: okButton
        )

        static let invalidResponse = AlertItem(
            title: Text("Server Error"),
            message: Text("Invalid response from the server. Please try again later or contact support."),
            dismissButton: okButton
        )

        static let invalidURL = AlertItem(
            title: Text("Server Error"),
            message: Text("There was an issue connecting to the server. If this persists, please contact support."),
            dismissButton: okButton
        )

        static let unableToComplete = AlertItem(
            title: Text("Server Error"),
            message: Text("Unable to complete your request at this time. Please check your internet connection."),
            dismissButton: okButton
        )

        static let invalidToken = AlertItem(
            title: Text("Authentication Error"),
            message: Text("Your session has expired or the token is invalid."),
            dismissButton: okButton
        )
    }
}
