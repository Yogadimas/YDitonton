import 'dart:io';
import 'package:ditonton/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';
import 'package:movie/presentation/pages/home_movie_page.dart';
import 'package:tv/presentation/pages/home_tv_page.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';
import 'package:movie/presentation/widgets/movie_card_list.dart';

extension WaitExtension on WidgetTester {
  Future<void> waitFor(Finder finder,
      {Duration timeout = const Duration(seconds: 15)}) async {
    final endTime = DateTime.now().add(timeout);
    do {
      if (any(finder)) return;
      await pump(const Duration(milliseconds: 500));
    } while (DateTime.now().isBefore(endTime));
    fail('Timeout waiting for $finder');
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  group('End-to-End Test (TV Series)', () {
    testWidgets(
      'Full scenario: Add TV Series to watchlist, verify in Watchlist page, remove, verify empty state',
      (WidgetTester tester) async {
        // Menjalankan aplikasi
        await app.main();

        // Menunggu animasi dan API selesai
        await tester.waitFor(find.byType(HomeMoviePage));

        // Memastikan kita berada di HomeMoviePage (default awal aplikasi)
        expect(find.byType(HomeMoviePage), findsOneWidget);

        // Buka Drawer dan pindah ke halaman TV Series
        final drawerButton = find.byTooltip('Open navigation menu');
        await tester.tap(drawerButton);
        await tester.pump(const Duration(seconds: 1));

        final tvSeriesMenu = find.text('TV Series');
        await tester.waitFor(tvSeriesMenu);
        await tester.tap(tvSeriesMenu);

        await tester.waitFor(find.byType(HomeTVPage));

        // Memastikan sekarang berada di HomeTVPage
        expect(find.byType(HomeTVPage), findsOneWidget);

        // Mencari daftar TV Series
        final tvListFinder = find.byType(TVList);
        await tester.waitFor(tvListFinder);

        // Mengambil item (InkWell) pertama
        final tvItemFinder =
            find.descendant(of: tvListFinder, matching: find.byType(InkWell));
        await tester.waitFor(tvItemFinder);
        await tester.tap(tvItemFinder.first);

        final watchlistButtonFinder = find.byType(ElevatedButton);
        await tester.waitFor(watchlistButtonFinder);

        final checkIconFinder = find.descendant(
            of: watchlistButtonFinder, matching: find.byIcon(Icons.check));
        if (tester.any(checkIconFinder)) {
          await tester.tap(watchlistButtonFinder);
          await tester.pump(const Duration(milliseconds: 500));
          await tester.pump(const Duration(seconds: 1));
          await tester.pump(const Duration(seconds: 6));
        }

        await tester.tap(watchlistButtonFinder);
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(seconds: 1));

        // Verifikasi SnackBar Added
        await tester.waitFor(find.byType(SnackBar));
        expect(find.text('Added to Watchlist'), findsOneWidget);

        // Tunggu SnackBar menghilang dengan memompa waktu agar animasi hide selesai
        await tester.pump(const Duration(seconds: 5));
        await tester.pump(const Duration(seconds: 5));

        // 3. Kembali ke Home (TV)
        final backButton = find.byIcon(Icons.arrow_back);
        await tester.waitFor(backButton);
        await tester.tap(backButton);
        await tester.pump(const Duration(seconds: 2));

        // 4. Buka Drawer dan klik Watchlist
        await tester.waitFor(drawerButton);
        await tester.tap(drawerButton);

        final watchlistMenu = find.text('Watchlist');
        await tester.waitFor(watchlistMenu);
        await tester.tap(watchlistMenu);

        // 5. Pindah ke tab TV Series di WatchlistPage
        final tvTab = find.descendant(
            of: find.byType(TabBar), matching: find.text('TV Series'));
        await tester.waitFor(tvTab);
        await tester.tap(tvTab);
        await tester.pump(const Duration(milliseconds: 500));

        // Verifikasi di halaman Watchlist ada datanya (TvCard)
        final tvCardInWatchlist = find.byType(TVCard);
        await tester.waitFor(tvCardInWatchlist);
        expect(tvCardInWatchlist, findsWidgets);

        // 6. Klik item tersebut untuk masuk detail lagi
        await tester.tap(tvCardInWatchlist.first);

        // 7. Klik tombol Watchlist (Hapus)
        await tester.waitFor(watchlistButtonFinder);
        await tester.tap(watchlistButtonFinder);
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(seconds: 1));

        // Verifikasi SnackBar Removed
        await tester.waitFor(find.byType(SnackBar));
        expect(find.text('Removed from Watchlist'), findsOneWidget);

        // Tunggu SnackBar menghilang
        await tester.pump(const Duration(seconds: 5));
        await tester.pump(const Duration(seconds: 5));

        // 8. Kembali ke halaman Watchlist
        await tester.waitFor(backButton);
        await tester.tap(backButton);
        await tester.pump(const Duration(seconds: 2));

        // 9. Verifikasi empty state TV Series (kosong)
        await tester
            .waitFor(find.text('Belum ada TV Series di Watchlist Anda'));
        expect(find.byType(TVCard), findsNothing);
        expect(
          find.text('Belum ada TV Series di Watchlist Anda'),
          findsOneWidget,
        );
      },
    );
  });

  group('End-to-End Test (Movie)', () {
    testWidgets(
      'Full scenario: Add Movie to watchlist, verify in Watchlist page, remove, verify empty state',
      (WidgetTester tester) async {
        await GetIt.I.reset();
        await app.main();
        await tester.waitFor(find.byType(HomeMoviePage));

        expect(find.byType(HomeMoviePage), findsOneWidget);

        final movieListFinder = find.byType(MovieList);
        await tester.waitFor(movieListFinder);

        final movieItemFinder = find.descendant(
            of: movieListFinder, matching: find.byType(InkWell));

        await tester.waitFor(movieItemFinder);
        await tester.tap(movieItemFinder.first);

        final watchlistButtonFinder = find.byType(FilledButton);
        await tester.waitFor(watchlistButtonFinder);

        final checkIconFinder = find.descendant(
            of: watchlistButtonFinder, matching: find.byIcon(Icons.check));
        if (tester.any(checkIconFinder)) {
          await tester.tap(watchlistButtonFinder);
          await tester.pump(const Duration(milliseconds: 500));
          await tester.pump(const Duration(seconds: 1));
          await tester.pump(const Duration(seconds: 6));
        }

        await tester.tap(watchlistButtonFinder);
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(seconds: 1));

        await tester.waitFor(find.byType(SnackBar));
        expect(find.text('Added to Watchlist'), findsOneWidget);

        await tester.pump(const Duration(seconds: 5));
        await tester.pump(const Duration(seconds: 5));

        final backButton = find.byIcon(Icons.arrow_back);
        await tester.waitFor(backButton);
        await tester.tap(backButton);
        await tester.pump(const Duration(seconds: 2));

        final drawerButton = find.byTooltip('Open navigation menu');
        await tester.waitFor(drawerButton);
        await tester.tap(drawerButton);
        await tester.pump(const Duration(seconds: 1));

        final watchlistMenu = find.text('Watchlist');
        await tester.waitFor(watchlistMenu);
        await tester.tap(watchlistMenu);
        await tester.pump(const Duration(seconds: 2));

        final movieTab = find.text('Movies');
        await tester.waitFor(movieTab);
        await tester.tap(movieTab);
        await tester.pump(const Duration(milliseconds: 500));

        final movieItemInWatchlist = find.byType(MovieCard);
        await tester.waitFor(movieItemInWatchlist);
        expect(movieItemInWatchlist, findsWidgets);

        await tester.tap(movieItemInWatchlist.first);

        await tester.waitFor(watchlistButtonFinder);
        await tester.tap(watchlistButtonFinder);
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(seconds: 1));

        await tester.waitFor(find.byType(SnackBar));
        expect(find.text('Removed from Watchlist'), findsOneWidget);

        await tester.pump(const Duration(seconds: 5));
        await tester.pump(const Duration(seconds: 5));

        await tester.waitFor(backButton);
        await tester.tap(backButton);
        await tester.pump(const Duration(seconds: 2));

        // Verifikasi empty state Movie (kosong)
        await tester.waitFor(find.text('Belum ada film di Watchlist Anda'));
        expect(find.text('Belum ada film di Watchlist Anda'), findsOneWidget);
      },
    );
  });
}
