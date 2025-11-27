import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viventis_coaching_app/core/theme/viventis_colors.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  static const _storageKey = 'journal_entries_v1';

  final List<_JournalEntry> _entries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_storageKey) ?? [];

    setState(() {
      _entries
        ..clear()
        ..addAll(
          rawList.map((raw) {
            final json = jsonDecode(raw) as Map<String, dynamic>;
            return _JournalEntry.fromJson(json);
          }),
        )
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      _loading = false;
    });
  }

  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = _entries.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_storageKey, rawList);
  }

  Future<void> _addEntry() async {
    final controller = TextEditingController();
    final theme = Theme.of(context);

    final text = await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Neuer Eintrag',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                autofocus: true,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText:
                      'Notiere hier deine Erkenntnis, ein Gefühl oder einen wichtigen Moment aus dem Coaching.',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(null),
                    child: const Text('Abbrechen'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).pop(controller.text.trim()),
                    child: const Text('Speichern'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (text == null || text.isEmpty) return;

    setState(() {
      _entries.add(
        _JournalEntry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          createdAt: DateTime.now(),
          text: text,
        ),
      );
      _entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });

    await _saveEntries();
  }

  Future<void> _deleteEntry(_JournalEntry entry) async {
    setState(() {
      _entries.removeWhere((e) => e.id == entry.id);
    });
    await _saveEntries();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: ViventisColors.cream,
      appBar: AppBar(
        backgroundColor: ViventisColors.navy,
        elevation: 0,
        centerTitle: true,
        title: const Text('Journal'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = constraints.maxWidth;
                final maxHeight = constraints.maxHeight;

                final bool isVeryWide = maxWidth > 900;

                // Inhalt auf breiten Screens begrenzen
                final double contentMaxWidth = isVeryWide
                    ? 720.0
                    : (maxWidth > 600.0 ? 600.0 : maxWidth);

                if (_entries.isEmpty) {
                  // Leerer Zustand: zentriert, mit Scroll, Max-Breite
                  return Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: contentMaxWidth,
                        minHeight: maxHeight,
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 24,
                        ),
                        child: Center(
                          child: Text(
                            'Hier kannst du einfache Einträge, Erkenntnisse '
                            'oder wichtige Dialoge mit dem CoachBot festhalten.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                // Liste der Einträge: mittig mit maxWidth, scrollt normal
                return Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: contentMaxWidth,
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      itemCount: _entries.length,
                      itemBuilder: (context, index) {
                        final entry = _entries[index];
                        return _JournalEntryCard(
                          entry: entry,
                          onDelete: () => _deleteEntry(entry),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addEntry,
        icon: const Icon(Icons.add),
        label: const Text('Eintrag'),
        backgroundColor: ViventisColors.navy,
      ),
    );
  }
}

class _JournalEntry {
  _JournalEntry({
    required this.id,
    required this.createdAt,
    required this.text,
  });

  final String id;
  final DateTime createdAt;
  final String text;

  factory _JournalEntry.fromJson(Map<String, dynamic> json) {
    return _JournalEntry(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'text': text,
      };
}

class _JournalEntryCard extends StatelessWidget {
  const _JournalEntryCard({
    required this.entry,
    required this.onDelete,
  });

  final _JournalEntry entry;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = _formatDate(entry.createdAt);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    date,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Löschen',
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              entry.text,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    // simple, deutsch angehaucht
    return '${dt.day.toString().padLeft(2, '0')}.'
        '${dt.month.toString().padLeft(2, '0')}.'
        '${dt.year}  •  '
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }
}
