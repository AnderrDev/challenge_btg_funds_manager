/// Application-wide constants.
///
/// Centralizes magic values used across the app to ensure
/// consistency and ease of modification.
abstract final class AppConstants {
  /// Base URL for the JSON Server API.
  static const String baseUrl = 'http://localhost:3000';

  /// Initial user balance in COP.
  static const double initialBalance = 500000;

  /// Notification methods available for fund subscriptions.
  static const List<String> notificationMethods = ['Email', 'SMS'];
}
