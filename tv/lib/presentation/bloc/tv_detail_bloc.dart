import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';

part 'tv_detail_event.dart';
part 'tv_detail_state.dart';

class TVDetailBloc extends Bloc<TVDetailEvent, TVDetailState> {
  final GetTVDetail _usecase;

  TVDetailBloc(this._usecase) : super(TVDetailEmpty()) {
    on<FetchTVDetail>((event, emit) async {
      emit(TVDetailLoading());
      final result = await _usecase.execute(event.id);
      result.fold(
        (failure) => emit(TVDetailError(failure.message)),
        (data) => emit(TVDetailHasData(data)),
      );
    });
  }
}
