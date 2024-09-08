import 'dart:convert';
import 'package:adhyayan/bottom_navigation.dart';
import 'package:adhyayan/commons/constants.dart';
import 'package:adhyayan/commons/utils.dart';
import 'package:adhyayan/screens/auth/loginScreen.dart';
import 'package:adhyayan/screens/auth/verify_email.dart';
import 'package:adhyayan/screens/home/HomePage.dart';
import 'package:adhyayan/services/OTPServices.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Data_Models/userModel.dart';
import '../provider/userProvider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AuthService {
  // Sign up method
  void signUpUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    required BuildContext context,
    required String userName,
  }) async {
    try {
      var user = User(
          firstName: firstName,
          lastName: lastName,
          userName: userName,
          phone: phone,
          email: email,
          password: password,
          profilePictureUrl: '',
          enrolledCourses: [],
          savedCourses: [],
          token: '');
      print(user.toJson());
      http.Response res = await http.post(
        Uri.parse('$URL/auth/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print(res.body);
      if (res.statusCode == 200) {
        // Show success snack bar
        showCustomSnackBar(
          context,
          message: 'Account created successfully! Please verify your email.',
          title: 'Sign-Up Successful',
          isSuccess: true,
        );
        OTPService otpService = OTPService();
        otpService.getOTP(context, email);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmailVerifyScreen(
                email: email,
              ),
            ));
      } else {
        // Show error snack bar
        showCustomSnackBar(
          context,
          message: 'Failed to create account. Try again.',
          title: 'Sign-Up Failed',
          isSuccess: false,
        );
      }
    } catch (e) {
      print(e);
      // Show error snack bar
      showCustomSnackBar(
        context,
        message: 'An error occurred. Please try again.',
        title: 'Error',
        isSuccess: false,
      );
    }
  }

  // Login method
  void logInUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      print("inside login");
      http.Response res = await http.post(
        Uri.parse("$URL/auth/login"),
        body: jsonEncode({"email": email, "password": password}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print(res.body);
      if (res.statusCode == 200) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString(
            "x-auth-token", jsonDecode(res.body)['token']);
        await getUserData(context: context);

        // Show success snack bar
        showCustomSnackBar(
          context,
          message: 'Logged in successfully!',
          title: 'Login Successful',
          isSuccess: true,
        );

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => BottomNavigation()));
      } else {
        // Show error snack bar
        showCustomSnackBar(
          context,
          message: 'Login failed. Please check your credentials.',
          title: 'Login Failed',
          isSuccess: false,
        );
      }
      print(res.statusCode);
    } catch (err) {
      print(err);
      // Show error snack bar
      showCustomSnackBar(
        context,
        message: 'An error occurred. Please try again.',
        title: 'Error',
        isSuccess: false,
      );
    }
  }

  // Fetch user data method
  Future<void> getUserData({
    required BuildContext context,
  }) async {
    try {
      print("inside get data");
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? token = sharedPreferences.getString("x-auth-token");
      print(token);
      if (token == null || token.isEmpty) {
        sharedPreferences.setString('x-auth-token', "");
      }
      print("after set string");
      http.Response res = await http.post(Uri.parse("$URL/auth/isTokenValid"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "x-auth-token": token!
          });
      var response = jsonDecode(res.body);
      print(res.body);

      if (response == true) {
        print("Token: ${token}");
        http.Response userData = await http.get(
          Uri.parse("$URL/auth/getData"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "x-auth-token": token
          },
        );
        print(userData.body);
        print("object set");
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        print("before set");
        print(userData.body);
        userProvider.setUser(userData.body);
        print("after set");
      }
    } catch (err) {
      print(err);
    }
  }

  Future<void> signOutWithGoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("x-auth-token", '');
    Provider.of<UserProvider>(context, listen: false).clearData();
  }

  // Google sign-in method
  Future<void> signinWithGoogle(
    BuildContext context,
  ) async {
    try {
      // googleSignIn.signOut();
      await signOutWithGoogle(context);
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile', 'openid'],
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final email = googleUser.email;
        final displayName = googleUser.displayName;
        final photoUrl = googleUser.photoUrl;
        print(photoUrl);
        http.Response res = await http.post(
          Uri.parse('$URL/auth/google-signin'),
          body: jsonEncode({
            'email': email,
            'firstName': displayName?.split(" ")[0],
            'profileImageUrl': photoUrl,
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        print(res.body);

        if (res.statusCode == 200) {
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          final String token = jsonDecode(res.body)['token'];
          sharedPreferences.setString("x-auth-token", token);
          await getUserData(context: context);

          // Show success snack bar
          showCustomSnackBar(
            context,
            message: 'Logged in with Google successfully!',
            title: 'Google Login Successful',
            isSuccess: true,
          );

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => BottomNavigation()),
              (Route<dynamic> route) => false);
        } else {
          // Show error snack bar
          showCustomSnackBar(
            context,
            message: 'Google login failed. Please try again.',
            title: 'Google Login Failed',
            isSuccess: false,
          );
        }
      }
    } catch (err) {
      print(err);
      // Show error snack bar
      showCustomSnackBar(
        context,
        message: 'An error occurred. Please try again.',
        title: 'Error',
        isSuccess: false,
      );
    }
  }

  // Reset password method
  Future<void> resetPassword(
      BuildContext context, String email, String password) async {
    try {
      http.Response res = await http.post(
        Uri.parse("$URL/auth/resetPass"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "password": password,
          "email": email,
        }),
      );
      print(res.body);
      if (res.statusCode == 200) {
        // Show success snack bar
        showCustomSnackBar(
          context,
          message: 'Password reset successfully!',
          title: 'Reset Successful',
          isSuccess: true,
        );
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false);
      } else {
        // Show error snack bar
        showCustomSnackBar(
          context,
          message: 'Failed to reset password. Try again.',
          title: 'Reset Failed',
          isSuccess: false,
        );
      }
    } catch (err) {
      print(err);
      // Show error snack bar
      showCustomSnackBar(
        context,
        message: 'An error occurred. Please try again.',
        title: 'Error',
        isSuccess: false,
      );
    }
  }

  // Upload profile picture method
  Future<void> uploadProfilePic({
    required String imageUrl,
    required BuildContext context,
  }) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? token = sharedPreferences.getString("x-auth-token");

      http.Response res = await http.post(
        Uri.parse("$URL/auth/uploadPic"),
        body: jsonEncode({"photoUrl": imageUrl}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );
      if (res.statusCode == 200) {
        // Show success snack bar
        showCustomSnackBar(
          context,
          message: 'Profile picture updated successfully!',
          title: 'Upload Successful',
          isSuccess: true,
        );
        await getUserData(context: context);
      } else {
        // Show error snack bar
        showCustomSnackBar(
          context,
          message: 'Failed to update profile picture.',
          title: 'Upload Failed',
          isSuccess: false,
        );
      }
    } catch (err) {
      print(err);
      // Show error snack bar
      showCustomSnackBar(
        context,
        message: 'An error occurred. Please try again.',
        title: 'Error',
        isSuccess: false,
      );
    }
  }

  // Update phone number method
  Future<void> updatePhoneNumber({
    required String phoneNumber,
    required BuildContext context,
  }) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? token = sharedPreferences.getString("x-auth-token");

      http.Response res = await http.post(
        Uri.parse("$URL/auth/updatePhone"),
        body: jsonEncode({"phoneNum": phoneNumber}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );
      if (res.statusCode == 200) {
        // Show success snack bar
        showCustomSnackBar(
          context,
          message: 'Phone number updated successfully!',
          title: 'Update Successful',
          isSuccess: true,
        );
        await getUserData(context: context);
      } else {
        // Show error snack bar
        showCustomSnackBar(
          context,
          message: 'Failed to update phone number.',
          title: 'Update Failed',
          isSuccess: false,
        );
      }
    } catch (err) {
      print(err);
      // Show error snack bar
      showCustomSnackBar(
        context,
        message: 'An error occurred. Please try again.',
        title: 'Error',
        isSuccess: false,
      );
    }
  }
}
