import 'package:flutter/material.dart';
import 'package:viventis_coaching_app/core/theme/viventis_colors.dart';

class ImpressumScreen extends StatelessWidget {
  const ImpressumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: ViventisColors.cream,
      appBar: AppBar(
        backgroundColor: ViventisColors.navy,
        elevation: 0,
        centerTitle: true,
        title: const Text('Impressum'),
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
                        'Impressum',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Verantwortlich für den Inhalt dieser App:',
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Viventis Coaching\n'
                        'Herr/Frau [Name Müller]\n'
                        'Adresse\n'
                        'PLZ Ort\n'
                        'Schweiz',
                      ),
                      const SizedBox(height: 16),
                      const Text('Kontakt:'),
                      const SizedBox(height: 4),
                      const Text(
                        'Telefon: [Telefonnummer]\n'
                        'E-Mail: [E-Mail-Adresse]\n'
                        'Web: https://viventis.net',
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Hinweis: Dies ist eine Coaching-App und ersetzt keine '
                        'medizinische oder psychotherapeutische Behandlung.',
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
