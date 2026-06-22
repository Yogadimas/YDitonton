import 'package:core/styles/colors.dart';
import 'package:core/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Should get correct color scheme properties',
      (WidgetTester tester) async {
    expect(colorScheme.primary, mikadoYellow);
    expect(colorScheme.secondary, prussianBlue);
    expect(colorScheme.secondaryContainer, prussianBlue);
    expect(colorScheme.surface, richBlack);
    expect(colorScheme.error, Colors.red);
    expect(colorScheme.onPrimary, richBlack);
    expect(colorScheme.onSecondary, Colors.white);
    expect(colorScheme.onSurface, Colors.white);
    expect(colorScheme.onError, Colors.white);
    expect(colorScheme.brightness, Brightness.dark);
  });

  testWidgets('Should get correct text theme properties',
      (WidgetTester tester) async {
    expect(textTheme.headlineMedium, heading5);
    expect(textTheme.headlineSmall, heading6);
    expect(textTheme.labelMedium, subtitle);
    expect(textTheme.bodyMedium, bodyText);
  });

  testWidgets('Should verify davysGrey and grey', (WidgetTester tester) async {
    expect(davysGrey, const Color(0xFF4B5358));
    expect(grey, const Color(0xFF303030));
    expect(oxfordBlue, const Color(0xFF001D3D));
  });
}
