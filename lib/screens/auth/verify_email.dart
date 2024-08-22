import 'package:adhyayan/commons/color.dart';
import 'package:flutter/material.dart';

class EmailVerifyScreen extends StatelessWidget {
  const EmailVerifyScreen({super.key});

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
              //Images
              Image(
                image: const AssetImage(
                    "assets/images/animations/sammy-line-man-receives-a-mail.png"),
                width: size.width * 0.6,
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              Text(
                "Verify Your Email Address!",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              Text(
                'prakashved0702@gmail.com',
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwItems + 10),

              const Text(
                "Congratulations! Your Account Awaits. Verify your Email \n to start Shopping and Experience a world of Unrivaled Deals and Personalized Offers",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwItems + 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
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
                  child: const Text("Continue"),
                ),
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Resend Mail"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
