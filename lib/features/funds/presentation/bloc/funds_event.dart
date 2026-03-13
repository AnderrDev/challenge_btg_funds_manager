import 'package:equatable/equatable.dart';
import '../../../transactions/domain/entities/transaction.dart';

/// Events for the Funds BLoC.
///
/// All events extend [Equatable] for value-based comparison,
/// enabling proper BLoC testing and deduplication.
sealed class FundsEvent extends Equatable {
  const FundsEvent();

  @override
  List<Object?> get props => [];
}

/// Triggers loading of all available funds.
final class LoadFunds extends FundsEvent {
  const LoadFunds();
}

/// Triggers subscription to a specific fund.
final class SubscribeToFundEvent extends FundsEvent {
  const SubscribeToFundEvent({
    required this.fundId,
    required this.fundName,
    required this.fundMinimumAmount,
    required this.notificationMethod,
  });

  final int fundId;
  final String fundName;
  final double fundMinimumAmount;
  final NotificationMethod notificationMethod;

  @override
  List<Object?> get props => [fundId, fundName, fundMinimumAmount, notificationMethod];
}

/// Triggers cancellation of a fund subscription.
final class CancelFundSubscription extends FundsEvent {
  const CancelFundSubscription({
    required this.fundId,
    required this.fundName,
    required this.fundMinimumAmount,
  });

  final int fundId;
  final String fundName;
  final double fundMinimumAmount;

  @override
  List<Object?> get props => [fundId, fundName, fundMinimumAmount];
}
