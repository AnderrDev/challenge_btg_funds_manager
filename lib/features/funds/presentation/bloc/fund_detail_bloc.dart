import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/result.dart';
import '../../domain/use_cases/get_fund_detail.dart';
import 'fund_detail_event.dart';
import 'fund_detail_state.dart';

/// BLoC for managing a single fund's detail state.
class FundDetailBloc extends Bloc<FundDetailEvent, FundDetailState> {
  FundDetailBloc({
    required GetFundDetail getFundDetail,
  })  : _getFundDetail = getFundDetail,
        super(const FundDetailInitial()) {
    on<LoadFundDetail>(_onLoadFundDetail);
  }

  final GetFundDetail _getFundDetail;

  Future<void> _onLoadFundDetail(
    LoadFundDetail event,
    Emitter<FundDetailState> emit,
  ) async {
    emit(const FundDetailLoading());

    final result = await _getFundDetail(event.fundId);

    switch (result) {
      case Success(data: final fund):
        emit(FundDetailLoaded(fund: fund));
      case Failure(message: final msg):
        emit(FundDetailError(message: msg));
    }
  }
}
