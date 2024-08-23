import 'package:adhyayan/commons/color.dart';
// Import your Course model
import 'package:adhyayan/screens/course/courseDetailScreen.dart';
import 'package:adhyayan/services/AuthService.dart';
import 'package:adhyayan/services/CourseServices.dart';
import 'package:flutter/material.dart';
import '../Data_Models/courseModel.dart';

class PopularCourseCard extends StatelessWidget {
  final Course course;

  const PopularCourseCard({
    super.key,
    required this.course,
  });
  void saveCourse(String courseId) {
    CourseServices courseService = CourseServices();
    courseService.saveCourse(courseId);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailScreen(course: course),
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
                    image: DecorationImage(
                      image: NetworkImage(course.thumbnailUrl),
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
                      '\$${course.price.toStringAsFixed(2)}',
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
                        course.category.toUpperCase(),
                        style: TextStyle(
                          color: progressIndicatorColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        course.title,
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
                        '${course.lessons.length} Lessons  •  Approx ${course.lessons.length * 3} Hours', // Example logic for duration
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Bookmark Image inside a Container
                GestureDetector(
                  onTap: () {
                    saveCourse(course.id!);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: categoryBoxColor,
                      shape: BoxShape.circle, // Background color for the image
                    ),
                    child: Image.asset(
                      'assets/images/bookmark2.png',
                      width: 20, // Adjust width if needed
                      height: 20, // Adjust height if needed
                    ),
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
