import 'package:equatable/equatable.dart';
import '../../domain/entities/transaction.dart';

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

/// Triggers filtering of the loaded transactions.
final class FilterTransactions extends TransactionsEvent {
  const FilterTransactions({
    this.query,
    this.type,
  });

  final String? query;
  final TransactionType? type;

  @override
  List<Object?> get props => [query, type];
}
