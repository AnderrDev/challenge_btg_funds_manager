import 'package:equatable/equatable.dart';

/// Events for the Transactions BLoC.
sealed class TransactionsEvent extends Equatable {
  const TransactionsEvent();

  @override
  List<Object?> get props => [];
}

/// Triggers loading of the transaction history.
final class LoadTransactions extends TransactionsEvent {
  const LoadTransactions();
}
