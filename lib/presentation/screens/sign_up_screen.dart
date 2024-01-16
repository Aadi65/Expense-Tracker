import 'package:com_cipherschools_assignment/presentation/screens/main_screen.dart';
import 'package:com_cipherschools_assignment/providers/auth_provider.dart';
import 'package:com_cipherschools_assignment/utils/colors.dart';
import 'package:com_cipherschools_assignment/presentation/common_widgets/custom_button.dart';
import 'package:com_cipherschools_assignment/presentation/common_widgets/custom_textfield.dart';
import 'package:com_cipherschools_assignment/presentation/screens/login_screen.dart';
import 'package:com_cipherschools_assignment/utils/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  @override
  void dispose() {
    nameController.dispose();
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
          'Sign Up',
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
                  hint: 'Name',
                  controller: nameController,
                ),
                const SizedBox(
                  height: 24,
                ),
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
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'By signing up, you agree to the',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: ' Terms of Service and Privacy Policy',
                        recognizer: TapGestureRecognizer()..onTap = () {},
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: violet100,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                CustomButton(
                    title: 'Sign Up',
                    widget: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            value: CircularProgressIndicator.strokeAlignInside,
                          )
                        : null,
                    function: isLoading
                        ? () {}
                        : () async {
                            if (nameController.text.trim().isEmpty ||
                                emailController.text.trim().isEmpty ||
                                passwordController.text.trim().isEmpty) {
                              showSnackBar(
                                  context, 'Please fill all the fields');
                              return;
                            }
                            if (nameController.text.trim().length < 4) {
                              showSnackBar(context,
                                  'Name should at least be 4 characters long');
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
                                  .signUpWithEmailPassword(
                                      context: context,
                                      name: nameController.text.trim(),
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim());
                              FirebaseAuth.instance
                                  .authStateChanges()
                                  .listen((User? user) {
                                if (user != null) {
                                  setState(() {
                                    isLoading = false;
                                  });
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
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                showSnackBar(context,
                                    e.message ?? 'Authentication failed');
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
                            .listen((User? user) {
                          if (user != null) {
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
                        setState(() {
                          isLoading = false;
                        });
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
                      'Sign Up with Google',
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
                      'Already have account?',
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
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Login',
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
