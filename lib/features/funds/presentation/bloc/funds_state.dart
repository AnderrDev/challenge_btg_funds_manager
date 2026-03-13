import 'package:equatable/equatable.dart';
import '../../domain/entities/fund.dart';

/// States for the Funds BLoC.
///
/// Sealed class hierarchy ensures exhaustive handling in BlocBuilder.
sealed class FundsState extends Equatable {
  const FundsState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any data is loaded.
final class FundsInitial extends FundsState {
  const FundsInitial();
}

/// Data is being loaded.
final class FundsLoading extends FundsState {
  const FundsLoading();
}

/// Funds loaded successfully.
final class FundsLoaded extends FundsState {
  const FundsLoaded({
    required this.funds,
    required this.balance,
    this.successMessage,
  });

  final List<Fund> funds;
  final double balance;
  final String? successMessage;

  @override
  List<Object?> get props => [funds, balance, successMessage];
}

/// An error occurred.
final class FundsError extends FundsState {
  const FundsError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
