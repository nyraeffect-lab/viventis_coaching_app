import 'package:flutter/material.dart';
import 'package:viventis_coaching_app/core/theme/viventis_colors.dart';

class DatenschutzScreen extends StatelessWidget {
  const DatenschutzScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: ViventisColors.cream,
      appBar: AppBar(
        backgroundColor: ViventisColors.navy,
        elevation: 0,
        centerTitle: true,
        title: const Text('Datenschutz'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          final maxHeight = constraints.maxHeight;

          final bool isVeryWide = maxWidth > 900;
          final double contentMaxWidth = isVeryWide
              ? 720.0
              : (maxWidth > 600.0 ? 600.0 : maxWidth);

          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: contentMaxWidth,
                minHeight: maxHeight,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: DefaultTextStyle(
                  style: theme.textTheme.bodyMedium!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Datenschutzhinweise',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Der Schutz deiner personenbezogenen Daten ist uns wichtig. '
                        'In dieser App werden nur die Daten verarbeitet, die für den '
                        'Betrieb des CoachBots und der dargestellten Funktionen notwendig sind.',
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Je nach Nutzung können unter anderem folgende Daten verarbeitet werden:',
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '• Inhaltsdaten aus deinen Coaching-Nachrichten\n'
                        '• Nutzungsdaten (z.B. Datum/Uhrzeit der Nutzung)\n'
                        '• Technische Metadaten des Geräts (z.B. Betriebssystemversion)',
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Die Daten werden ausschliesslich zum Zweck der Bereitstellung '
                        'und Verbesserung des Coaching-Angebots verwendet. Eine Weitergabe '
                        'an Dritte erfolgt nur, sofern dies rechtlich erforderlich ist oder '
                        'du ausdrücklich eingewilligt hast.',
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Bei Fragen zum Datenschutz kannst du dich an folgende Stelle wenden:',
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '[Name Müller]\n'
                        'E-Mail: [E-Mail-Adresse]\n'
                        'Web: https://viventis.net',
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Hinweis: Diese Hinweise sind ein allgemeiner Platzhalter und '
                        'sollten vor dem produktiven Einsatz von einer juristischen Fachperson '
                        'geprüft und ggf. angepasst werden.',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
