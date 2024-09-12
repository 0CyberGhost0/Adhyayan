import 'package:adhyayan/screens/auth/forgotPasswordScreen.dart';
import 'package:adhyayan/screens/auth/signupScreen.dart';
import 'package:adhyayan/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../commons/color.dart';
import '../../commons/formDivider.dart';
import '../../commons/socialButton.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isChecked = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  final AuthService _authService = AuthService();
  void _login() {
    final String email = _emailController.text;
    final String password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      // Added username check
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }
    _authService.logInUser(email: email, password: password, context: context);
  }

  Future<void> loginWithGoogle() async {
    AuthService authService = AuthService();

    await authService.signinWithGoogle(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 56, right: 24, left: 24, bottom: 24),
          child: Column(
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const Image(
                  //   height: 150,
                  //   image: AssetImage("assets/images/newimage.jpg"),
                  // ),
                  SizedBox(height: 140),
                  Text(
                    'Welcome Back,',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: TColors.dark,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Master the Skills of Tomorrow, Today – Your Journey to Excellence Starts Here.',
                    style: TextStyle(
                      fontSize: 19.0,
                      fontWeight: FontWeight.w500,
                      color: TColors.dark,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
              Form(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          errorMaxLines: 3,
                          prefixIconColor: TColors.darkGrey,
                          suffixIconColor: TColors.darkGrey,
                          labelStyle: const TextStyle(
                            fontSize: TSizes.fontSizeMd,
                            color: TColors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          hintStyle: const TextStyle(
                            fontSize: TSizes.fontSizeSm,
                            color: TColors.black,
                          ),
                          errorStyle: const TextStyle(
                            fontStyle: FontStyle.normal,
                          ),
                          floatingLabelStyle: TextStyle(
                            color: TColors.black.withOpacity(0.8),
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(TSizes.inputFieldRadius),
                            borderSide:
                                const BorderSide(width: 1, color: TColors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(TSizes.inputFieldRadius),
                            borderSide:
                                const BorderSide(width: 1, color: TColors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(TSizes.inputFieldRadius),
                            borderSide:
                                const BorderSide(width: 1, color: TColors.dark),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(TSizes.inputFieldRadius),
                            borderSide: const BorderSide(
                                width: 1, color: TColors.warning),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(TSizes.inputFieldRadius),
                            borderSide: const BorderSide(
                                width: 2, color: TColors.warning),
                          ),
                          prefixIcon: const Icon(Iconsax.direct_right),
                          labelText: "E-mail",
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          errorMaxLines: 3,
                          prefixIconColor: TColors.darkGrey,
                          suffixIconColor: TColors.darkGrey,
                          labelStyle: const TextStyle(
                            fontSize: TSizes.fontSizeMd,
                            color: TColors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          hintStyle: const TextStyle(
                            fontSize: TSizes.fontSizeSm,
                            color: TColors.black,
                          ),
                          errorStyle: const TextStyle(
                            fontStyle: FontStyle.normal,
                          ),
                          floatingLabelStyle: TextStyle(
                            color: TColors.black.withOpacity(0.8),
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(TSizes.inputFieldRadius),
                            borderSide:
                                const BorderSide(width: 1, color: TColors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(TSizes.inputFieldRadius),
                            borderSide:
                                const BorderSide(width: 1, color: TColors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(TSizes.inputFieldRadius),
                            borderSide:
                                const BorderSide(width: 1, color: TColors.dark),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(TSizes.inputFieldRadius),
                            borderSide: const BorderSide(
                                width: 1, color: TColors.warning),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(TSizes.inputFieldRadius),
                            borderSide: const BorderSide(
                                width: 2, color: TColors.warning),
                          ),
                          prefixIcon: const Icon(Iconsax.password_check),
                          labelText: "Password",
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Iconsax.eye
                                  : Iconsax.eye_slash,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    isChecked = value ?? false;
                                  });
                                  // Handle change in checkbox value
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(TSizes
                                      .xs), // Assuming TSizes.xs is defined
                                ),
                                checkColor: Colors.white,
                                fillColor:
                                    WidgetStateProperty.resolveWith((states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return TColors
                                        .primary; // Use your custom primary color
                                  } else {
                                    return Colors.transparent;
                                  }
                                }),
                              ),
                              const Text("Remember Me"),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPassword()));
                            },
                            child: const Text("Forget Password?"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            foregroundColor: TColors.light,
                            backgroundColor: TColors.primary,
                            disabledForegroundColor: TColors.darkGrey,
                            disabledBackgroundColor: TColors.buttonDisabled,
                            side: const BorderSide(color: TColors.primary),
                            padding: const EdgeInsets.symmetric(
                                vertical: TSizes.buttonHeight),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              color: TColors.textWhite,
                              fontWeight: FontWeight.w600,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(TSizes.buttonRadius),
                            ),
                          ),
                          onPressed: _login,
                          child: const Text("Sign In"),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            elevation: 0,
                            foregroundColor: TColors.dark,
                            side:
                                const BorderSide(color: TColors.borderPrimary),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              color: TColors.black,
                              fontWeight: FontWeight.w600,
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: TSizes.buttonHeight, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(TSizes.buttonRadius),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUp()));
                          },
                          child: const Text("Create Account"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const formDivider(text: 'or Sign In with'),
              SocialButton(
                onTapGoogle: loginWithGoogle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
