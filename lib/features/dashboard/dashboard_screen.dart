import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:viventis_coaching_app/core/theme/viventis_colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  /// Einfaches lokales State für den CoachBot-Ton (0 = warm, 1 = direkt).
  double _toneValue = 0.3;

  void _openCoachBot() {
    // Navigiert auf den Coaching-Screen
    Navigator.of(context).pushNamed('/coaching');
  }

  Future<void> _openViventisWebsite() async {
    final uri = Uri.parse('https://viventis.net');

    final success = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Die Viventis-Webseite konnte nicht geöffnet werden.'),
        ),
      );
    }
  }

  String _toneLabel() {
    if (_toneValue < 0.33) {
      return 'eher warm & einfühlsam';
    } else if (_toneValue < 0.66) {
      return 'ausgewogen';
    } else {
      return 'eher direkt & klar';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: ViventisColors.cream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Dashboard'),
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

              final bool isVeryWide = maxWidth > 900;
              final bool isWide = maxWidth > 720;
              final bool isCompact =
                  maxHeight < 640 || maxWidth < 380;

              final double verticalPadding = isCompact ? 16.0 : 24.0;

              // Auf sehr breiten Displays (Fold/Z, Tablets) Content begrenzen
              final double contentMaxWidth = isVeryWide
                  ? 960.0
                  : (maxWidth > 720.0 ? 720.0 : maxWidth);

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: verticalPadding,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: contentMaxWidth,
                      // Verhindert, dass der Inhalt oben „klebt“ auf hohen Screens
                      minHeight: maxHeight - (verticalPadding * 2),
                    ),
                    child: _buildContent(theme, isWide, isCompact),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    ThemeData theme,
    bool isWide,
    bool isCompact,
  ) {
    final headlineStyle = theme.textTheme.headlineMedium?.copyWith(
      color: Colors.white,
      fontSize: isCompact ? 22 : 26,
      height: 1.2,
    );

    final bodySmallStyle = theme.textTheme.bodySmall?.copyWith(
      color: Colors.white.withOpacity(0.85),
    );

    final double topSpacing = isCompact ? 8.0 : 12.0;
    final double sectionSpacing = isCompact ? 20.0 : 28.0;
    final double betweenCardsSpacing = isCompact ? 12.0 : 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: topSpacing),

        // kleines Label oben
        Align(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
              ),
            ),
            child: const Text(
              'Viventis Übersicht',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        SizedBox(height: isCompact ? 16 : 20),

        Text(
          'Dein Einstieg in das Viventis Coaching',
          textAlign: TextAlign.center,
          style: headlineStyle,
        ),

        const SizedBox(height: 12),

        Text(
          'Von hier aus startest du den CoachBot und siehst die Angebote.',
          textAlign: TextAlign.center,
          style: bodySmallStyle,
        ),

        SizedBox(height: sectionSpacing),

        // Ton-Regler-Card für den CoachBot
        _ToneCard(
          value: _toneValue,
          label: _toneLabel(),
          onChanged: (v) {
            setState(() {
              _toneValue = v;
              // Später kann dieser Wert an den Backend-Call übergeben werden.
            });
          },
        ),

        SizedBox(height: sectionSpacing),

        // Haupt-Kacheln (CoachBot + Preise + Viventis)
        if (isWide) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _DashboardCard(
                  title: 'CoachBot starten',
                  description:
                      'Direkt ins Gespräch mit dem CoachBot einsteigen '
                      'und an deinen Themen arbeiten.',
                  icon: Icons.chat_bubble_outline,
                  onTap: _openCoachBot,
                ),
              ),
              SizedBox(width: betweenCardsSpacing),
              Expanded(
                child: _DashboardCard(
                  title: 'Preise & Angebote',
                  description:
                      'Überblick über Coaching-Pakete und Konditionen '
                      'von Viventis Coaching.',
                  icon: Icons.price_change_outlined,
                  child: _buildPriceList(theme),
                ),
              ),
            ],
          ),
          SizedBox(height: betweenCardsSpacing),
          _DashboardCard(
            title: 'Viventis-Webseite',
            description:
                'Direkt zu viventis.net – zum Beispiel zu Blog, Angeboten '
                'oder Login.',
            icon: Icons.public,
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _openViventisWebsite,
                icon: const Icon(Icons.open_in_new),
                label: const Text('Viventis.net öffnen'),
                style: TextButton.styleFrom(
                  foregroundColor: ViventisColors.headlineGreen,
                ),
              ),
            ),
          ),
        ] else ...[
          _DashboardCard(
            title: 'CoachBot starten',
            description:
                'Direkt ins Gespräch mit dem CoachBot einsteigen '
                'und an deinen Themen arbeiten.',
            icon: Icons.chat_bubble_outline,
            onTap: _openCoachBot,
          ),
          SizedBox(height: betweenCardsSpacing),
          _DashboardCard(
            title: 'Preise & Angebote',
            description:
                'Überblick über Coaching-Pakete und Konditionen '
                'von Viventis Coaching.',
            icon: Icons.price_change_outlined,
            child: _buildPriceList(theme),
          ),
          SizedBox(height: betweenCardsSpacing),
          _DashboardCard(
            title: 'Viventis-Webseite',
            description:
                'Direkt zu viventis.net – zum Beispiel zu Blog, Angeboten '
                'oder Login.',
            icon: Icons.public,
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _openViventisWebsite,
                icon: const Icon(Icons.open_in_new),
                label: const Text('Viventis.net öffnen'),
                style: TextButton.styleFrom(
                  foregroundColor: ViventisColors.headlineGreen,
                ),
              ),
            ),
          ),
        ],

        SizedBox(height: sectionSpacing),

        Align(
          alignment: Alignment.center,
          child: Text(
            'Tipp: Über den Tab „Bot“ unten kannst du den CoachBot jederzeit starten.',
            textAlign: TextAlign.center,
            style: bodySmallStyle,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildPriceList(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const _PriceRow(
          label: 'Einzelcoaching (50 Min.)',
          value: 'CHF  ***',
        ),
        const SizedBox(height: 4),
        const _PriceRow(
          label: 'Paket 3 Sessions',
          value: 'CHF  ***',
        ),
        const SizedBox(height: 4),
        const _PriceRow(
          label: 'Firmen-Coaching',
          value: 'auf Anfrage',
        ),
        const SizedBox(height: 12),
        Text(
          'Der Innere Kompass.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.black.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

class _ToneCard extends StatelessWidget {
  const _ToneCard({
    required this.value,
    required this.label,
    required this.onChanged,
  });

  final double value;
  final String label;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
          Text(
            'CoachBot-Ton',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: ViventisColors.headlineGreen,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Stelle ein, wie warm oder direkt der CoachBot klingen soll.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.black.withOpacity(0.75),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('warm'),
              Expanded(
                child: Slider(
                  value: value,
                  onChanged: onChanged,
                  min: 0,
                  max: 1,
                  activeColor: ViventisColors.accentYellow,
                  inactiveColor: Colors.grey.shade300,
                ),
              ),
              const Text('direkt'),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: ViventisColors.headlineGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.title,
    required this.description,
    required this.icon,
    this.onTap,
    this.child,
  });

  final String title;
  final String description;
  final IconData icon;
  final VoidCallback? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final card = Container(
      padding: const EdgeInsets.all(20),
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
          Icon(
            icon,
            size: 28,
            color: ViventisColors.headlineGreen,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: ViventisColors.headlineGreen,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.4,
            ),
          ),
          if (child != null) ...[
            const SizedBox(height: 8),
            child!,
          ],
        ],
      ),
    );

    if (onTap == null) {
      return card;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: card,
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
