import 'package:adhyayan/commons/formDivider.dart';
import 'package:adhyayan/commons/socialButton.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../commons/color.dart';
import '../../services/AuthService.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController =
      TextEditingController(); // Changed from _emailController
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final AuthService _authService = AuthService();

  InputDecoration inputDecoration({
    required String labelText,
    required Icon prefixIcon,
    Icon? suffixIcon,
  }) {
    return InputDecoration(
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
      errorStyle: const TextStyle(fontStyle: FontStyle.normal),
      floatingLabelStyle: TextStyle(
        color: TColors.black.withOpacity(0.8),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TSizes.inputFieldRadius),
        borderSide: const BorderSide(width: 1, color: TColors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TSizes.inputFieldRadius),
        borderSide: const BorderSide(width: 1, color: TColors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TSizes.inputFieldRadius),
        borderSide: const BorderSide(width: 1, color: TColors.dark),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TSizes.inputFieldRadius),
        borderSide: const BorderSide(width: 1, color: TColors.warning),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TSizes.inputFieldRadius),
        borderSide: const BorderSide(width: 2, color: TColors.warning),
      ),
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    );
  }

  void _signUp() {
    final String firstName = _firstNameController.text.trim();
    final String lastName = _lastNameController.text.trim();
    final String username =
        _usernameController.text.trim(); // Changed from _emailController
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String phone = _phoneController.text.trim();

    if (firstName.isEmpty ||
        username.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      // Added username check
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    _authService.signUpUser(
      firstName: firstName,
      lastName: lastName,
      userName: username, // Added username
      email: email,
      password: password,
      phone: phone,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              Text(
                "Let's Create Your Account",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w600,
                      color: TColors.dark,
                    ),
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections + 25,
              ),
              Form(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _firstNameController,
                            decoration: inputDecoration(
                              labelText: "First Name",
                              prefixIcon: const Icon(Iconsax.user),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _lastNameController,
                            decoration: inputDecoration(
                              labelText: "Last Name",
                              prefixIcon: const Icon(Iconsax.user),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwInputFields,
                    ),
                    TextFormField(
                      controller:
                          _usernameController, // Updated to use _usernameController
                      decoration: inputDecoration(
                        labelText: "Username",
                        prefixIcon: const Icon(Iconsax.user_edit),
                      ),
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwInputFields,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: inputDecoration(
                        labelText: "E-mail",
                        prefixIcon: const Icon(Iconsax.direct),
                      ),
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwInputFields,
                    ),
                    TextFormField(
                      controller: _phoneController,
                      decoration: inputDecoration(
                        labelText: "Phone Number",
                        prefixIcon: const Icon(Iconsax.call),
                      ),
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwInputFields,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: inputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Iconsax.password_check),
                        suffixIcon: const Icon(Iconsax.eye_slash),
                      ),
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwInputFields,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: true,
                            onChanged: (value) {},
                            checkColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwSections - 20),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "I agree to ",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: TColors.dark.withOpacity(0.5),
                                ),
                              ),
                              const TextSpan(
                                text: "Privacy Policy",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.normal,
                                  color: TColors.primary,
                                  decoration: TextDecoration.underline,
                                  decorationColor: TColors.primary,
                                ),
                              ),
                              TextSpan(
                                text: " and ",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: TColors.dark.withOpacity(0.5),
                                ),
                              ),
                              const TextSpan(
                                text: "Terms of Use",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.normal,
                                  color: TColors.primary,
                                  decoration: TextDecoration.underline,
                                  decorationColor: TColors.primary,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _signUp,
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
                              fontWeight: FontWeight.w600),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(TSizes.buttonRadius),
                          ),
                        ),
                        child: const Text("Create Account"),
                      ),
                    )
                  ],
                ),
              ),
              const formDivider(text: "Or Sign Up With"),
              const SizedBox(
                height: TSizes.spaceBtwSections - 25,
              ),
              const SocialButton(),
            ],
          ),
        ),
      ),
    );
  }
}
