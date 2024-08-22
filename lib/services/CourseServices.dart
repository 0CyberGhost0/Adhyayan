import 'dart:convert';

import 'package:adhyayan/Data_Models/courseModel.dart';
import 'package:http/http.dart' as http;

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
}
