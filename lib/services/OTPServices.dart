import 'dart:convert';

import 'package:adhyayan/commons/constants.dart';
import 'package:adhyayan/commons/utils.dart';
import 'package:adhyayan/screens/auth/changePassScreen.dart';
import 'package:adhyayan/screens/auth/loginScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OTPService {
  Future<bool> getOTP(BuildContext context, String email) async {
    try {
      http.Response res = await http.post(
        Uri.parse("$URL/otp/getOtp"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"email": email}),
      );
      if (res.statusCode != 200) {
        showCustomSnackBar(
          context,
          message: jsonDecode(res.body)['error'],
          title: "OTP not Sent",
          isSuccess: false,
        );
        return false;
      }
      showCustomSnackBar(
        context,
        message: 'OTP sent successfully!',
        title: 'Verify email to Continue.',
        isSuccess: true,
      );

      return true;
    } catch (err) {
      print(err);
    }
    return false;
  }

  void verifyOTP({
    bool isPassChange = false,
    required String otp,
    required String email,
    required BuildContext context,
  }) async {
    try {
      // print("INSIDE Verify OTP");
      http.Response res = await http.post(
        Uri.parse("$URL/otp/verifyOtp"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "otp": otp,
          "email": email,
        }),
      );
      print(res.body);
      if (res.statusCode == 200) {
        if (isPassChange == false) {
          showCustomSnackBar(
            context,
            message: 'Account created successfully!',
            title: 'Sign-Up Successful',
            isSuccess: true,
          );
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
              (Route<dynamic> route) => false);
        } else {
          showCustomSnackBar(
            context,
            message: 'Please enter your new password to continue.',
            title: 'Account Verification Successful',
            isSuccess: true,
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangePassword(
                email: email,
              ),
            ),
          );
        }
      } else {
        showCustomSnackBar(context,
            message: "Please try again!",
            title: "Incorrect OTP",
            isSuccess: false);
      }
    } catch (err) {
      print(err);
    }
  }
}
