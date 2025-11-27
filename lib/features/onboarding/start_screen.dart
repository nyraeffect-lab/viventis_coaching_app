import 'package:flutter/material.dart';
import 'package:viventis_coaching_app/core/theme/viventis_colors.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({
    super.key,
    this.onStartPressed,
  });

  /// Callback, um z.B. im MainShell direkt in den Dashboard-Tab zu springen.
  final VoidCallback? onStartPressed;

  void _goToDashboard(BuildContext context) {
    if (onStartPressed != null) {
      onStartPressed!();
    } else {
      Navigator.of(context).pushReplacementNamed('/dashboard');
    }
  }

  void _openImpressum(BuildContext context) {
    Navigator.of(context).pushNamed('/impressum');
  }

  void _openDatenschutz(BuildContext context) {
    Navigator.of(context).pushNamed('/datenschutz');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: ViventisColors.navy,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ViventisColors.navy,
              Color(0xFF022545),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              final maxHeight = constraints.maxHeight;

              // Breiter Screen = Fold/Z/Tablet → Content nicht unendlich breit ziehen
              final bool isVeryWide = maxWidth > 700;
              final bool isSmallWidth = maxWidth < 380;
              final bool isVerySmallHeight = maxHeight < 600;

              final double verticalPadding = isVerySmallHeight ? 16.0 : 32.0;
              final double logoSize = isSmallWidth ? 72.0 : 96.0;
              final double headlineSize = isSmallWidth ? 22.0 : 26.0;

              final double contentMaxWidth = isVeryWide
                  ? 620.0
                  : (maxWidth > 520.0 ? 520.0 : maxWidth);

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: verticalPadding,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: contentMaxWidth,
                      // Damit der Inhalt auf hohen Displays nicht „klebt“
                      minHeight: maxHeight - (verticalPadding * 2),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Logo + Branding oben
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/logo/viventis_compass.png',
                              width: logoSize,
                              height: logoSize,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Viventis Coaching',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Headline
                        Text(
                          'Willkommen beim Viventis CoachBot',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontSize: headlineSize,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Subline
                        Text(
                          'Hier kannst du mit einem klaren, strukturierten CoachBot '
                          'an deinen Themen arbeiten – Schritt für Schritt, '
                          'in deinem Tempo.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.86),
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // GELBER Zum-Dashboard-Button im Viventis-Stil
                        FilledButton(
                          onPressed: () => _goToDashboard(context),
                          style: FilledButton.styleFrom(
                            backgroundColor: ViventisColors.accentYellow,
                            foregroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(
                              vertical: isSmallWidth ? 10 : 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            elevation: 2,
                          ),
                          child: const Text('Zum Dashboard'),
                        ),

                        const SizedBox(height: 24),

                        // Kurze Erklärung zur Navigation
                        Container(
                          padding: EdgeInsets.all(isSmallWidth ? 14 : 16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.08),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'So nutzt du die App:',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const _StartHintRow(
                                icon: Icons.home_outlined,
                                text:
                                    'Start – Überblick und Einstieg in den CoachBot.',
                              ),
                              const SizedBox(height: 6),
                              const _StartHintRow(
                                icon: Icons.dashboard_outlined,
                                text:
                                    'Dashboard – später: Ton-Regler, Nutzungstage '
                                    'und deine wichtigsten Erkenntnisse.',
                              ),
                              const SizedBox(height: 6),
                              const _StartHintRow(
                                icon: Icons.public,
                                text:
                                    'Viventis – Zugang zu den Viventis-Webseiten.',
                              ),
                              const SizedBox(height: 6),
                              const _StartHintRow(
                                icon: Icons.chat_bubble_outline,
                                text:
                                    'Bot – direkt in das Gespräch mit dem CoachBot einsteigen.',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Impressum / Datenschutz
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () => _openImpressum(context),
                              style: TextButton.styleFrom(
                                foregroundColor: ViventisColors.accentYellow,
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              child: const Text('Impressum'),
                            ),
                            const SizedBox(width: 16),
                            TextButton(
                              onPressed: () => _openDatenschutz(context),
                              style: TextButton.styleFrom(
                                foregroundColor: ViventisColors.accentYellow,
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              child: const Text('Datenschutz'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _StartHintRow extends StatelessWidget {
  const _StartHintRow({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.white.withOpacity(0.9),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.9),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
