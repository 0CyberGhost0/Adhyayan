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
      print("Popular called");
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
        print(searchText);
      } else {
        // Handle non-200 status codes
        print('Failed to load popular courses. Status code: ${res.statusCode}');
      }
    } catch (err) {
      print(err);
    }
    return searchResult;
  }

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

  Future<List<Course>> getCategoryCourse(
    String title,
  ) async {
    List<Course> categoryCourse = [];
    try {
      print("Category called");
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
        print(
            'Failed to load Category courses. Status code: ${res.statusCode}');
      }
    } catch (err) {
      // Handle any errors
      print('Error: $err');
    }
    return categoryCourse;
  }

  Future<void> saveCourse(
    final String courseId,
    final BuildContext context,
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
        },
        body: jsonEncode({"courseId": courseId}),
      );
      print(res.body);
      if (res.statusCode == 200) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        print("before set course");
        userProvider.saveCourse(courseId);
        print("after set course");
        print(userProvider.user.savedCourses);
      }
    } catch (err) {
      print("SAVING COURSE ERROR: $err");
    }
  }

  Future<void> unsaveCourse(
    final String courseId,
    final BuildContext context,
  ) async {
    try {
      print("UNSAVING COURSE: $courseId");
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final token = sharedPreferences.getString("x-auth-token");
      print("USER TOKEN IN UNSAVE COURSE : $token");
      http.Response res = await http.post(
        Uri.parse('$URL/course/unsaveCourse'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "x-auth-token": token!,
        },
        body: jsonEncode({"courseId": courseId}),
      );
      print(res.body);
      if (res.statusCode == 200) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        print("before set course");
        userProvider.unsaveCourse(courseId);
        print("after set course");
        print(userProvider.user.savedCourses);
      }
    } catch (err) {
      print("UNSAVING COURSE ERROR: $err");
    }
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
      print("get course detail");
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
        print('Failed to load courses detail. Status code: ${res.statusCode}');
      }
    } catch (err) {
      // Handle any errors
      print('Error: $err');
    }
    return course;
  }

  Future<bool> enrollCourse(BuildContext context, String courseId) async {
    try {
      print("inside enroll called");
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
      print("ENROLL COURSE : ${res.body}");
      // Check if the request was successful
      if (res.statusCode == 200) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.enrollCourse(courseId);
        return true;
      } else {
        // Handle non-200 status codes
        print(
            'Failed to Enroll in Course detail. Status code: ${res.statusCode}');
        return false;
      }
    } catch (err) {
      print(err);
    }
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
    } catch (err) {
      print(err);
    }
    return false;
  }

  Future<void> updateCompletedLessonNumber(
    BuildContext context,
    String courseId,
    int completedLessonNo,
  ) async {
    try {
      print("Updating completed lessons for course: $courseId");
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
        print("Completed lesson number updated successfully.");
      } else {
        print(
            'Failed to update completed lesson number. Status code: ${res.statusCode}');
      }
    } catch (err) {
      print("Updating completed lesson number error: $err");
    }
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
    } catch (err) {
      print(err);
    }
  }
}
