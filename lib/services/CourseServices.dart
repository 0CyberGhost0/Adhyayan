import 'dart:convert';

import 'package:adhyayan/Data_Models/courseModel.dart';
import 'package:adhyayan/Data_Models/userModel.dart';
import 'package:adhyayan/commons/utils.dart';
import 'package:adhyayan/provider/userProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../commons/constants.dart';

class CourseServices {
  // Replace with your API base URL
  Future<List<Course>> searchCourse(String searchText) async {
    List<Course> searchResult = [];
    try {
      // Make the HTTP GET request
      http.Response res = await http.get(
        Uri.parse('$URL/course/search/$searchText'),
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
        searchResult = data.map((json) => Course.fromJson(json)).toList();
      } else {
        // Handle non-200 status codes
      }
    } catch (err) {}
    return searchResult;
  }

  Future<List<Course>> getPopularCourse() async {
    List<Course> popularCourse = [];
    try {
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
      } else {
        // Handle non-200 status codes
      }
    } catch (err) {
      // Handle any errors
    }
    return popularCourse;
  }

  Future<List<Course>> getCategoryCourse(
    String title,
  ) async {
    List<Course> categoryCourse = [];
    try {
      // Make the HTTP GET request
      http.Response res = await http.get(
        Uri.parse('$URL/course/category/$title'),
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
        categoryCourse = data.map((json) => Course.fromJson(json)).toList();
      } else {
        // Handle non-200 status codes
      }
    } catch (err) {
      // Handle any errors
    }
    return categoryCourse;
  }

  Future<void> saveCourse(
    final String courseId,
    final BuildContext context,
  ) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final token = sharedPreferences.getString("x-auth-token");
      http.Response res = await http.post(
        Uri.parse('$URL/course/saveCourse'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "x-auth-token": token!,
        },
        body: jsonEncode({"courseId": courseId}),
      );
      if (res.statusCode == 200) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.saveCourse(courseId);
      }
    } catch (err) {}
  }

  Future<void> unsaveCourse(
    final String courseId,
    final BuildContext context,
  ) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final token = sharedPreferences.getString("x-auth-token");
      http.Response res = await http.post(
        Uri.parse('$URL/course/unsaveCourse'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "x-auth-token": token!,
        },
        body: jsonEncode({"courseId": courseId}),
      );
      if (res.statusCode == 200) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.unsaveCourse(courseId);
      }
    } catch (err) {}
  }

  Future<Course> getCourseById(String courseId) async {
    Course course = Course(
      title: '',
      description: '',
      instructor: '',
      price: 0,
      rating: 0,
      enrolledCount: 0,
      thumbnailUrl: '',
      category: '',
      lessons: [],
    );
    try {
      // Make the HTTP GET request
      http.Response res = await http.get(
        Uri.parse('$URL/course/getCourseDetail'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'courseId': courseId
        },
      );

      // Check if the request was successful
      if (res.statusCode == 200) {
        course = Course.fromJson(jsonDecode(res.body));
        // Decode the JSON response
        // final List<dynamic> data = jsonDecode(res.body);
        // print(data);

        // Map JSON data to Course instances
      } else {
        // Handle non-200 status codes
      }
    } catch (err) {
      // Handle any errors
    }
    return course;
  }

  Future<bool> enrollCourse(BuildContext context, String courseId) async {
    try {
      // Make the HTTP GET request
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final String? token = sharedPreferences.getString("x-auth-token");
      http.Response res = await http.post(
        Uri.parse('$URL/course/enrollCourse'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'courseId': courseId,
          'x-auth-token': token!
        },
      );
      // Check if the request was successful
      if (res.statusCode == 200) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.enrollCourse(courseId);
        return true;
      } else {
        // Handle non-200 status codes
        return false;
      }
    } catch (err) {}
    return false;
  }

  bool isEnrolled(BuildContext context, String courseId) {
    try {
      final user = Provider.of<UserProvider>(context, listen: false).user;
      final enrolledCourses = user.enrolledCourses;
      for (EnrolledCourse enrolledCourse in enrolledCourses) {
        if (enrolledCourse.courseId == courseId) return true;
      }
      return false;
    } catch (err) {}
    return false;
  }

  Future<void> updateCompletedLessonNumber(
    BuildContext context,
    String courseId,
    int completedLessonNo,
  ) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final String? token = sharedPreferences.getString("x-auth-token");

      http.Response res = await http.patch(
        Uri.parse('$URL/course/updateCompletedLesson'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
        body: jsonEncode({
          "courseId": courseId,
          "completedLessonNo": completedLessonNo,
        }),
      );

      if (res.statusCode == 200) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setCompletedLessonNumber(courseId, completedLessonNo);
      } else {}
    } catch (err) {}
  }

  Future<void> postCourse(BuildContext context, Course course) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final String? token = sharedPreferences.getString("x-auth-token");

      http.Response res = await http.post(
        Uri.parse('$URL/course/addCourse'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
        body: jsonEncode(course),
      );
      if (res.statusCode == 200) {
        Navigator.pop(context);
        showCustomSnackBar(
          context,
          message: "The course has been successfully uploaded.",
          title: "Upload Successful",
          isSuccess: true,
        );
      } else {
        showCustomSnackBar(
          context,
          message: "There was an error uploading the course. Please try again.",
          title: "Upload Failed",
          isSuccess: false,
        );
      }
    } catch (err) {}
  }
}
