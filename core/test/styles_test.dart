import 'package:core/styles/colors.dart';
import 'package:core/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Should get correct color scheme properties',
      (WidgetTester tester) async {
    expect(kColorScheme.primary, kMikadoYellow);
    expect(kColorScheme.secondary, kPrussianBlue);
    expect(kColorScheme.secondaryContainer, kPrussianBlue);
    expect(kColorScheme.surface, kRichBlack);
    expect(kColorScheme.error, Colors.red);
    expect(kColorScheme.onPrimary, kRichBlack);
    expect(kColorScheme.onSecondary, Colors.white);
    expect(kColorScheme.onSurface, Colors.white);
    expect(kColorScheme.onError, Colors.white);
    expect(kColorScheme.brightness, Brightness.dark);
  });

  testWidgets('Should get correct text theme properties',
      (WidgetTester tester) async {
    expect(kTextTheme.headlineMedium, kHeading5);
    expect(kTextTheme.headlineSmall, kHeading6);
    expect(kTextTheme.labelMedium, kSubtitle);
    expect(kTextTheme.bodyMedium, kBodyText);
  });

  testWidgets('Should verify davysGrey and grey', (WidgetTester tester) async {
    expect(kDavysGrey, const Color(0xFF4B5358));
    expect(kGrey, const Color(0xFF303030));
    expect(kOxfordBlue, const Color(0xFF001D3D));
  });
}
