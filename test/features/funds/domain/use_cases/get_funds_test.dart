import 'package:btg_funds_manager/core/utils/result.dart';
import 'package:btg_funds_manager/features/funds/domain/entities/fund.dart';
import 'package:btg_funds_manager/features/funds/domain/repositories/fund_repository.dart';
import 'package:btg_funds_manager/features/funds/domain/use_cases/get_funds.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFundRepository extends Mock implements FundRepository {}

void main() {
  late GetFunds useCase;
  late MockFundRepository mockRepository;

  setUp(() {
    mockRepository = MockFundRepository();
    useCase = GetFunds(repository: mockRepository);
  });

  const tFunds = [
    Fund(
      id: 1,
      name: 'Test Fund',
      minimumAmount: 100000,
      category: FundCategory.fic,
    ),
  ];

  test('should get funds from the repository', () async {
    // arrange
    when(() => mockRepository.getFunds())
        .thenAnswer((_) async => const Success(tFunds));

    // act
    final result = await useCase();

    // assert
    expect(result, const Success(tFunds));
    verify(() => mockRepository.getFunds()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository fails', () async {
    // arrange
    const tFailure = Failure<List<Fund>>('Error');
    when(() => mockRepository.getFunds()).thenAnswer((_) async => tFailure);

    // act
    final result = await useCase();

    // assert
    expect(result, tFailure);
    verify(() => mockRepository.getFunds()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
