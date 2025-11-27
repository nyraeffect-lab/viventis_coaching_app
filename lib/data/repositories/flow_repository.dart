import 'package:viventis_coaching_app/core/utils/json_loader.dart';
import 'package:viventis_coaching_app/data/models/coaching_step.dart';

class FlowRepository {
  Future<List<CoachingStep>> loadIntroFlow() async {
    final map = await JsonLoader.loadJsonMap('data/flows/intro_flow.json');
    final steps = map['steps'];
    if (steps is List) {
      return steps
          .whereType<Map<String, dynamic>>()
          .map(CoachingStep.fromJson)
          .toList();
    }
    return const <CoachingStep>[];
  }
}
