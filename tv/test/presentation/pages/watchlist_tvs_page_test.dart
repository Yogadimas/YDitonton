import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/presentation/bloc/watchlist_tvs_bloc.dart';
import 'package:tv/presentation/pages/watchlist_tvs_page.dart';

class MockWatchlistTVsBloc
    extends MockBloc<WatchlistTVsEvent, WatchlistTVsState>
    implements WatchlistTVsBloc {}

class FakeWatchlistTVsEvent extends Fake implements WatchlistTVsEvent {}

class FakeWatchlistTVsState extends Fake implements WatchlistTVsState {}

void main() {
  late MockWatchlistTVsBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeWatchlistTVsEvent());
    registerFallbackValue(FakeWatchlistTVsState());
  });

  setUp(() {
    mockBloc = MockWatchlistTVsBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistTVsBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: Material(child: body)),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(WatchlistTVsLoading());
    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);
    await tester.pumpWidget(makeTestableWidget(WatchlistTVsPage()));
    expect(centerFinder, findsWidgets);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(WatchlistTVsHasData([
      TV(
        backdropPath: 'backdropPath',
        genreIds: [1],
        id: 1,
        originalName: 'originalName',
        overview: 'overview',
        popularity: 1,
        posterPath: 'posterPath',
        firstAirDate: 'firstAirDate',
        name: 'name',
        voteAverage: 1,
        voteCount: 1,
      ),
    ]));
    final listViewFinder = find.byType(ListView);
    await tester.pumpWidget(makeTestableWidget(WatchlistTVsPage()));
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(WatchlistTVsError('Error message'));
    final textFinder = find.byKey(Key('error_message'));
    await tester.pumpWidget(makeTestableWidget(WatchlistTVsPage()));
    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display empty message when data is empty',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(WatchlistTVsHasData([]));

    await tester.pumpWidget(makeTestableWidget(WatchlistTVsPage()));

    expect(find.text('Belum ada TV Series di Watchlist Anda'), findsOneWidget);
  });

  testWidgets('Page should display empty container when state is initial',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(WatchlistTVsEmpty());

    await tester.pumpWidget(makeTestableWidget(WatchlistTVsPage()));

    expect(find.byType(Container), findsWidgets);
  });

  testWidgets('didPopNext should call FetchWatchlistTVs',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(WatchlistTVsEmpty());

    await tester.pumpWidget(makeTestableWidget(WatchlistTVsPage()));

    final state =
        tester.state<State<WatchlistTVsPage>>(find.byType(WatchlistTVsPage));
    // cast to access didPopNext via dynamic or cast
    (state as dynamic).didPopNext();

    verify(() => mockBloc.add(FetchWatchlistTVs())).called(greaterThan(0));
  });
}
