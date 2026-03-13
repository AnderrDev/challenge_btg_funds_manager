import 'package:equatable/equatable.dart';
import '../../domain/entities/transaction.dart';

/// States for the Transactions BLoC.
sealed class TransactionsState extends Equatable {
  const TransactionsState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
final class TransactionsInitial extends TransactionsState {
  const TransactionsInitial();
}

/// Data is being loaded.
final class TransactionsLoading extends TransactionsState {
  const TransactionsLoading();
}

/// Transactions loaded successfully.
final class TransactionsLoaded extends TransactionsState {
  const TransactionsLoaded({
    required this.transactions,
    required this.allTransactions,
    this.query,
    this.type,
  });

  final List<Transaction> transactions;
  final List<Transaction> allTransactions;
  final String? query;
  final TransactionType? type;

  @override
  List<Object?> get props => [transactions, allTransactions, query, type];

  TransactionsLoaded copyWith({
    List<Transaction>? transactions,
    List<Transaction>? allTransactions,
    String? query,
    TransactionType? type,
  }) {
    return TransactionsLoaded(
      transactions: transactions ?? this.transactions,
      allTransactions: allTransactions ?? this.allTransactions,
      query: query ?? this.query,
      type: type ?? this.type,
    );
  }
}

/// An error occurred.
final class TransactionsError extends TransactionsState {
  const TransactionsError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
