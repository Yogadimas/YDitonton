import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/presentation/bloc/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_recommendations_bloc.dart';
import 'package:movie/presentation/bloc/movie_watchlist_bloc.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';

import '../../dummy_data/dummy_objects.dart';

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
      child: MaterialApp(
        home: body,
        onGenerateRoute: (settings) {
          if (settings.name == '/detail') {
            return MaterialPageRoute(builder: (_) => Container());
          }
          return null;
        },
      ),
    );
  }

  testWidgets(
    'Watchlist button should display add icon when movie not added to watchlist',
    (WidgetTester tester) async {
      when(() => mockMovieDetailBloc.state)
          .thenReturn(MovieDetailHasData(testMovieDetail));
      when(() => mockMovieRecommendationsBloc.state)
          .thenReturn(MovieRecommendationsHasData(<Movie>[]));
      when(() => mockMovieWatchlistBloc.state)
          .thenReturn(MovieWatchlistStatus(false));

      final watchlistButtonIcon = find.byIcon(Icons.add);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should dispay check icon when movie is added to wathclist',
    (WidgetTester tester) async {
      when(() => mockMovieDetailBloc.state)
          .thenReturn(MovieDetailHasData(testMovieDetail));
      when(() => mockMovieRecommendationsBloc.state)
          .thenReturn(MovieRecommendationsHasData(<Movie>[]));
      when(() => mockMovieWatchlistBloc.state)
          .thenReturn(MovieWatchlistStatus(true));

      final watchlistButtonIcon = find.byIcon(Icons.check);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display Snackbar when added to watchlist',
    (WidgetTester tester) async {
      when(() => mockMovieDetailBloc.state)
          .thenReturn(MovieDetailHasData(testMovieDetail));
      when(() => mockMovieRecommendationsBloc.state)
          .thenReturn(MovieRecommendationsHasData(<Movie>[]));
      when(() => mockMovieWatchlistBloc.state)
          .thenReturn(MovieWatchlistStatus(false));

      whenListen(
        mockMovieWatchlistBloc,
        Stream.fromIterable([MovieWatchlistMessage('Added to Watchlist')]),
        initialState: MovieWatchlistStatus(false),
      );

      final watchlistButton = find.byType(FilledButton);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Added to Watchlist'), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display AlertDialog when add to watchlist failed',
    (WidgetTester tester) async {
      when(() => mockMovieDetailBloc.state)
          .thenReturn(MovieDetailHasData(testMovieDetail));
      when(() => mockMovieRecommendationsBloc.state)
          .thenReturn(MovieRecommendationsHasData(<Movie>[]));
      when(() => mockMovieWatchlistBloc.state)
          .thenReturn(MovieWatchlistStatus(false));

      whenListen(
        mockMovieWatchlistBloc,
        Stream.fromIterable([MovieWatchlistError('Failed')]),
        initialState: MovieWatchlistStatus(false),
      );

      final watchlistButton = find.byType(FilledButton);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
    },
  );

  testWidgets('Page should display ProgressIndicator when state is Loading', (
    WidgetTester tester,
  ) async {
    when(() => mockMovieDetailBloc.state).thenReturn(MovieDetailLoading());
    when(() => mockMovieRecommendationsBloc.state)
        .thenReturn(MovieRecommendationsLoading());
    when(() => mockMovieWatchlistBloc.state)
        .thenReturn(MovieWatchlistStatus(false));

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    when(() => mockMovieDetailBloc.state)
        .thenReturn(MovieDetailError('Error message'));
    when(() => mockMovieRecommendationsBloc.state)
        .thenReturn(MovieRecommendationsEmpty());
    when(() => mockMovieWatchlistBloc.state)
        .thenReturn(MovieWatchlistStatus(false));

    final textFinder = find.text('Error message');

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    expect(textFinder, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should remove from watchlist when tapped and is already added',
      (
    WidgetTester tester,
  ) async {
    when(() => mockMovieDetailBloc.state)
        .thenReturn(MovieDetailHasData(testMovieDetail));
    when(() => mockMovieRecommendationsBloc.state)
        .thenReturn(MovieRecommendationsHasData(<Movie>[]));
    when(() => mockMovieWatchlistBloc.state)
        .thenReturn(MovieWatchlistStatus(true));

    whenListen(
      mockMovieWatchlistBloc,
      Stream.fromIterable([MovieWatchlistMessage('Removed from Watchlist')]),
      initialState: MovieWatchlistStatus(true),
    );

    final watchlistButton = find.byType(FilledButton);

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Removed from Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when MovieWatchlistMessage is not success',
      (
    WidgetTester tester,
  ) async {
    when(() => mockMovieDetailBloc.state)
        .thenReturn(MovieDetailHasData(testMovieDetail));
    when(() => mockMovieRecommendationsBloc.state)
        .thenReturn(MovieRecommendationsHasData(<Movie>[]));
    when(() => mockMovieWatchlistBloc.state)
        .thenReturn(MovieWatchlistStatus(false));

    whenListen(
      mockMovieWatchlistBloc,
      Stream.fromIterable([MovieWatchlistMessage('Some random message')]),
      initialState: MovieWatchlistStatus(false),
    );

    final watchlistButton = find.byType(FilledButton);

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Some random message'), findsOneWidget);
  });

  testWidgets('Page should display Recommendation ListView when data is loaded',
      (
    WidgetTester tester,
  ) async {
    when(() => mockMovieDetailBloc.state)
        .thenReturn(MovieDetailHasData(testMovieDetail));
    when(() => mockMovieRecommendationsBloc.state)
        .thenReturn(MovieRecommendationsHasData([testMovie]));
    when(() => mockMovieWatchlistBloc.state)
        .thenReturn(MovieWatchlistStatus(false));

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    final listViewFinder = find.byType(ListView);
    expect(listViewFinder, findsOneWidget);

    final inkWellFinder = find.byType(InkWell).first;
    await tester.dragUntilVisible(
      inkWellFinder,
      find.byType(SingleChildScrollView),
      const Offset(0, -50),
    );
    await tester.pump();
    await tester.tap(inkWellFinder, warnIfMissed: false);
  });

  testWidgets('Page should display Error text when Recommendation Error', (
    WidgetTester tester,
  ) async {
    when(() => mockMovieDetailBloc.state)
        .thenReturn(MovieDetailHasData(testMovieDetail));
    when(() => mockMovieRecommendationsBloc.state)
        .thenReturn(MovieRecommendationsError('Rec error'));
    when(() => mockMovieWatchlistBloc.state)
        .thenReturn(MovieWatchlistStatus(false));

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    final textFinder = find.text('Rec error');
    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should pop when back button tapped', (
    WidgetTester tester,
  ) async {
    when(() => mockMovieDetailBloc.state)
        .thenReturn(MovieDetailHasData(testMovieDetail));
    when(() => mockMovieRecommendationsBloc.state)
        .thenReturn(MovieRecommendationsHasData(<Movie>[]));
    when(() => mockMovieWatchlistBloc.state)
        .thenReturn(MovieWatchlistStatus(false));

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    final backButton = find.byIcon(Icons.arrow_back);
    await tester.tap(backButton);
  });
}
