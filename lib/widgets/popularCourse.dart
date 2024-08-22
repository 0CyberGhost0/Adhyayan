import 'package:adhyayan/commons/color.dart';
import 'package:adhyayan/screens/course/courseDetailScreen.dart';
import 'package:flutter/material.dart';

class PopularCourseCard extends StatelessWidget {
  const PopularCourseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailScreen(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15), // Shadow color
              spreadRadius: 2, // Spread radius
              blurRadius: 10, // Blur radius
              offset: const Offset(0, 5), // Offset in the x and y direction
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Image with Stack for Price Chip
            Stack(
              children: [
                // Course Image
                Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/blender.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Positioned Price Container with Rounded Corners
                Positioned(
                  top: 125,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '\$400',
                      style: TextStyle(
                        color: progressIndicatorColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            // Row with Texts and Bookmark Image
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DESIGN',
                        style: TextStyle(
                          color: progressIndicatorColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Create 3D With Blender',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '16 Lessons  •  48 Hours',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Bookmark Image inside a Container
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: categoryBoxColor,
                    shape: BoxShape.circle, // Background color for the image
                    // borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    'assets/images/bookmark2.png',
                    width: 20, // Adjust width if needed
                    height: 20, // Adjust height if needed
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
