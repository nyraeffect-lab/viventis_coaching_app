import 'package:flutter/material.dart';
import 'package:viventis_coaching_app/core/theme/viventis_colors.dart';
import 'package:viventis_coaching_app/data/models/coach_session.dart';
import 'package:viventis_coaching_app/data/repositories/coach_session_repository.dart';
import 'package:viventis_coaching_app/data/repositories/coach_api_service.dart';

class CoachingScreen extends StatefulWidget {
  const CoachingScreen({super.key});

  @override
  State<CoachingScreen> createState() => _CoachingScreenState();
}

class _CoachingScreenState extends State<CoachingScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final CoachApiService _api = CoachApiService();

  // 🔥 NEU: Hive-Repository statt SharedPreferences
  final CoachSessionRepository _sessionRepo = HiveCoachSessionRepository();

  CoachSession? _currentSession;
  bool _isSending = false;
  bool _loadingSession = true;

  @override
  void initState() {
    super.initState();
    _loadInitialSession();
  }

  Future<void> _loadInitialSession() async {
    final last = await _sessionRepo.loadLastSession();

    if (!mounted) return;

    if (last != null) {
      setState(() {
        _currentSession = last;
        _loadingSession = false;
      });
    } else {
      final newSession = _createNewSessionWithWelcome();
      await _sessionRepo.saveSession(newSession);

      if (!mounted) return;
      setState(() {
        _currentSession = newSession;
        _loadingSession = false;
      });
    }

    _scrollAfterBuild();
  }

  CoachSession _createNewSessionWithWelcome() {
    final now = DateTime.now();
    final welcomeMessage = CoachMessage(
      role: 'coach',
      text: 'Willkommen beim Viventis CoachBot. '
          'Womit möchtest du heute beginnen?',
      createdAt: now,
    );

    return CoachSession(
      id: now.microsecondsSinceEpoch.toString(),
      startedAt: now,
      updatedAt: now,
      messages: [welcomeMessage],
    );
  }

  Future<void> _startNewSession() async {
    final session = _createNewSessionWithWelcome();
    await _sessionRepo.saveSession(session);

    if (!mounted) return;
    setState(() {
      _currentSession = session;
    });

    _scrollAfterBuild();
  }

  Future<void> _openSessionPicker() async {
    final sessions = await _sessionRepo.loadAllSessions();
    if (!mounted || sessions.isEmpty) return;

    // Neueste oben
    sessions.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    final selected = await showModalBottomSheet<CoachSession>(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return SafeArea(
          child: ListView.separated(
            itemCount: sessions.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final s = sessions[index];
              final date = _formatDate(s.startedAt.toLocal());
              final subtitle = '$date · ${s.messages.length} Nachrichten';

              return ListTile(
                leading: const Icon(Icons.chat_bubble_outline),
                title: Text('Sitzung ${sessions.length - index}'),
                subtitle: Text(
                  subtitle,
                  style: theme.textTheme.bodySmall,
                ),
                onTap: () => Navigator.of(context).pop(s),
              );
            },
          ),
        );
      },
    );

    if (selected != null && mounted) {
      setState(() {
        _currentSession = selected;
      });
      _scrollAfterBuild();
    }
  }

  Future<void> _saveSession(CoachSession session) async {
    await _sessionRepo.saveSession(session);
  }

  Future<void> _handleSend() async {
    if (_isSending || _currentSession == null) return;

    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();

    final now = DateTime.now();
    var session = _currentSession!;

    final userMessage = CoachMessage(
      role: 'user',
      text: text,
      createdAt: now,
    );

    // User-Nachricht hinzufügen
    session = session.copyWith(
      updatedAt: now,
      messages: [...session.messages, userMessage],
    );

    setState(() {
      _currentSession = session;
      _isSending = true;
    });

    _scrollAfterBuild();
    await _saveSession(session);

    try {
      // History für den Worker aus der aktuellen Session
      final history = session.messages
          .map(
            (m) => {
              'role': m.role,
              'text': m.text,
            },
          )
          .toList();

      final reply = await _api.sendMessage(
        message: text,
        history: history,
      );

      final replyMessage = CoachMessage(
        role: 'coach',
        text: reply,
        createdAt: DateTime.now(),
      );

      final updatedSession = session.copyWith(
        updatedAt: DateTime.now(),
        messages: [...session.messages, replyMessage],
      );

      if (!mounted) return;

      setState(() {
        _currentSession = updatedSession;
      });

      _scrollAfterBuild();
      await _saveSession(updatedSession);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Senden: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  void _scrollAfterBuild() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 80,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();
    return '$d.$m.$y';
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _api.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_loadingSession || _currentSession == null) {
      return Scaffold(
        backgroundColor: ViventisColors.cream,
        appBar: AppBar(
          title: const Text('Coaching-Session'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final session = _currentSession!;
    final sessionDate = _formatDate(session.startedAt.toLocal());
    final msgCount = session.messages.length;

    return Scaffold(
      backgroundColor: ViventisColors.cream,
      appBar: AppBar(
        title: const Text('Coaching-Session'),
        actions: [
          IconButton(
            tooltip: 'Ältere Sitzung laden',
            icon: const Icon(Icons.history),
            onPressed: _openSessionPicker,
          ),
          IconButton(
            tooltip: 'Neue Sitzung starten',
            icon: const Icon(Icons.add_comment_outlined),
            onPressed: _startNewSession,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          final maxHeight = constraints.maxHeight;

          final bool isVeryWide = maxWidth > 900;
          final bool isCompactHeight = maxHeight < 600;

          // Auf sehr breiten Displays (Fold/Z, Tablets) Content begrenzen
          final double contentMaxWidth = isVeryWide
              ? 720.0
              : (maxWidth > 640.0 ? 640.0 : maxWidth);

          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: contentMaxWidth,
              ),
              child: Column(
                children: [
                  // Optional ein kleiner Top-Abstand bei sehr kompakten Höhen vermeiden
                  SizedBox(height: isCompactHeight ? 4 : 8),

                  // Intro-Header + Sitzungs-Info
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    decoration: const BoxDecoration(
                      color: ViventisColors.navy,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CoachBot · Viventis',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(0.85),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ein ruhiger Raum, um dein aktuelles Thema zu sortieren.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sitzung vom $sessionDate · $msgCount Nachrichten',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Chatbereich
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 14,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(12),
                          itemCount: session.messages.length,
                          itemBuilder: (context, index) {
                            final msg = session.messages[index];
                            final isCoach = msg.role == 'coach';
                            return _MessageBubble(
                              text: msg.text,
                              isCoach: isCoach,
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // Eingabebereich
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            minLines: 1,
                            maxLines: 4,
                            enabled: !_isSending,
                            decoration: InputDecoration(
                              hintText: _isSending
                                  ? 'CoachBot antwortet …'
                                  : 'Deine Antwort…',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide(
                                  color: Colors.black.withOpacity(0.1),
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _isSending ? null : _handleSend,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ViventisColors.accentYellow,
                            foregroundColor: Colors.black,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(14),
                            elevation: 2,
                          ),
                          child: _isSending
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.arrow_upward_rounded),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String text;
  final bool isCoach;

  const _MessageBubble({
    required this.text,
    required this.isCoach,
  });

  @override
  Widget build(BuildContext context) {
    final Alignment align =
        isCoach ? Alignment.centerLeft : Alignment.centerRight;
    final Color bgColor = isCoach
        ? ViventisColors.navy.withOpacity(0.07)
        : ViventisColors.accentYellow.withOpacity(0.2);
    final Color textColor = isCoach ? Colors.black87 : Colors.black;

    final BorderRadius radius = BorderRadius.only(
      topLeft: const Radius.circular(18),
      topRight: const Radius.circular(18),
      bottomLeft: Radius.circular(isCoach ? 4 : 18),
      bottomRight: Radius.circular(isCoach ? 18 : 4),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        // Bubbles orientieren sich an der verfügbaren Breite, nicht am
        // gesamten Geräte-Screen (wichtig bei maxWidth-Layouts / Fold).
        final double maxBubbleWidth = constraints.maxWidth * 0.78;

        return Align(
          alignment: align,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxBubbleWidth,
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: radius,
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  height: 1.35,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
