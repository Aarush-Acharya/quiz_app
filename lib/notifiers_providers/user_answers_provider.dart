import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/utils/options_enum.dart';

late AutoDisposeStateProvider<List<Options>> userAnswers;

void initialiseAnswerSheet(int questionCount) {
  userAnswers = StateProvider.autoDispose<List<Options>>(
      (ref) => List.filled(questionCount, Options.empty));
}
