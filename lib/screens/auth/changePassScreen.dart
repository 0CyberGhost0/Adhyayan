import 'package:adhyayan/commons/color.dart';
import 'package:adhyayan/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ChangePassword extends StatefulWidget {
  final String email;
  const ChangePassword({super.key, required this.email});

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // State variables for password visibility
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Custom input decoration function for consistency
  InputDecoration inputDecoration({
    required String labelText,
    Widget? prefixIcon,
    required Widget suffixIcon,
    VoidCallback? onSuffixIconTap,
  }) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: Theme.of(context).textTheme.labelLarge,
      prefixIcon: prefixIcon,
      suffixIcon: GestureDetector(
        onTap: onSuffixIconTap,
        child: suffixIcon,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TSizes.buttonRadius),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TSizes.buttonRadius),
        borderSide: const BorderSide(color: TColors.primary),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TSizes.buttonRadius),
        borderSide: const BorderSide(color: TColors.darkGrey),
      ),
    );
  }

  // Function to handle password change
  Future<void> changePassword() async {
    if (_formKey.currentState!.validate()) {
      // Extract password values
      final newPassword = _passwordController.text;
      final confirmPassword = _confirmPasswordController.text;

      // Your logic to handle password change, e.g., API request
      try {
        AuthService authService = AuthService();
        authService.resetPassword(context, widget.email, newPassword);

        // Optionally navigate back or to another screen
      } catch (error) {
        // Handle errors (e.g., show an error message)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $error'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 250.0),

              // Title
              Text(
                "Change Password",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // New Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: inputDecoration(
                  labelText: "New Password",
                  prefixIcon: const Icon(Iconsax.password_check),
                  suffixIcon: Icon(
                    _obscurePassword ? Iconsax.eye_slash : Iconsax.eye,
                    color: TColors.primary,
                  ),
                  onSuffixIconTap: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                cursorColor: TColors.primary,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your new password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              // Confirm Password Field
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: inputDecoration(
                  labelText: "Confirm Password",
                  prefixIcon: const Icon(Iconsax.password_check),
                  suffixIcon: Icon(
                    _obscureConfirmPassword ? Iconsax.eye_slash : Iconsax.eye,
                    color: TColors.primary,
                  ),
                  onSuffixIconTap: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
                cursorColor: TColors.primary,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwItems + 20),

              // Change Password Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: changePassword,
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
                      borderRadius: BorderRadius.circular(TSizes.buttonRadius),
                    ),
                  ),
                  child: const Text("Change Password"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
