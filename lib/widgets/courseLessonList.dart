import 'package:adhyayan/Data_Models/courseModel.dart';
import 'package:adhyayan/commons/color.dart';
import 'package:adhyayan/screens/course/videoPlayerScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Data_Models/courseModel.dart';

class CourseListItem extends StatefulWidget {
  final Course course;
  final int index;
  bool isEnrolled;

  CourseListItem(
      {Key? key,
      required this.course,
      required this.isEnrolled,
      required this.index})
      : super(key: key);

  @override
  State<CourseListItem> createState() => _CourseListItemState();
}

class _CourseListItemState extends State<CourseListItem> {
  void getLessonVideo() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          course: widget.course,
          index: widget.index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isEnrolled ? getLessonVideo : () {},
      child: Container(
        margin:
            const EdgeInsets.symmetric(vertical: 8), // Adjust margin as needed
        decoration: BoxDecoration(
          color: Colors.white, // Background color
          borderRadius: BorderRadius.circular(12), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Shadow color
              spreadRadius: 2, // Spread radius
              blurRadius: 5, // Blur radius
              offset: const Offset(0, 5), // Offset in x and y
            ),
          ],
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(9.0), // Adjust padding as needed
            decoration: const BoxDecoration(
              color: Color(0xffe6e1fa), // Grey background color
              shape: BoxShape.circle, // Circular shape
            ),
            child: Image.asset(
              "assets/images/play.png",
              width: 25,
              height: 25,
            ),
          ),
          title: Text(
            widget.course.lessons[widget.index].title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          subtitle: Text("1 hrs"),
          trailing: !widget.isEnrolled
              ? Image.asset(
                  "assets/images/lock.png",
                  width: 26,
                  height: 26,
                )
              : null,
        ),
      ),
    );
  }
}
