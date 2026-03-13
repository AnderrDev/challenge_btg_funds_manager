import 'package:equatable/equatable.dart';

/// Transaction type for fund operations.
enum TransactionType { subscription, cancellation }

/// Notification method for fund subscriptions.
enum NotificationMethod { email, sms }

/// Represents a fund transaction record.
///
/// Immutable value object recording a subscription or cancellation event.
class Transaction extends Equatable {
  const Transaction({
    required this.id,
    required this.fundId,
    required this.fundName,
    required this.type,
    required this.amount,
    required this.date,
    this.notificationMethod,
  });

  final String id;
  final int fundId;
  final String fundName;
  final TransactionType type;
  final double amount;
  final DateTime date;
  final NotificationMethod? notificationMethod;

  @override
  List<Object?> get props => [
        id,
        fundId,
        fundName,
        type,
        amount,
        date,
        notificationMethod,
      ];
}
