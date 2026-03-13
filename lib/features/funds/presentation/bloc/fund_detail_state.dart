import 'package:equatable/equatable.dart';
import '../../domain/entities/fund.dart';

abstract class FundDetailState extends Equatable {
  const FundDetailState();

  @override
  List<Object?> get props => [];
}

class FundDetailInitial extends FundDetailState {
  const FundDetailInitial();
}

class FundDetailLoading extends FundDetailState {
  const FundDetailLoading();
}

class FundDetailLoaded extends FundDetailState {
  const FundDetailLoaded({required this.fund});
  final Fund fund;

  @override
  List<Object?> get props => [fund];
}

class FundDetailError extends FundDetailState {
  const FundDetailError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
