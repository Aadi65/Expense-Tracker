import 'package:com_cipherschools_assignment/models/transaction.dart';
import 'package:com_cipherschools_assignment/presentation/common_widgets/custom_button.dart';
import 'package:com_cipherschools_assignment/presentation/common_widgets/custom_textfield.dart';
import 'package:com_cipherschools_assignment/presentation/screens/main_screen.dart';
import 'package:com_cipherschools_assignment/presentation/screens/sign_up_screen.dart';
import 'package:com_cipherschools_assignment/providers/auth_provider.dart';
import 'package:com_cipherschools_assignment/providers/user_provider.dart';
import 'package:com_cipherschools_assignment/utils/colors.dart';
import 'package:com_cipherschools_assignment/utils/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const Text(
          'Login',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextfield(
                  hint: 'Email',
                  controller: emailController,
                ),
                const SizedBox(
                  height: 24,
                ),
                CustomTextfield(
                  hint: 'Password',
                  controller: passwordController,
                  obscureText: true,
                ),
                const SizedBox(
                  height: 24,
                ),
                CustomButton(
                    title: 'Login',
                    widget:
                        isLoading ? const CircularProgressIndicator() : null,
                    function: isLoading
                        ? () {}
                        : () async {
                            if (emailController.text.trim().isEmpty ||
                                passwordController.text.trim().isEmpty) {
                              showSnackBar(
                                  context, 'Please fill all the fields');
                              return;
                            }
                            if (!emailController.text.contains('@')) {
                              showSnackBar(context,
                                  'Please enter a valid email address');
                              return;
                            }
                            if (passwordController.text.trim().length < 6) {
                              showSnackBar(context,
                                  'Password should be atleast 6 characters long');
                              return;
                            }
                            try {
                              setState(() {
                                isLoading = true;
                              });
                              await ref
                                  .read(authRepositoryProvider)
                                  .signInWithEmailPassword(
                                    context: context,
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  );
                              FirebaseAuth.instance
                                  .authStateChanges()
                                  .listen((User? user) async {
                                if (user != null) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  await Hive.openBox<Transaction>(
                                      'transactions');
                                  ref.refresh(userProvider);
                                  if (context.mounted) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const MainScreen(),
                                      ),
                                    );
                                  }
                                }
                              });
                            } on FirebaseAuthException catch (e) {
                              setState(() {
                                isLoading = false;
                              });
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                showSnackBar(context,
                                    e.message ?? 'Authentication Faild');
                              }
                            }
                            setState(() {
                              isLoading = false;
                            });
                          }),
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  'Or with',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () async {
                      try {
                        await ref.read(authRepositoryProvider).signInWithGoogle(
                              context,
                            );
                        FirebaseAuth.instance
                            .authStateChanges()
                            .listen((User? user) async {
                          if (user != null) {
                            setState(() {
                              isLoading = false;
                            });
                            await Hive.openBox<Transaction>('transactions');
                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MainScreen(),
                                ),
                              );
                            }
                          }
                        });
                      } on FirebaseAuthException catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          showSnackBar(
                              context, e.message ?? 'Authentication failed');
                        }
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: light60, width: 1.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    icon: SvgPicture.asset('assets/icons/google.svg'),
                    label: const Text(
                      'Login with Google',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'New user?',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          decoration: TextDecoration.underline,
                          color: violet100,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
