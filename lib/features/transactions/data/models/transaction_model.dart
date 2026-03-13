import '../../domain/entities/transaction.dart';

/// Data model for [Transaction] with JSON serialization.
class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.fundId,
    required super.fundName,
    required super.type,
    required super.amount,
    required super.date,
    super.notificationMethod,
  });

  /// Creates a [TransactionModel] from a domain [Transaction].
  factory TransactionModel.fromEntity(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      fundId: transaction.fundId,
      fundName: transaction.fundName,
      type: transaction.type,
      amount: transaction.amount,
      date: transaction.date,
      notificationMethod: transaction.notificationMethod,
    );
  }

  /// Creates a [TransactionModel] from a JSON map.
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
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

  /// Converts this [TransactionModel] to a JSON map.
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
}
