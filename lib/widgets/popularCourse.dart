import 'package:adhyayan/commons/color.dart';
import 'package:adhyayan/provider/userProvider.dart';

import 'package:adhyayan/screens/course/courseDetailScreen.dart';
import 'package:adhyayan/services/AuthService.dart';
import 'package:adhyayan/services/CourseServices.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Data_Models/courseModel.dart';

class PopularCourseCard extends StatefulWidget {
  final Course course;

  const PopularCourseCard({
    super.key,
    required this.course,
  });

  @override
  State<PopularCourseCard> createState() => _PopularCourseCardState();
}

class _PopularCourseCardState extends State<PopularCourseCard> {
  bool isBookmarked = false;

  void saveCourse() async {
    CourseServices courseService = CourseServices();

    await courseService.saveCourse(widget.course.id!, context);
    setState(() {
      isBookmarked = !isBookmarked;
    });
  }

  void unsaveCourse() async {
    CourseServices courseService = CourseServices();

    await courseService.unsaveCourse(widget.course.id!, context);
    setState(() {
      isBookmarked = !isBookmarked;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final String currCourseId = widget.course.id!;
    bool flag = user.savedCourses.contains(currCourseId);
    setState(() {
      isBookmarked = flag;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailScreen(course: widget.course),
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
                      image: NetworkImage(widget.course.thumbnailUrl),
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
                      '\₹ ${widget.course.price.toInt()}',
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
                        widget.course.category.toUpperCase(),
                        style: TextStyle(
                          color: progressIndicatorColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.course.title,
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
                        '${widget.course.lessons.length} Lessons  •  Approx ${widget.course.lessons.length * 3} Hours', // Example logic for duration
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
                  onTap: isBookmarked ? unsaveCourse : saveCourse,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: categoryBoxColor,
                      shape: BoxShape.circle, // Background color for the image
                    ),
                    child: isBookmarked
                        ? Image.asset(
                            'assets/images/bookmark2.png',
                            width: 20, // Adjust width if needed
                            height: 20, // Adjust height if needed
                          )
                        : Image.asset(
                            'assets/images/bookmark1.png',
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
