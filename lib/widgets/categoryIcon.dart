import 'package:adhyayan/screens/home/categoryScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../commons/color.dart';

class CategoryIcon extends StatelessWidget {
  final String title;

  const CategoryIcon({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryScreen(title: title)));
      },
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            padding: const EdgeInsets.all(
                9), // Increased padding to reduce image size
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: Offset(0, 5),
                )
              ],
              color: categoryBoxColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Image.asset(
              "assets/images/$title.png",
              fit: BoxFit
                  .contain, // Use contain to ensure the image stays within the bounds
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
