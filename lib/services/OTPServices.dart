import 'dart:convert';

import 'package:adhyayan/bottom_navigation.dart';
import 'package:adhyayan/commons/constants.dart';
import 'package:adhyayan/commons/utils.dart';
import 'package:adhyayan/screens/auth/changePassScreen.dart';
import 'package:adhyayan/screens/home/HomePage.dart';
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
      return true;

      print(res.body);
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
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavigation(),
              ),
              (Route<dynamic> route) => false);
        } else {
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
