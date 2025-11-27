import 'package:flutter/material.dart';
import 'package:viventis_coaching_app/core/theme/viventis_colors.dart';

class AboScreen extends StatelessWidget {
  const AboScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: ViventisColors.cream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('CoachBot-Stufen'),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ViventisColors.navy,
              ViventisColors.navy,
              ViventisColors.cream,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.35, 1.0],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              final maxHeight = constraints.maxHeight;

              final bool isVeryWide = maxWidth > 1100;
              final bool isWide = maxWidth > 900;
              final bool isCompact =
                  maxHeight < 640 || maxWidth < 380;

              final double verticalPadding = isCompact ? 16.0 : 24.0;
              const double horizontalPadding = 24.0;

              final double contentMaxWidth = isVeryWide
                  ? 1040.0
                  : (maxWidth > 900.0 ? 900.0 : maxWidth);

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: contentMaxWidth,
                      // damit der Inhalt auf großen Displays nicht oben klebt
                      minHeight: maxHeight - (verticalPadding * 2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(theme, isCompact),
                        const SizedBox(height: 24),
                        _buildIntroCard(theme),
                        const SizedBox(height: 24),
                        if (isWide)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _AboTierCard(
                                  tierLabel: 'Stufe 1',
                                  name: 'Kompass-Testphase',
                                  price: '7 Tage kostenlos',
                                  highlightColor:
                                      ViventisColors.accentYellow.withOpacity(
                                    0.9,
                                  ),
                                  bulletPoints: const [
                                    'Finde deinen aktuellen Standort im Leben.',
                                    'Teste, wie sich der CoachBot anfühlt.',
                                    'Entscheidungschaos sortieren – erste Klarheit.',
                                  ],
                                  badgeText: 'Empfohlen zum Start',
                                  themeAccent: ViventisColors.headlineGreen,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: _AboTierCard(
                                  tierLabel: 'Stufe 2',
                                  name: 'Innere Ausrichtung',
                                  price: 'CHF 15 / Monat',
                                  highlightColor: Colors.tealAccent,
                                  bulletPoints: const [
                                    'Regelmäßige Selbstcoaching-Impulse.',
                                    'Fokus auf Stille, Herz und Erdung.',
                                    'Wöchentlicher Rahmen für deine Ausrichtung.',
                                  ],
                                  badgeText: 'Basisbegleitung',
                                  themeAccent: ViventisColors.navy,
                                ),
                              ),
                            ],
                          )
                        else ...[
                          _AboTierCard(
                            tierLabel: 'Stufe 1',
                            name: 'Kompass-Testphase',
                            price: '7 Tage kostenlos',
                            highlightColor:
                                ViventisColors.accentYellow.withOpacity(0.9),
                            bulletPoints: const [
                              'Finde deinen aktuellen Standort im Leben.',
                              'Teste, wie sich der CoachBot anfühlt.',
                              'Entscheidungschaos sortieren – erste Klarheit.',
                            ],
                            badgeText: 'Empfohlen zum Start',
                            themeAccent: ViventisColors.headlineGreen,
                          ),
                          const SizedBox(height: 16),
                          _AboTierCard(
                            tierLabel: 'Stufe 2',
                            name: 'Innere Ausrichtung',
                            price: 'CHF 15 / Monat',
                            highlightColor: Colors.tealAccent,
                            bulletPoints: const [
                              'Regelmäßige Selbstcoaching-Impulse.',
                              'Fokus auf Stille, Herz und Erdung.',
                              'Wöchentlicher Rahmen für deine Ausrichtung.',
                            ],
                            badgeText: 'Basisbegleitung',
                            themeAccent: ViventisColors.navy,
                          ),
                        ],
                        const SizedBox(height: 20),
                        if (isWide)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _AboTierCard(
                                  tierLabel: 'Stufe 3',
                                  name: 'Wachstumspfad',
                                  price: 'CHF 39 / 3 Monate',
                                  highlightColor:
                                      ViventisColors.headlineGreen.withOpacity(
                                    0.9,
                                  ),
                                  bulletPoints: const [
                                    'Monatsfokus auf ein Lebensthema.',
                                    'Vertiefende Fragen, Übungen & Reflexion.',
                                    'Dein persönlicher CoachBot-Prompt wird mit dir geschärft.',
                                  ],
                                  badgeText: 'Intensivere Begleitung',
                                  themeAccent: ViventisColors.navy,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: _AboTierCard(
                                  tierLabel: 'Stufe 4',
                                  name: 'Wandlung',
                                  price: 'CHF 89 / 6 Monate',
                                  highlightColor: Colors.deepOrangeAccent,
                                  bulletPoints: const [
                                    'Tiefe Schattenarbeit & innere Blockaden anpacken.',
                                    'Vertiefungspfade in den 5 Kompass-Bereichen.',
                                    '10 % Rabatt auf Viventis-Angebote & Retreats.',
                                  ],
                                  badgeText: 'Für echte Transformation',
                                  themeAccent: Colors.deepOrange,
                                ),
                              ),
                            ],
                          )
                        else ...[
                          _AboTierCard(
                            tierLabel: 'Stufe 3',
                            name: 'Wachstumspfad',
                            price: 'CHF 39 / 3 Monate',
                            highlightColor: ViventisColors.headlineGreen
                                .withOpacity(0.9),
                            bulletPoints: const [
                              'Monatsfokus auf ein Lebensthema.',
                              'Vertiefende Fragen, Übungen & Reflexion.',
                              'Dein persönlicher CoachBot-Prompt wird mit dir geschärft.',
                            ],
                            badgeText: 'Intensivere Begleitung',
                            themeAccent: ViventisColors.navy,
                          ),
                          const SizedBox(height: 16),
                          _AboTierCard(
                            tierLabel: 'Stufe 4',
                            name: 'Wandlung',
                            price: 'CHF 89 / 6 Monate',
                            highlightColor: Colors.deepOrangeAccent,
                            bulletPoints: const [
                              'Tiefe Schattenarbeit & innere Blockaden anpacken.',
                              'Vertiefungspfade in den 5 Kompass-Bereichen.',
                              '10 % Rabatt auf Viventis-Angebote & Retreats.',
                            ],
                            badgeText: 'Für echte Transformation',
                            themeAccent: Colors.deepOrange,
                          ),
                        ],
                        const SizedBox(height: 24),
                        _buildFooterHint(theme),
                        const SizedBox(height: 8),
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

  Widget _buildHeader(ThemeData theme, bool isCompact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: Colors.white.withOpacity(0.24),
            ),
          ),
          child: const Text(
            'Der Innere Kompass – CoachBot-Stufen',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Wähle den Rahmen,\nwie nah dich der CoachBot begleitet.',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontSize: isCompact ? 22 : 26,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Alle Stufen bauen aufeinander auf – von erster Orientierung '
          'bis zu tiefer Wandlung.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white.withOpacity(0.9),
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildIntroCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.09),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(0.18),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Hinweis: In dieser App siehst du zunächst nur eine Vorschau der '
              'Stufen. Die konkreten Buchungen laufen aktuell noch über '
              'viventis.net. Später kann dein Coach hier direkt deine Stufe '
              'freischalten.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.9),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterHint(ThemeData theme) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        'Nichts davon ist ein Muss. Der CoachBot soll dich entlasten, '
        'nicht zusätzlich unter Druck setzen.',
        textAlign: TextAlign.center,
        style: theme.textTheme.bodySmall?.copyWith(
          color: Colors.white.withOpacity(0.85),
          height: 1.4,
        ),
      ),
    );
  }
}

class _AboTierCard extends StatelessWidget {
  final String tierLabel;
  final String name;
  final String price;
  final List<String> bulletPoints;
  final String badgeText;
  final Color highlightColor;
  final Color themeAccent;

  const _AboTierCard({
    required this.tierLabel,
    required this.name,
    required this.price,
    required this.bulletPoints,
    required this.badgeText,
    required this.highlightColor,
    required this.themeAccent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top-Badge (Stufe)
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: themeAccent.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  tierLabel,
                  style: TextStyle(
                    color: themeAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: highlightColor.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    color: themeAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: themeAccent,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            price,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black.withOpacity(0.85),
            ),
          ),
          const SizedBox(height: 12),
          ...bulletPoints.map(
            (bp) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 18,
                    color: themeAccent.withOpacity(0.9),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      bp,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
