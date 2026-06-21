import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:tv/presentation/bloc/tv_recommendations_bloc.dart';
import 'package:tv/presentation/bloc/tv_watchlist_bloc.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';

class MockTVDetailBloc extends MockBloc<TVDetailEvent, TVDetailState>
    implements TVDetailBloc {}

class MockTVRecommendationsBloc
    extends MockBloc<TVRecommendationsEvent, TVRecommendationsState>
    implements TVRecommendationsBloc {}

class MockTVWatchlistBloc extends MockBloc<TVWatchlistEvent, TVWatchlistState>
    implements TVWatchlistBloc {}

class FakeTVDetailEvent extends Fake implements TVDetailEvent {}

class FakeTVDetailState extends Fake implements TVDetailState {}

class FakeTVRecommendationsEvent extends Fake
    implements TVRecommendationsEvent {}

class FakeTVRecommendationsState extends Fake
    implements TVRecommendationsState {}

class FakeTVWatchlistEvent extends Fake implements TVWatchlistEvent {}

class FakeTVWatchlistState extends Fake implements TVWatchlistState {}

void main() {
  late MockTVDetailBloc mockTVDetailBloc;
  late MockTVRecommendationsBloc mockTVRecommendationsBloc;
  late MockTVWatchlistBloc mockTVWatchlistBloc;

  setUpAll(() {
    registerFallbackValue(FakeTVDetailEvent());
    registerFallbackValue(FakeTVDetailState());
    registerFallbackValue(FakeTVRecommendationsEvent());
    registerFallbackValue(FakeTVRecommendationsState());
    registerFallbackValue(FakeTVWatchlistEvent());
    registerFallbackValue(FakeTVWatchlistState());
  });

  setUp(() {
    mockTVDetailBloc = MockTVDetailBloc();
    mockTVRecommendationsBloc = MockTVRecommendationsBloc();
    mockTVWatchlistBloc = MockTVWatchlistBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TVDetailBloc>.value(value: mockTVDetailBloc),
        BlocProvider<TVRecommendationsBloc>.value(
            value: mockTVRecommendationsBloc),
        BlocProvider<TVWatchlistBloc>.value(value: mockTVWatchlistBloc),
      ],
      child: MaterialApp(home: body),
    );
  }

  final tTVDetail = TVDetail(
    backdropPath: 'backdropPath',
    genres: [],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
    seasons: [],
  );

  testWidgets(
      'Watchlist button should display add icon when TV not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockTVDetailBloc.state).thenReturn(TVDetailHasData(tTVDetail));
    when(() => mockTVRecommendationsBloc.state)
        .thenReturn(TVRecommendationsHasData(<TV>[]));
    when(() => mockTVWatchlistBloc.state).thenReturn(TVWatchlistStatus(false));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(makeTestableWidget(TVDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when TV is added to watchlist',
      (WidgetTester tester) async {
    when(() => mockTVDetailBloc.state).thenReturn(TVDetailHasData(tTVDetail));
    when(() => mockTVRecommendationsBloc.state)
        .thenReturn(TVRecommendationsHasData(<TV>[]));
    when(() => mockTVWatchlistBloc.state).thenReturn(TVWatchlistStatus(true));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(makeTestableWidget(TVDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(() => mockTVDetailBloc.state).thenReturn(TVDetailHasData(tTVDetail));
    when(() => mockTVRecommendationsBloc.state)
        .thenReturn(TVRecommendationsHasData(<TV>[]));
    when(() => mockTVWatchlistBloc.state).thenReturn(TVWatchlistStatus(false));

    whenListen(
      mockTVWatchlistBloc,
      Stream.fromIterable([TVWatchlistMessage('Added to Watchlist')]),
      initialState: TVWatchlistStatus(false),
    );

    await tester.pumpWidget(makeTestableWidget(TVDetailPage(id: 1)));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    when(() => mockTVDetailBloc.state).thenReturn(TVDetailHasData(tTVDetail));
    when(() => mockTVRecommendationsBloc.state)
        .thenReturn(TVRecommendationsHasData(<TV>[]));
    when(() => mockTVWatchlistBloc.state).thenReturn(TVWatchlistStatus(false));

    whenListen(
      mockTVWatchlistBloc,
      Stream.fromIterable([TVWatchlistError('Failed')]),
      initialState: TVWatchlistStatus(false),
    );

    await tester.pumpWidget(makeTestableWidget(TVDetailPage(id: 1)));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets('Page should display ProgressIndicator when state is Loading',
      (WidgetTester tester) async {
    when(() => mockTVDetailBloc.state).thenReturn(TVDetailLoading());
    when(() => mockTVRecommendationsBloc.state)
        .thenReturn(TVRecommendationsLoading());
    when(() => mockTVWatchlistBloc.state).thenReturn(TVWatchlistStatus(false));

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(makeTestableWidget(TVDetailPage(id: 1)));
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockTVDetailBloc.state)
        .thenReturn(TVDetailError('Error message'));
    when(() => mockTVRecommendationsBloc.state)
        .thenReturn(TVRecommendationsLoading());
    when(() => mockTVWatchlistBloc.state).thenReturn(TVWatchlistStatus(false));

    final textFinder = find.text('Error message');

    await tester.pumpWidget(makeTestableWidget(TVDetailPage(id: 1)));
    expect(textFinder, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should remove from watchlist when tapped and is already added',
      (WidgetTester tester) async {
    when(() => mockTVDetailBloc.state).thenReturn(TVDetailHasData(tTVDetail));
    when(() => mockTVRecommendationsBloc.state)
        .thenReturn(TVRecommendationsHasData(<TV>[]));
    when(() => mockTVWatchlistBloc.state).thenReturn(TVWatchlistStatus(true));

    whenListen(
      mockTVWatchlistBloc,
      Stream.fromIterable([TVWatchlistMessage('Removed from Watchlist')]),
      initialState: TVWatchlistStatus(true),
    );

    await tester.pumpWidget(makeTestableWidget(TVDetailPage(id: 1)));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Removed from Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when TVWatchlistMessage is not success',
      (WidgetTester tester) async {
    when(() => mockTVDetailBloc.state).thenReturn(TVDetailHasData(tTVDetail));
    when(() => mockTVRecommendationsBloc.state)
        .thenReturn(TVRecommendationsHasData(<TV>[]));
    when(() => mockTVWatchlistBloc.state).thenReturn(TVWatchlistStatus(false));

    whenListen(
      mockTVWatchlistBloc,
      Stream.fromIterable([TVWatchlistMessage('Some random message')]),
      initialState: TVWatchlistStatus(false),
    );

    await tester.pumpWidget(makeTestableWidget(TVDetailPage(id: 1)));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Some random message'), findsOneWidget);
  });

  testWidgets('Page should display Recommendation ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockTVDetailBloc.state).thenReturn(TVDetailHasData(tTVDetail));
    when(() => mockTVRecommendationsBloc.state)
        .thenReturn(TVRecommendationsHasData([
      TV(
        backdropPath: 'backdropPath',
        genreIds: [],
        id: 1,
        originalName: 'originalName',
        overview: 'overview',
        popularity: 1,
        posterPath: 'posterPath',
        firstAirDate: 'firstAirDate',
        name: 'name',
        voteAverage: 1,
        voteCount: 1,
      )
    ]));
    when(() => mockTVWatchlistBloc.state).thenReturn(TVWatchlistStatus(false));

    await tester.pumpWidget(makeTestableWidget(TVDetailPage(id: 1)));

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

  testWidgets('Page should display Error text when Recommendation Error',
      (WidgetTester tester) async {
    when(() => mockTVDetailBloc.state).thenReturn(TVDetailHasData(tTVDetail));
    when(() => mockTVRecommendationsBloc.state)
        .thenReturn(TVRecommendationsError('Rec error'));
    when(() => mockTVWatchlistBloc.state).thenReturn(TVWatchlistStatus(false));

    await tester.pumpWidget(makeTestableWidget(TVDetailPage(id: 1)));

    final textFinder = find.text('Rec error');
    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should pop when back button tapped',
      (WidgetTester tester) async {
    when(() => mockTVDetailBloc.state).thenReturn(TVDetailHasData(tTVDetail));
    when(() => mockTVRecommendationsBloc.state)
        .thenReturn(TVRecommendationsHasData(<TV>[]));
    when(() => mockTVWatchlistBloc.state).thenReturn(TVWatchlistStatus(false));

    await tester.pumpWidget(makeTestableWidget(TVDetailPage(id: 1)));

    final backButton = find.byIcon(Icons.arrow_back);
    await tester.tap(backButton);
  });
}
