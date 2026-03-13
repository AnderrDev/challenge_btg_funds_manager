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

  /// Creates a [Transaction] from a JSON map (API response).
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'].toString(),
      fundId: json['fundId'] as int,
      fundName: json['fundName'] as String,
      type: json['type'] == 'subscription'
          ? TransactionType.subscription
          : TransactionType.cancellation,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      notificationMethod: json['notificationMethod'] != null
          ? (json['notificationMethod'] == 'email'
              ? NotificationMethod.email
              : NotificationMethod.sms)
          : null,
    );
  }

  /// Converts this [Transaction] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fundId': fundId,
      'fundName': fundName,
      'type': type == TransactionType.subscription
          ? 'subscription'
          : 'cancellation',
      'amount': amount,
      'date': date.toIso8601String(),
      'notificationMethod': notificationMethod != null
          ? (notificationMethod == NotificationMethod.email ? 'email' : 'sms')
          : null,
    };
  }

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
