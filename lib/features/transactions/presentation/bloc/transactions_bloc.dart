import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/use_cases/get_transaction_history.dart';
import 'transactions_event.dart';
import 'transactions_state.dart';

/// BLoC for managing transaction history.
class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  TransactionsBloc({
    required GetTransactionHistory getTransactionHistory,
  })  : _getTransactionHistory = getTransactionHistory,
        super(const TransactionsInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<FilterTransactions>(_onFilterTransactions);
  }

  final GetTransactionHistory _getTransactionHistory;

  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<TransactionsState> emit,
  ) async {
    emit(const TransactionsLoading());

    final result = await _getTransactionHistory();

    switch (result) {
      case Success(data: final transactions):
        emit(TransactionsLoaded(
          transactions: transactions,
          allTransactions: transactions,
        ));
      case Failure(message: final msg):
        emit(TransactionsError(message: msg));
    }
  }

  void _onFilterTransactions(
    FilterTransactions event,
    Emitter<TransactionsState> emit,
  ) {
    if (state is! TransactionsLoaded) return;

    final currentState = state as TransactionsLoaded;
    final query = event.query ?? currentState.query;
    final type = event.type == currentState.type ? null : (event.type ?? currentState.type);

    List<Transaction> filtered = currentState.allTransactions;

    if (query != null && query.isNotEmpty) {
      filtered = filtered
          .where((t) => t.fundName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    if (type != null) {
      filtered = filtered.where((t) => t.type == type).toList();
    }

    emit(currentState.copyWith(
      transactions: filtered,
      query: query,
      type: type,
    ));
  }
}
