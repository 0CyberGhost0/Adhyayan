import 'package:adhyayan/commons/color.dart';
import 'package:adhyayan/services/OTPServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class ForgotPassVerifyEmail extends StatelessWidget {
  final String email;
  const ForgotPassVerifyEmail({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    String OTP = "";
    void verifyOTP() {
      OTPService otpService = OTPService();
      otpService.verifyOTP(
          isPassChange: true, otp: OTP, email: email, context: context);
    }

    return Scaffold(
      // appBar: AppBar(),
      backgroundColor: backGroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              const SizedBox(
                height: 70,
              ),
              // Image
              Image(
                image: const AssetImage(
                    "assets/images/animations/sammy-line-man-receives-a-mail.png"),
                width: size.width * 0.6,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Title
              Text(
                "Verify Your Email Address!",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              // Email
              Text(
                email,
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwItems + 10),

              // Description

              // OTP Text Field using flutter_otp_text_field
              OtpTextField(
                numberOfFields: 6,
                borderColor: TColors.primary,
                focusedBorderColor: TColors.primary,
                cursorColor: TColors.primary,
                showFieldAsBox: true,
                fieldWidth: 40.0,
                onSubmit: (String otp) {
                  OTP = otp;
                  verifyOTP();
                },
              ),
              const SizedBox(height: TSizes.spaceBtwItems + 10),

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: verifyOTP,
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
              const SizedBox(height: TSizes.spaceBtwSections),

              // Resend Mail Button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    OTPService otpService = OTPService();
                    bool sent = await otpService.getOTP(context, email);
                  },
                  child: const Text("Resend Mail"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
