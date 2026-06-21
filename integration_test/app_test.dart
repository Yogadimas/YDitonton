import 'package:ditonton/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:movie/presentation/pages/home_movie_page.dart';
import 'package:tv/presentation/pages/home_tv_page.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Test (TV Series)', () {
    testWidgets(
      'Full scenario: Add TV Series to watchlist, verify in Watchlist page, remove, verify empty state',
      (WidgetTester tester) async {
        // Menjalankan aplikasi
        app.main();

        // Menunggu animasi dan API selesai
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Memastikan kita berada di HomeMoviePage (default awal aplikasi)
        expect(find.byType(HomeMoviePage), findsOneWidget);

        // Buka Drawer dan pindah ke halaman TV Series
        final drawerButton = find.byTooltip('Open navigation menu');
        await tester.tap(drawerButton);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final tvSeriesMenu = find.text('TV Series');
        await tester.tap(tvSeriesMenu);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Memastikan sekarang berada di HomeTVPage
        expect(find.byType(HomeTVPage), findsOneWidget);

        // Mencari daftar TV Series
        final tvListFinder = find.byType(TVList).first;

        // Mengambil item (InkWell) pertama
        final tvItemFinder = find
            .descendant(of: tvListFinder, matching: find.byType(InkWell))
            .first;

        // 1. Klik TV Series untuk masuk detail
        await tester.tap(tvItemFinder);
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // 2. Klik tombol Watchlist (Tambah)
        final watchlistButtonFinder = find.byType(ElevatedButton);
        await tester.tap(watchlistButtonFinder);
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(seconds: 1));

        // Verifikasi SnackBar Added
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Added to Watchlist'), findsOneWidget);

        // Tunggu SnackBar menghilang
        await tester.pump(const Duration(seconds: 5));

        // 3. Kembali ke Home (TV)
        final backButton = find.byIcon(Icons.arrow_back);
        await tester.tap(backButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // 4. Buka Drawer dan klik Watchlist
        await tester.tap(drawerButton);
        await tester.pumpAndSettle(const Duration(seconds: 1));
        final watchlistMenu = find.text('Watchlist');
        await tester.tap(watchlistMenu);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // 5. Pindah ke tab TV Series di WatchlistPage
        final tvTab = find.text('TV Series');
        await tester.tap(tvTab);
        await tester.pumpAndSettle();

        // Verifikasi di halaman Watchlist ada datanya (TvCard)
        final tvCardInWatchlist = find.byType(TVCard).first;
        expect(tvCardInWatchlist, findsOneWidget);

        // 6. Klik item tersebut untuk masuk detail lagi
        await tester.tap(tvCardInWatchlist);
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // 7. Klik tombol Watchlist (Hapus)
        await tester.tap(watchlistButtonFinder);
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(seconds: 1));

        // Verifikasi SnackBar Removed
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Removed from Watchlist'), findsOneWidget);

        // Tunggu SnackBar menghilang
        await tester.pump(const Duration(seconds: 5));

        // 8. Kembali ke halaman Watchlist
        await tester.tap(backButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // 9. Verifikasi empty state TV Series (kosong)
        expect(find.byType(TVCard), findsNothing);
        expect(
          find.text('Belum ada TV Series di Watchlist Anda'),
          findsOneWidget,
        );
      },
    );
  });
}
