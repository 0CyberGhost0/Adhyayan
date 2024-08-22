import 'package:adhyayan/commons/color.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});
  InputDecoration inputDecoration({
    required String labelText,
    required Icon prefixIcon,
    Icon? suffixIcon,
  }) {
    return InputDecoration(
      errorMaxLines: 3,
      prefixIconColor: TColors.darkGrey,
      suffixIconColor: TColors.darkGrey,
      labelStyle: TextStyle(
        fontSize: TSizes.fontSizeMd,
        color: TColors.black,
        fontWeight: FontWeight.bold,
      ),
      hintStyle: TextStyle(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Forgot Password",
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(
              height: TSizes.spaceBtwItems,
            ),
            Text(
              "Don't worry sometimes people can forget too. Enter your email and we will send you a password reset link.",
            ),
            SizedBox(
              height: TSizes.spaceBtwSections,
            ),
            TextFormField(
              decoration: inputDecoration(
                labelText: "E-Mail",
                prefixIcon: const Icon(Iconsax.user_edit),
              ),
            ),
            SizedBox(height: TSizes.spaceBtwSections),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: TSizes.buttonHeight),
                  textStyle: const TextStyle(
                      fontSize: 16,
                      color: TColors.textWhite,
                      fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TSizes.buttonRadius),
                  ),
                ),
                onPressed: () {},
                child: Text("Submit"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
