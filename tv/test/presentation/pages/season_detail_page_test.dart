import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/domain/entities/episode.dart';
import 'package:tv/domain/entities/season_detail.dart';
import 'package:tv/presentation/bloc/season_detail_bloc.dart';
import 'package:tv/presentation/pages/season_detail_page.dart';

class MockSeasonDetailBloc
    extends MockBloc<SeasonDetailEvent, SeasonDetailState>
    implements SeasonDetailBloc {}

class FakeSeasonDetailEvent extends Fake implements SeasonDetailEvent {}

class FakeSeasonDetailState extends Fake implements SeasonDetailState {}

void main() {
  late MockSeasonDetailBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeSeasonDetailEvent());
    registerFallbackValue(FakeSeasonDetailState());
  });

  setUp(() {
    mockBloc = MockSeasonDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<SeasonDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: Material(child: body),
        onGenerateRoute: (settings) {
          if (settings.name == '/detail-episode') {
            return MaterialPageRoute(builder: (_) => Container());
          }
          return null;
        },
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(SeasonDetailLoading());
    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);
    await tester.pumpWidget(makeTestableWidget(SeasonDetailPage(
        args: SeasonDetailArguments(tvId: 1, seasonNumber: 1))));
    expect(centerFinder, findsWidgets);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display Season info when data is loaded',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(SeasonDetailHasData(
      SeasonDetail(
        id: 1,
        airDate: 'airDate',
        episodes: [],
        name: 'Season Name',
        overview: 'overview',
        posterPath: 'posterPath',
        seasonNumber: 1,
        voteAverage: 1,
      ),
    ));
    final textFinder = find.text('Season Name');
    await tester.pumpWidget(makeTestableWidget(SeasonDetailPage(
        args: SeasonDetailArguments(tvId: 1, seasonNumber: 1))));
    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(SeasonDetailError('Error message'));
    final textFinder = find.text('Error message');
    await tester.pumpWidget(makeTestableWidget(SeasonDetailPage(
        args: SeasonDetailArguments(tvId: 1, seasonNumber: 1))));
    expect(textFinder, findsOneWidget);
  });

  testWidgets(
      'Page should display Season info with episodes when data is loaded',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(SeasonDetailHasData(
      SeasonDetail(
        id: 1,
        airDate: '2023-10-10',
        episodes: [
          Episode(
            airDate: '2023-10-10',
            episodeNumber: 1,
            id: 1,
            name: 'Episode Name',
            overview: 'overview',
            seasonNumber: 1,
            stillPath: '/path.jpg',
            voteAverage: 1,
            voteCount: 1,
            crew: [],
            guestStars: [],
          )
        ],
        name: 'Season Name',
        overview: 'overview',
        posterPath: 'posterPath',
        seasonNumber: 1,
        voteAverage: 1,
      ),
    ));

    await tester.pumpWidget(makeTestableWidget(SeasonDetailPage(
        args: SeasonDetailArguments(tvId: 1, seasonNumber: 1))));

    final listViewFinder = find.byType(ListView);
    expect(listViewFinder, findsOneWidget);

    final listTileFinder = find.byType(ListTile);
    expect(listTileFinder, findsOneWidget);

    await tester.tap(listTileFinder);
  });

  testWidgets('Page should display default date when date is invalid',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(SeasonDetailHasData(
      SeasonDetail(
        id: 1,
        airDate: 'invalid-date',
        episodes: [
          Episode(
            airDate: 'invalid-date',
            episodeNumber: 1,
            id: 1,
            name: 'Episode Name',
            overview: '',
            seasonNumber: 1,
            stillPath: null,
            voteAverage: 1,
            voteCount: 1,
            crew: [],
            guestStars: [],
          )
        ],
        name: 'Season Name',
        overview: '',
        posterPath: 'posterPath',
        seasonNumber: 1,
        voteAverage: 1,
      ),
    ));

    await tester.pumpWidget(makeTestableWidget(SeasonDetailPage(
        args: SeasonDetailArguments(tvId: 1, seasonNumber: 1))));
    expect(find.text('invalid-date'), findsWidgets);
  });
}
