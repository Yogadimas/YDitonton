part of 'tv_detail_bloc.dart';

abstract class TVDetailEvent extends Equatable {
  const TVDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchTVDetail extends TVDetailEvent {
  final int id;

  const FetchTVDetail(this.id);

  @override
  List<Object> get props => [id];
}
