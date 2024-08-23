import 'dart:convert';

import 'package:adhyayan/Data_Models/courseModel.dart';
import 'package:adhyayan/provider/userProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../commons/constants.dart';

class CourseServices {
  // Replace with your API base URL

  Future<List<Course>> getPopularCourse() async {
    List<Course> popularCourse = [];
    try {
      print("Popular called");
      // Make the HTTP GET request
      http.Response res = await http.get(
        Uri.parse('$URL/course/popularCourse'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // Check if the request was successful
      if (res.statusCode == 200) {
        // Decode the JSON response
        final List<dynamic> data = jsonDecode(res.body);
        // print(data);

        // Map JSON data to Course instances
        popularCourse = data.map((json) => Course.fromJson(json)).toList();
        print(popularCourse);
      } else {
        // Handle non-200 status codes
        print('Failed to load popular courses. Status code: ${res.statusCode}');
      }
    } catch (err) {
      // Handle any errors
      print('Error: $err');
    }
    return popularCourse;
  }

  void saveCourse(
    final String courseId,
  ) async {
    try {
      print("SAVING COURSE: $courseId");
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final token = sharedPreferences.getString("x-auth-token");
      print("USER TOKEN IN SAVE COURSE : $token");
      http.Response res = await http.post(
        Uri.parse('$URL/course/saveCourse'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "x-auth-token": token!,
          "courseId": courseId
        },
      );
    } catch (err) {
      print("SAVING COURSE ERROR: $err");
    }
  }
}
