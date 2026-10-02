import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/main_navigation_screen.dart';
import 'theme/app_theme.dart';
import 'theme/app_theme_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved theme choice
  await AppTheme.loadSavedTheme();

  // Initialize Firebase with the configured options
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase başlatma uyarısı: $e');
  }

  // Set cute translucent system navigation and status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const SweetieNotesApp(),
    ),
  );
}

/// SweetieNotes Application Root
class SweetieNotesApp extends StatelessWidget {
  const SweetieNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeType>(
      valueListenable: AppTheme.themeNotifier,
      builder: (context, currentTheme, _) {
        return MaterialApp(
          title: 'SweetieNotes',
          debugShowCheckedModeBanner: false,
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          theme: AppTheme.themeData,
          home: const MainNavigationScreen(),
        );
      },
    );
  }
}
