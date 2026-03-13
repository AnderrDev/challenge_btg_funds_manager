import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/result.dart';
import '../../domain/use_cases/cancel_subscription.dart';
import '../../domain/use_cases/get_funds.dart';
import '../../domain/use_cases/subscribe_to_fund.dart';
import 'funds_event.dart';
import 'funds_state.dart';

/// BLoC for managing fund operations.
///
/// Receives [FundsEvent]s, invokes the appropriate use case,
/// and emits new [FundsState]s. Acts as the single source of truth
/// for the funds presentation layer.
class FundsBloc extends Bloc<FundsEvent, FundsState> {
  FundsBloc({
    required GetFunds getFunds,
    required SubscribeToFund subscribeToFund,
    required CancelSubscription cancelSubscription,
  })  : _getFunds = getFunds,
        _subscribeToFund = subscribeToFund,
        _cancelSubscription = cancelSubscription,
        super(const FundsInitial()) {
    on<LoadFunds>(_onLoadFunds);
    on<SubscribeToFundEvent>(_onSubscribeToFund);
    on<CancelFundSubscription>(_onCancelSubscription);
  }

  final GetFunds _getFunds;
  final SubscribeToFund _subscribeToFund;
  final CancelSubscription _cancelSubscription;

  double _currentBalance = 0;

  /// Handles [LoadFunds] event.
  Future<void> _onLoadFunds(
    LoadFunds event,
    Emitter<FundsState> emit,
  ) async {
    emit(const FundsLoading());

    final result = await _getFunds();

    switch (result) {
      case Success(data: final funds):
        _currentBalance = await _getFunds.repository.getBalance();
        emit(FundsLoaded(funds: funds, balance: _currentBalance));
      case Failure(message: final msg):
        emit(FundsError(message: msg));
    }
  }

  /// Handles [SubscribeToFundEvent] event.
  Future<void> _onSubscribeToFund(
    SubscribeToFundEvent event,
    Emitter<FundsState> emit,
  ) async {
    emit(const FundsLoading());

    final result = await _subscribeToFund(
      fundId: event.fundId,
      method: event.notificationMethod,
      currentBalance: _currentBalance,
      fundName: event.fundName,
      fundMinimumAmount: event.fundMinimumAmount,
    );

    switch (result) {
      case Success():
        // Reload all funds to get fresh state
        add(const LoadFunds());
      case Failure(message: final msg):
        emit(FundsError(message: msg));
        // Reload to restore previous state after error
        add(const LoadFunds());
    }
  }

  /// Handles [CancelFundSubscription] event.
  Future<void> _onCancelSubscription(
    CancelFundSubscription event,
    Emitter<FundsState> emit,
  ) async {
    emit(const FundsLoading());

    final result = await _cancelSubscription(
      fundId: event.fundId,
      currentBalance: _currentBalance,
      fundName: event.fundName,
      fundMinimumAmount: event.fundMinimumAmount,
    );

    switch (result) {
      case Success():
        add(const LoadFunds());
      case Failure(message: final msg):
        emit(FundsError(message: msg));
        add(const LoadFunds());
    }
  }
}
