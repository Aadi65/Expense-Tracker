import 'package:com_cipherschools_assignment/presentation/screens/on_boarding_screen.dart';
import 'package:com_cipherschools_assignment/providers/auth_provider.dart';
import 'package:com_cipherschools_assignment/firebase_options.dart';
import 'package:com_cipherschools_assignment/presentation/screens/login_screen.dart';
import 'package:com_cipherschools_assignment/presentation/screens/main_screen.dart';
import 'package:com_cipherschools_assignment/presentation/screens/sign_up_screen.dart';
import 'package:com_cipherschools_assignment/models/transaction.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool? onBoarding;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  onBoarding = prefs.getBool('onBoarding');
  onBoarding ??= true;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(ModeAdapter());
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: onBoarding! == true
          ? const OnBoardingScreen()
          : authState.when(
              data: (user) {
                if (user != null) {
                  return const MainScreen();
                }
                return const SignUpScreen();
              },
              error: (error, stackTrace) {
                return const LoginScreen();
              },
              loading: () => const LoginScreen(),
            ),
    );
  }
}
