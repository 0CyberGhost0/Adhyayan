import 'dart:convert';

import 'package:adhyayan/bottom_navigation.dart';
import 'package:adhyayan/commons/constants.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Data_Models/userModel.dart';
import '../provider/userProvider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AuthService {
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
      );
      print(user.toJson());
      http.Response res = await http.post(
        Uri.parse('$URL/auth/signup'),
        body: jsonEncode(user),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print(res.body);
    } catch (e) {
      print(e);
    }
  }

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
        getUserData(context: context);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => BottomNavigation()));
      }
      print(res.statusCode);
    } catch (err) {
      print(err);
    }
  }

  void getUserData({
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
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        print("before set");
        print(userData.body);
        userProvider.setUser(userData.body);
        print("after set");
        userProvider = Provider.of<UserProvider>(context, listen: false);
        print(userProvider.user.email);
        print(userProvider.user.enrolledCourses);
      }
    } catch (err) {
      print(err);
    }
  }
}
