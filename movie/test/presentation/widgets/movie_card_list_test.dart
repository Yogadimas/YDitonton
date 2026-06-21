import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/presentation/widgets/movie_card_list.dart';

void main() {
  final tMovie = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(home: Scaffold(body: body));
  }

  testWidgets('MovieCard should be able to be tapped', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: MovieCard(tMovie)),
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(builder: (_) => Container());
        },
      ),
    );
    await tester.tap(find.byType(InkWell));
  });

  testWidgets('Page should display title, overview, and poster', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(MovieCard(tMovie)));

    final titleFinder = find.text('Spider-Man');
    final overviewFinder = find.text(
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    );
    final imageFinder = find.byType(CachedNetworkImage);

    expect(titleFinder, findsOneWidget);
    expect(overviewFinder, findsOneWidget);
    expect(imageFinder, findsOneWidget);
  });
}
