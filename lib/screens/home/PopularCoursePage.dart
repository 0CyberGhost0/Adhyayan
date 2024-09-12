import 'package:flutter/material.dart';
import 'package:adhyayan/Data_Models/courseModel.dart';
import 'package:adhyayan/services/CourseServices.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../commons/color.dart';
import '../../widgets/PopularCardShimmer.dart';
import '../../widgets/popularCourse.dart'; // Assuming you have a shimmer effect widget

class PopularCourseScreen extends StatefulWidget {
  const PopularCourseScreen({super.key});

  @override
  State<PopularCourseScreen> createState() => _PopularCourseScreenState();
}

class _PopularCourseScreenState extends State<PopularCourseScreen> {
  bool isLoading = true;
  List<Course> popularCourses = [];

  Future<void> getPopularCourse() async {
    try {
      CourseServices courseService = CourseServices();
      final fetchedCourses = await courseService.getPopularCourse();
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        popularCourses = fetchedCourses;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPopularCourse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 28,
          ),
        ),
        title: Align(
          alignment: Alignment.center,
          child: Text(
            "Popular Courses             ",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? ListView.builder(
                itemCount: 3, // Shimmer effect with 3 placeholders
                itemBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child:
                        PopularCourseCardShimmer(), // Placeholder shimmer effect
                  );
                },
              )
            : ListView.builder(
                itemCount: popularCourses.length, // Number of courses fetched
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PopularCourseCard(
                      course: popularCourses[index], // Display each course
                    ),
                  );
                },
              ),
      ),
    );
  }
}
