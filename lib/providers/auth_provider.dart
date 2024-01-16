import 'package:com_cipherschools_assignment/services/firebase_methods.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider =
    Provider<FirebaseMethods>((ref) => FirebaseMethods());

final authStateProvider = StreamProvider((ref) {
  return ref.read(authRepositoryProvider).authStateChange;
});
