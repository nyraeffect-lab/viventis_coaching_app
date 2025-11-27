class CoachingStep {
  final String id;
  final String coachText;
  final bool last;

  CoachingStep({
    required this.id,
    required this.coachText,
    required this.last,
  });

  factory CoachingStep.fromJson(Map<String, dynamic> json) {
    return CoachingStep(
      id: json['id'] as String,
      coachText: json['coachText'] as String,
      last: (json['last'] ?? false) as bool,
    );
  }
}
