import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/presentation/bloc/popular_tvs_bloc.dart';
import 'package:tv/presentation/pages/popular_tvs_page.dart';

class MockPopularTVsBloc extends MockBloc<PopularTVsEvent, PopularTVsState>
    implements PopularTVsBloc {}

class FakePopularTVsEvent extends Fake implements PopularTVsEvent {}

class FakePopularTVsState extends Fake implements PopularTVsState {}

void main() {
  late MockPopularTVsBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakePopularTVsEvent());
    registerFallbackValue(FakePopularTVsState());
  });

  setUp(() {
    mockBloc = MockPopularTVsBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularTVsBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: Material(child: body)),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(PopularTVsLoading());
    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);
    await tester.pumpWidget(makeTestableWidget(PopularTVsPage()));
    expect(centerFinder, findsWidgets);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(PopularTVsHasData([
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
    await tester.pumpWidget(makeTestableWidget(PopularTVsPage()));
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(PopularTVsError('Error message'));
    final textFinder = find.byKey(Key('error_message'));
    await tester.pumpWidget(makeTestableWidget(PopularTVsPage()));
    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display empty container when Empty', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(PopularTVsEmpty());

    final containerFinder = find.byType(Container);

    await tester.pumpWidget(makeTestableWidget(PopularTVsPage()));

    expect(containerFinder, findsWidgets);
  });
}
