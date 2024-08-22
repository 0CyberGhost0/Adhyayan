import 'package:flutter/material.dart';

import '../../commons/color.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              Image(
                image: const AssetImage(
                    "assets/images/animations/sammy-line-man-receives-a-mail.png"),
                width: size.width * 0.6,
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              Text(
                "Password Reset Email Sent",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: TSizes.spaceBtwItems + 10),
              Text(
                "Your Account Security is our priority! We've sent You a Secure Link to safely change your Password and keep Your Account Protected",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: TSizes.spaceBtwItems + 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text("Done"),
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
                ),
              ),
              SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {},
                  child: Text("Resend Email "),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
