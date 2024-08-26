import 'package:adhyayan/services/CourseServices.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../commons/color.dart';

class EnrollButton extends StatefulWidget {
  final String courseID;
  final VoidCallback onTap;
  const EnrollButton({super.key, required this.courseID, required this.onTap});

  @override
  State<EnrollButton> createState() => _EnrollButtonState();
}

class _EnrollButtonState extends State<EnrollButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
        left: 18,
        right: 18,
      ),
      child: ElevatedButton(
        onPressed: widget.onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColour,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Enroll Course - \$300',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
