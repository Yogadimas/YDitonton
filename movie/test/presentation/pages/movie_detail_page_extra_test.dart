import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/presentation/bloc/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_recommendations_bloc.dart';
import 'package:movie/presentation/bloc/movie_watchlist_bloc.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class MockMovieRecommendationsBloc
    extends MockBloc<MovieRecommendationsEvent, MovieRecommendationsState>
    implements MovieRecommendationsBloc {}

class MockMovieWatchlistBloc
    extends MockBloc<MovieWatchlistEvent, MovieWatchlistState>
    implements MovieWatchlistBloc {}

class FakeMovieDetailEvent extends Fake implements MovieDetailEvent {}

class FakeMovieDetailState extends Fake implements MovieDetailState {}

class FakeMovieRecommendationsEvent extends Fake
    implements MovieRecommendationsEvent {}

class FakeMovieRecommendationsState extends Fake
    implements MovieRecommendationsState {}

class FakeMovieWatchlistEvent extends Fake implements MovieWatchlistEvent {}

class FakeMovieWatchlistState extends Fake implements MovieWatchlistState {}

void main() {
  late MockMovieDetailBloc mockMovieDetailBloc;
  late MockMovieRecommendationsBloc mockMovieRecommendationsBloc;
  late MockMovieWatchlistBloc mockMovieWatchlistBloc;

  setUpAll(() {
    registerFallbackValue(FakeMovieDetailEvent());
    registerFallbackValue(FakeMovieDetailState());
    registerFallbackValue(FakeMovieRecommendationsEvent());
    registerFallbackValue(FakeMovieRecommendationsState());
    registerFallbackValue(FakeMovieWatchlistEvent());
    registerFallbackValue(FakeMovieWatchlistState());
  });

  setUp(() {
    mockMovieDetailBloc = MockMovieDetailBloc();
    mockMovieRecommendationsBloc = MockMovieRecommendationsBloc();
    mockMovieWatchlistBloc = MockMovieWatchlistBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailBloc>.value(value: mockMovieDetailBloc),
        BlocProvider<MovieRecommendationsBloc>.value(
            value: mockMovieRecommendationsBloc),
        BlocProvider<MovieWatchlistBloc>.value(value: mockMovieWatchlistBloc),
      ],
      child: MaterialApp(home: body),
    );
  }

  final testMovieDetailEmpty = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 45,
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );

  testWidgets('Page should display empty genre and duration correctly', (
    WidgetTester tester,
  ) async {
    when(() => mockMovieDetailBloc.state)
        .thenReturn(MovieDetailHasData(testMovieDetailEmpty));
    when(() => mockMovieRecommendationsBloc.state)
        .thenReturn(MovieRecommendationsEmpty());
    when(() => mockMovieWatchlistBloc.state)
        .thenReturn(MovieWatchlistStatus(false));

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.text('45m'), findsOneWidget);
  });

  testWidgets('Page should display error state for recommendations', (
    WidgetTester tester,
  ) async {
    when(() => mockMovieDetailBloc.state)
        .thenReturn(MovieDetailHasData(testMovieDetailEmpty));
    when(() => mockMovieRecommendationsBloc.state)
        .thenReturn(MovieRecommendationsError('Error msg'));
    when(() => mockMovieWatchlistBloc.state)
        .thenReturn(MovieWatchlistStatus(false));

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.text('Error msg'), findsOneWidget);
  });

  testWidgets('Page should display loading state for recommendations', (
    WidgetTester tester,
  ) async {
    when(() => mockMovieDetailBloc.state)
        .thenReturn(MovieDetailHasData(testMovieDetailEmpty));
    when(() => mockMovieRecommendationsBloc.state)
        .thenReturn(MovieRecommendationsLoading());
    when(() => mockMovieWatchlistBloc.state)
        .thenReturn(MovieWatchlistStatus(false));

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });
}
