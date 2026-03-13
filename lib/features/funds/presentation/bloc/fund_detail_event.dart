import 'package:equatable/equatable.dart';

abstract class FundDetailEvent extends Equatable {
  const FundDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadFundDetail extends FundDetailEvent {
  const LoadFundDetail(this.fundId);
  final int fundId;

  @override
  List<Object?> get props => [fundId];
}
