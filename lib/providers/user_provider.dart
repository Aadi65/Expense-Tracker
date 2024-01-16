import 'package:com_cipherschools_assignment/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = FutureProvider((ref) async {
  final authRepository = ref.watch(authRepositoryProvider);
  User currentUser = FirebaseAuth.instance.currentUser!;
  return await authRepository.getUserDetails(currentUser.uid);
});
