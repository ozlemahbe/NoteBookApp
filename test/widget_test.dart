import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sweetie_notes/main.dart';

void main() {
  testWidgets('SweetieNotes app smoke test', (WidgetTester tester) async {
    // Build SweetieNotes app
    await tester.pumpWidget(const SweetieNotesApp());
    await tester.pump();

    // Verify search bar placeholder "Ara" is present
    expect(find.text('Ara'), findsOneWidget);

    // Verify mock note titles are present
    expect(find.textContaining('Alışveriş Listesi'), findsOneWidget);
  });

  testWidgets('Open side drawer and navigate to Pastel Defter auth screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SweetieNotesApp());
    await tester.pump();

    // Tap on the 3-line hamburger menu icon in the search bar
    final menuIcon = find.byIcon(Icons.menu_rounded);
    expect(menuIcon, findsOneWidget);
    await tester.tap(menuIcon);
    await tester.pumpAndSettle();

    // Verify Side Drawer opened with "Hesap" option
    expect(find.text('Hesap'), findsOneWidget);
    expect(find.text('Pastel Defter'), findsOneWidget);

    // Tap on "Hesap"
    await tester.tap(find.text('Hesap'));
    await tester.pumpAndSettle();

    // Verify AuthScreen (Pastel Defter) is displayed
    expect(find.text('Pastel Defter'), findsOneWidget);
    expect(find.text('Notların ve defterlerin hesabında saklanır, hiçbir şey kaybolmaz.'), findsOneWidget);
    expect(find.text('Giriş yap'), findsWidgets);
    expect(find.text('Kayıt ol'), findsOneWidget);
    expect(find.text('E-posta'), findsOneWidget);
    expect(find.text('Şifre'), findsOneWidget);
  });
}
