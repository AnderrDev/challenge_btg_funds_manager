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
  const TransactionsLoaded({required this.transactions});

  final List<Transaction> transactions;

  @override
  List<Object?> get props => [transactions];
}

/// An error occurred.
final class TransactionsError extends TransactionsState {
  const TransactionsError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
