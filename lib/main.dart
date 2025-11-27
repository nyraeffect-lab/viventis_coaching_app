import 'package:flutter/material.dart';

// HIVE – PERSISTENZ
import 'package:hive_flutter/hive_flutter.dart';
import 'data/models/coach_session.dart'; // enthält CoachMessage + CoachSession + Adapter-Parts

import 'core/theme/viventis_theme.dart';
import 'features/onboarding/start_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/coaching/coaching_screen.dart';
import 'features/navigation/main_shell.dart' as nav;
import 'features/legal/impressum_screen.dart';
import 'features/legal/datenschutz_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // HIVE INITIALISIEREN
  await Hive.initFlutter();

  // ADAPTER REGISTRIEREN
  Hive.registerAdapter(CoachMessageAdapter());
  Hive.registerAdapter(CoachSessionAdapter());

  // BOX ÖFFNEN (persistenter Speicher)
  await Hive.openBox<CoachSession>('sessions');

  runApp(const ViventisCoachingApp());
}

class ViventisCoachingApp extends StatelessWidget {
  const ViventisCoachingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Viventis Coaching',
      debugShowCheckedModeBanner: false,
      theme: buildViventisTheme(),
      themeMode: ThemeMode.light,
      home: const nav.MainShell(),
      routes: {
        '/start': (context) => const StartScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/coaching': (context) => const CoachingScreen(),
        '/app': (context) => const nav.MainShell(),
        '/impressum': (context) => const ImpressumScreen(),
        '/datenschutz': (context) => const DatenschutzScreen(),
      },
    );
  }
}
