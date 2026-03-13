import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/result.dart';
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
        emit(TransactionsLoaded(transactions: transactions));
      case Failure(message: final msg):
        emit(TransactionsError(message: msg));
    }
  }
}
