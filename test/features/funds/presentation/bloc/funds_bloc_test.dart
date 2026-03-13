import 'package:bloc_test/bloc_test.dart';
import 'package:btg_funds_manager/core/utils/result.dart';
import 'package:btg_funds_manager/features/funds/domain/entities/fund.dart';
import 'package:btg_funds_manager/features/funds/domain/repositories/fund_repository.dart';
import 'package:btg_funds_manager/features/funds/domain/use_cases/cancel_subscription.dart';
import 'package:btg_funds_manager/features/funds/domain/use_cases/get_funds.dart';
import 'package:btg_funds_manager/features/funds/domain/use_cases/subscribe_to_fund.dart';
import 'package:btg_funds_manager/features/funds/presentation/bloc/funds_bloc.dart';
import 'package:btg_funds_manager/features/funds/presentation/bloc/funds_event.dart';
import 'package:btg_funds_manager/features/funds/presentation/bloc/funds_state.dart';
import 'package:btg_funds_manager/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:btg_funds_manager/features/transactions/presentation/bloc/transactions_event.dart';
import 'package:btg_funds_manager/features/transactions/presentation/bloc/transactions_state.dart';
import 'package:btg_funds_manager/features/transactions/domain/entities/transaction.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetFunds extends Mock implements GetFunds {}

class MockSubscribeToFund extends Mock implements SubscribeToFund {}

class MockCancelSubscription extends Mock implements CancelSubscription {}

class MockTransactionsBloc extends MockBloc<TransactionsEvent, TransactionsState>
    implements TransactionsBloc {}

class MockFundRepository extends Mock implements FundRepository {}

void main() {
  late FundsBloc bloc;
  late MockGetFunds mockGetFunds;
  late MockSubscribeToFund mockSubscribeToFund;
  late MockCancelSubscription mockCancelSubscription;
  late MockTransactionsBloc mockTransactionsBloc;
  late MockFundRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(NotificationMethod.email);
    registerFallbackValue(const LoadTransactions());
  });

  setUp(() {
    mockGetFunds = MockGetFunds();
    mockSubscribeToFund = MockSubscribeToFund();
    mockCancelSubscription = MockCancelSubscription();
    mockTransactionsBloc = MockTransactionsBloc();
    mockRepository = MockFundRepository();

    when(() => mockGetFunds.repository).thenReturn(mockRepository);
    // Add default behavior for transactions bloc to avoid errors
    when(() => mockTransactionsBloc.add(any())).thenReturn(null);
    when(() => mockTransactionsBloc.state).thenReturn(const TransactionsInitial());
    when(() => mockTransactionsBloc.stream).thenAnswer((_) => const Stream.empty());

    bloc = FundsBloc(
      getFunds: mockGetFunds,
      subscribeToFund: mockSubscribeToFund,
      cancelSubscription: mockCancelSubscription,
      transactionsBloc: mockTransactionsBloc,
    );
  });

  const tFunds = [
    Fund(
      id: 1,
      name: 'Test Fund',
      minimumAmount: 100000,
      category: FundCategory.fic,
    ),
  ];

  const tBalance = 500000.0;

  group('FundsBloc', () {
    test('initial state should be FundsInitial', () {
      expect(bloc.state, const FundsInitial());
    });

    blocTest<FundsBloc, FundsState>(
      'should emit [FundsLoading, FundsLoaded] when LoadFunds is added',
      build: () {
        when(() => mockGetFunds()).thenAnswer((_) async => const Success(tFunds));
        when(() => mockRepository.getBalance()).thenAnswer((_) async => tBalance);
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadFunds()),
      expect: () => [
        const FundsLoading(),
        FundsLoaded(funds: tFunds, balance: tBalance),
      ],
      verify: (_) {
        verify(() => mockGetFunds()).called(1);
        verify(() => mockRepository.getBalance()).called(1);
      },
    );

    blocTest<FundsBloc, FundsState>(
      'should emit [FundsLoading, FundsError] when LoadFunds fails',
      build: () {
        when(() => mockGetFunds())
            .thenAnswer((_) async => const Failure('Error loading funds'));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadFunds()),
      expect: () => [
        const FundsLoading(),
        const FundsError(message: 'Error loading funds'),
      ],
    );

    blocTest<FundsBloc, FundsState>(
      'should emit [FundsLoading, FundsLoading, FundsLoaded] when SubscribeToFundEvent is successful',
      build: () {
        when(() => mockSubscribeToFund(
              fundId: any(named: 'fundId'),
              method: any(named: 'method'),
              currentBalance: any(named: 'currentBalance'),
              fundName: any(named: 'fundName'),
              fundMinimumAmount: any(named: 'fundMinimumAmount'),
            )).thenAnswer((_) async => Success(tFunds[0]));

        when(() => mockGetFunds()).thenAnswer((_) async => const Success(tFunds));
        when(() => mockRepository.getBalance()).thenAnswer((_) async => tBalance);

        return bloc;
      },
      act: (bloc) => bloc.add(const SubscribeToFundEvent(
        fundId: 1,
        fundName: 'Test Fund',
        fundMinimumAmount: 100000,
        notificationMethod: NotificationMethod.email,
      )),
      expect: () => [
        const FundsLoading(),
        FundsLoaded(funds: tFunds, balance: tBalance),
      ],
      verify: (_) {
        verify(() => mockSubscribeToFund(
              fundId: 1,
              method: NotificationMethod.email,
              currentBalance: 0,
              fundName: 'Test Fund',
              fundMinimumAmount: 100000,
            )).called(1);
        verify(() => mockTransactionsBloc.add(const LoadTransactions())).called(1);
      },
    );

    blocTest<FundsBloc, FundsState>(
      'should emit [FundsLoading, FundsError, FundsLoading, FundsLoaded] when subscription fails',
      build: () {
        when(() => mockSubscribeToFund(
              fundId: any(named: 'fundId'),
              method: any(named: 'method'),
              currentBalance: any(named: 'currentBalance'),
              fundName: any(named: 'fundName'),
              fundMinimumAmount: any(named: 'fundMinimumAmount'),
            )).thenAnswer((_) async => const Failure('Insufficient balance'));

        when(() => mockGetFunds()).thenAnswer((_) async => const Success(tFunds));
        when(() => mockRepository.getBalance()).thenAnswer((_) async => tBalance);

        return bloc;
      },
      act: (bloc) => bloc.add(const SubscribeToFundEvent(
        fundId: 1,
        fundName: 'Test Fund',
        fundMinimumAmount: 100000,
        notificationMethod: NotificationMethod.email,
      )),
      expect: () => [
        const FundsLoading(),
        const FundsError(message: 'Insufficient balance'),
        const FundsLoading(),
        FundsLoaded(funds: tFunds, balance: tBalance),
      ],
    );
  });
}
