part of 'tv_detail_bloc.dart';

abstract class TVDetailState extends Equatable {
  const TVDetailState();

  @override
  List<Object> get props => [];
}

class TVDetailEmpty extends TVDetailState {}

class TVDetailLoading extends TVDetailState {}

class TVDetailError extends TVDetailState {
  final String message;

  const TVDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class TVDetailHasData extends TVDetailState {
  final TVDetail result;

  const TVDetailHasData(this.result);

  @override
  List<Object> get props => [result];
}
