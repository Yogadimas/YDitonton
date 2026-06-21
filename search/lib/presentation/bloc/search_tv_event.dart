import 'package:equatable/equatable.dart';

abstract class SearchTvEvent extends Equatable {
  const SearchTvEvent();

  @override
  List<Object> get props => [];
}

class OnQueryChangedTv extends SearchTvEvent {
  final String query;

  const OnQueryChangedTv(this.query);

  @override
  List<Object> get props => [query];
}
