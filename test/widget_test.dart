import 'package:beyond_platforms/app/portfolio_app.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final width in [390.0, 834.0, 1440.0]) {
    testWidgets('Portfolio and playground fit at ${width.toInt()} px', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(Size(width, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const PortfolioApp());
      await tester.pumpAndSettle();

      expect(
        find.text('One codebase.\nLimitless experiences.'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);

      if (width == 390) {
        final copyright = find.text('© 2026 Andreea Rosca');
        expect(tester.getCenter(copyright).dx, closeTo(width / 2, 0.01));
      }

      final android = find.widgetWithText(InkWell, 'Android');
      await tester.ensureVisible(android);
      await tester.tap(android);
      await tester.pumpAndSettle();
      expect(
        find.ancestor(
          of: android,
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is Semantics && widget.properties.selected == true,
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel('Android Flutter Playground preview'),
        findsOneWidget,
      );
      if (width == 390) {
        expect(
          find.bySemanticsLabel('Web Flutter Playground preview'),
          findsNothing,
        );
      } else {
        final web = tester.getRect(
          find.bySemanticsLabel('Web Flutter Playground preview'),
        );
        final ios = tester.getRect(
          find.bySemanticsLabel('iOS Flutter Playground preview'),
        );
        final androidPreview = tester.getRect(
          find.bySemanticsLabel('Android Flutter Playground preview'),
        );
        expect(web.overlaps(ios), isTrue);
        expect(web.overlaps(androidPreview), isTrue);
        expect(ios.left, lessThan(web.left));
        expect(androidPreview.right, greaterThan(web.right));
        expect(ios.top, greaterThan(androidPreview.top));
      }
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('The theme control switches between both palettes', (
    tester,
  ) async {
    await tester.pumpWidget(const PortfolioApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Switch to light mode'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Switch to dark mode'), findsOneWidget);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.light,
    );
  });
}
