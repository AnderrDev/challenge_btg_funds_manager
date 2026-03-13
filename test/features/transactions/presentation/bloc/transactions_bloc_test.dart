import 'package:bloc_test/bloc_test.dart';
import 'package:btg_funds_manager/core/utils/result.dart';
import 'package:btg_funds_manager/features/transactions/domain/entities/transaction.dart';
import 'package:btg_funds_manager/features/transactions/domain/use_cases/get_transaction_history.dart';
import 'package:btg_funds_manager/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:btg_funds_manager/features/transactions/presentation/bloc/transactions_event.dart';
import 'package:btg_funds_manager/features/transactions/presentation/bloc/transactions_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetTransactionHistory extends Mock implements GetTransactionHistory {}

void main() {
  late TransactionsBloc bloc;
  late MockGetTransactionHistory mockGetTransactionHistory;

  setUp(() {
    mockGetTransactionHistory = MockGetTransactionHistory();
    bloc = TransactionsBloc(getTransactionHistory: mockGetTransactionHistory);
  });

  final tTransactions = [
    Transaction(
      id: '1',
      fundId: 1,
      fundName: 'Test Fund',
      type: TransactionType.subscription,
      amount: 100000,
      date: DateTime.now(),
    ),
  ];

  group('TransactionsBloc', () {
    test('initial state should be TransactionsInitial', () {
      expect(bloc.state, const TransactionsInitial());
    });

    blocTest<TransactionsBloc, TransactionsState>(
      'should emit [TransactionsLoading, TransactionsLoaded] when LoadTransactions is added',
      build: () {
        when(() => mockGetTransactionHistory())
            .thenAnswer((_) async => Success(tTransactions));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadTransactions()),
      expect: () => [
        const TransactionsLoading(),
        TransactionsLoaded(
          transactions: tTransactions,
          allTransactions: tTransactions,
        ),
      ],
      verify: (_) {
        verify(() => mockGetTransactionHistory()).called(1);
      },
    );

    blocTest<TransactionsBloc, TransactionsState>(
      'should emit [TransactionsLoading, TransactionsError] when loading fails',
      build: () {
        when(() => mockGetTransactionHistory())
            .thenAnswer((_) async => const Failure('Error loading history'));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadTransactions()),
      expect: () => [
        const TransactionsLoading(),
        const TransactionsError(message: 'Error loading history'),
      ],
    );
  });
}
