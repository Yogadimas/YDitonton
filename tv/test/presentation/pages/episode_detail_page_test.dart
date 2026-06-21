import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv/domain/entities/episode.dart';
import 'package:tv/presentation/pages/episode_detail_page.dart';

void main() {
  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: body,
    );
  }

  testWidgets('Page should display episode details correctly',
      (WidgetTester tester) async {
    const tEpisode = Episode(
      id: 1,
      name: 'Episode 1',
      overview: 'Episode overview',
      seasonNumber: 1,
      episodeNumber: 1,
      stillPath: '/path.jpg',
      voteAverage: 1.0,
      voteCount: 1,
      airDate: '2021-01-01',
      crew: ['Director: John Doe'],
      guestStars: ['Guest: Jane Doe'],
    );

    await tester
        .pumpWidget(makeTestableWidget(EpisodeDetailPage(episode: tEpisode)));

    expect(find.text('Episode 1'), findsWidgets);
    expect(find.text('Episode overview'), findsOneWidget);
    expect(find.text('Director: John Doe'), findsOneWidget);
    expect(find.text('Guest: Jane Doe'), findsOneWidget);
  });

  testWidgets('Page should display empty text when data is missing',
      (WidgetTester tester) async {
    const tEpisode = Episode(
      id: 1,
      name: 'Episode 1',
      overview: '',
      seasonNumber: 1,
      episodeNumber: 1,
      stillPath: null,
      voteAverage: 1.0,
      voteCount: 1,
      airDate: '',
      crew: [],
      guestStars: [],
    );

    await tester
        .pumpWidget(makeTestableWidget(EpisodeDetailPage(episode: tEpisode)));

    expect(find.text('Episode 1'), findsWidgets);
    expect(find.text('No synopsis available.'), findsOneWidget);
    expect(find.byIcon(Icons.image), findsOneWidget);
    expect(find.text('-'), findsOneWidget);
  });
}
