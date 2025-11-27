import 'package:flutter/material.dart';

import 'package:viventis_coaching_app/core/theme/viventis_colors.dart';
import 'package:viventis_coaching_app/features/onboarding/start_screen.dart';
import 'package:viventis_coaching_app/features/dashboard/dashboard_screen.dart';
import 'package:viventis_coaching_app/features/coaching/coaching_screen.dart';
import 'package:viventis_coaching_app/features/journal/journal_screen.dart';

/// Haupt-Shell der App mit Bottom-Navigation.
///
/// Tabs:
/// 0 – Start
/// 1 – Dashboard
/// 2 – Journal (Tagebuch / Erkenntnisse)
/// 3 – Bot (Coaching-Session)
class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    this.initialIndex = 0,
  });

  /// Welcher Tab beim Start aktiv sein soll (0–3).
  final int initialIndex;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    // Clamp stellt sicher, dass wir immer im gültigen Bereich 0–3 starten.
    _currentIndex = widget.initialIndex.clamp(0, 3);
  }

  void _onTabSelected(int index) {
    if (index == _currentIndex) return;
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final pages = <Widget>[
      // Start: nutzt Callback, um in den Dashboard-Tab zu springen.
      StartScreen(
        onStartPressed: () => _onTabSelected(1),
      ),
      const DashboardScreen(),
      const JournalScreen(), // Journal-Tab
      const CoachingScreen(),
    ];

    return Scaffold(
      backgroundColor: ViventisColors.cream,
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
        selectedItemColor: ViventisColors.navy,
        unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.6),
        showUnselectedLabels: true,
        onTap: _onTabSelected,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Start',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Journal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Bot',
          ),
        ],
      ),
    );
  }
}
