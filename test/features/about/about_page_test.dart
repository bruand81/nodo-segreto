import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scout_code/features/about/about_page.dart';

void main() {
  testWidgets('AboutPage mostra titolo, credit e loghi', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: AboutPage()));
    await tester.pump();

    expect(find.text('Nodo Segreto'), findsOneWidget);
    expect(find.textContaining('Sviluppato da Andrea Bruno'), findsOneWidget);
    expect(find.textContaining('gruppo Avellino 1'), findsOneWidget);
    expect(find.text('www.bruand81.it'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName.contains('AVELLINO1'),
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName.contains('bruand81'),
      ),
      findsOneWidget,
    );
  });
}
