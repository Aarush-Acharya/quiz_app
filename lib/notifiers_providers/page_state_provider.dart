import 'package:flutter_riverpod/flutter_riverpod.dart';

final pageStateProvider = StateProvider.autoDispose<int>((ref) => 0);