import 'package:adhyayan/Data_Models/courseModel.dart';
import 'package:adhyayan/commons/color.dart';
import 'package:adhyayan/services/CourseServices.dart';
import 'package:adhyayan/widgets/CourseCard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/popularCourse.dart';

class CategoryScreen extends StatefulWidget {
  final String title;

  const CategoryScreen({
    super.key,
    required this.title,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Course> categoryCourses = [];
  @override
  void initState() {
    super.initState();
    fetchCourseData();
  }

  void fetchCourseData() async {
    CourseServices courseServices = CourseServices();
    List<Course> course = await courseServices.getCategoryCourse(widget.title);
    setState(() {
      categoryCourses = course;
    });
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
            "${widget.title} Courses             ",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two courses per row
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.7, // Adjust aspect ratio as needed
          ),
          itemCount: categoryCourses.length,
          itemBuilder: (context, index) {
            final course = categoryCourses[index];
            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: CourseCard(
                course: course,
              ),
            );
          },
        ),
      ),
    );
  }
}
