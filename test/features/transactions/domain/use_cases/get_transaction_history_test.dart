import 'package:btg_funds_manager/core/utils/result.dart';
import 'package:btg_funds_manager/features/transactions/domain/entities/transaction.dart';
import 'package:btg_funds_manager/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:btg_funds_manager/features/transactions/domain/use_cases/get_transaction_history.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late GetTransactionHistory useCase;
  late MockTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockTransactionRepository();
    useCase = GetTransactionHistory(repository: mockRepository);
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

  test('should get transaction history from the repository', () async {
    // arrange
    when(() => mockRepository.getTransactionHistory())
        .thenAnswer((_) async => Success(tTransactions));

    // act
    final result = await useCase();

    // assert
    expect(result, Success(tTransactions));
    verify(() => mockRepository.getTransactionHistory()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository fails', () async {
    // arrange
    const tFailure = Failure<List<Transaction>>('Error history');
    when(() => mockRepository.getTransactionHistory())
        .thenAnswer((_) async => tFailure);

    // act
    final result = await useCase();

    // assert
    expect(result, tFailure);
    verify(() => mockRepository.getTransactionHistory()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
