import '../../domain/entities/transaction.dart';

/// Local mock data source for transactions.
///
/// Maintains an in-memory list of transactions, simulating persistence.
class TransactionLocalDataSource {
  final List<Transaction> _transactions = [];

  /// Returns all transactions, ordered by date descending.
  Future<List<Transaction>> getTransactionHistory() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final sorted = List<Transaction>.from(_transactions)
      ..sort((a, b) => b.date.compareTo(a.date));
    return List.unmodifiable(sorted);
  }

  /// Records a new transaction.
  Future<void> addTransaction(Transaction transaction) async {
    _transactions.add(transaction);
  }
}
