import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/presentation/bloc/top_rated_tvs_bloc.dart';
import 'package:tv/presentation/pages/top_rated_tvs_page.dart';

class MockTopRatedTVsBloc extends MockBloc<TopRatedTVsEvent, TopRatedTVsState>
    implements TopRatedTVsBloc {}

class FakeTopRatedTVsEvent extends Fake implements TopRatedTVsEvent {}

class FakeTopRatedTVsState extends Fake implements TopRatedTVsState {}

void main() {
  late MockTopRatedTVsBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeTopRatedTVsEvent());
    registerFallbackValue(FakeTopRatedTVsState());
  });

  setUp(() {
    mockBloc = MockTopRatedTVsBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTVsBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: Material(child: body)),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(TopRatedTVsLoading());
    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);
    await tester.pumpWidget(makeTestableWidget(TopRatedTVsPage()));
    expect(centerFinder, findsWidgets);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(TopRatedTVsHasData([
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
    await tester.pumpWidget(makeTestableWidget(TopRatedTVsPage()));
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(TopRatedTVsError('Error message'));
    final textFinder = find.byKey(Key('error_message'));
    await tester.pumpWidget(makeTestableWidget(TopRatedTVsPage()));
    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display empty container when Empty', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(TopRatedTVsEmpty());

    final containerFinder = find.byType(Container);

    await tester.pumpWidget(makeTestableWidget(TopRatedTVsPage()));

    expect(containerFinder, findsWidgets);
  });
}
