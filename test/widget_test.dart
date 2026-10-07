import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sweetie_notes/main.dart';

void main() {
  testWidgets('SweetieNotes app smoke test', (WidgetTester tester) async {
    // Build SweetieNotes app
    await tester.pumpWidget(const SweetieNotesApp());
    await tester.pump();

    // Verify search bar placeholder "Ara..." is present
    expect(find.text('Ara...'), findsOneWidget);

    // Verify mock note titles are present
    expect(find.textContaining('Alışveriş Listesi'), findsOneWidget);
  });

  testWidgets('Open side drawer and verify Hesap and Çöp Kutusu',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SweetieNotesApp());
    await tester.pump();

    // Tap on the 3-line hamburger menu icon in the search bar
    final menuIcon = find.byIcon(Icons.menu_rounded);
    expect(menuIcon, findsOneWidget);
    await tester.tap(menuIcon);
    await tester.pumpAndSettle();

    // Verify Side Drawer opened with "Hesap" and "Çöp Kutusu" options
    expect(find.text('Hesap'), findsOneWidget);
    expect(find.text('Çöp Kutusu'), findsOneWidget);

    // Tap on "Çöp Kutusu"
    await tester.tap(find.text('Çöp Kutusu'));
    await tester.pumpAndSettle();

    // Verify TrashScreen is displayed
    expect(find.text('Çöp kutusu boş ♡'), findsOneWidget);
  });

  testWidgets('Tap settings icon in top right opens SettingsScreen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SweetieNotesApp());
    await tester.pump();

    // Tap settings icon in the top right of the search bar
    final settingsIcon = find.byKey(const Key('search_bar_settings_button'));
    expect(settingsIcon, findsOneWidget);
    await tester.tap(settingsIcon);
    await tester.pumpAndSettle();

    // Verify SettingsScreen opened
    expect(find.text('Ayarlar'), findsWidgets);
    expect(find.text('Görünüm ve tercihlerin'), findsOneWidget);
  });
}
