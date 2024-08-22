import 'package:adhyayan/commons/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CourseListItem extends StatelessWidget {
  final String title;
  final String duration;
  final bool isEnrolled;

  const CourseListItem({
    Key? key,
    required this.title,
    required this.duration,
    this.isEnrolled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(duration),
        trailing: !isEnrolled
            ? Image.asset(
                "assets/images/lock.png",
                width: 26,
                height: 26,
              )
            : null,
      ),
    );
  }
}
