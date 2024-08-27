import 'package:adhyayan/Data_Models/userModel.dart';
import 'package:adhyayan/commons/color.dart';
import 'package:adhyayan/provider/userProvider.dart';
import 'package:adhyayan/screens/course/courseDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Data_Models/courseModel.dart';

class ContinueLearningCard extends StatefulWidget {
  final Course course;
  final int lessonsCompleted;

  const ContinueLearningCard(
      {super.key, required this.course, required this.lessonsCompleted});

  @override
  State<ContinueLearningCard> createState() => _ContinueLearningCardState();
}

class _ContinueLearningCardState extends State<ContinueLearningCard> {
  @override
  void initState() {
    print("inside continue learning");
    getLessonCompleted();
    super.initState();
  }

  void getLessonCompleted() {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    for (EnrolledCourse savedCourse in user.enrolledCourses) {
      print(savedCourse.toJson());
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = 0;
    if (widget.course.lessons.isNotEmpty) {
      progress =
          ((1 + widget.lessonsCompleted) / (widget.course.lessons.length));
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailScreen(
              course: widget.course,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(widget.course.thumbnailUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.course.category.toUpperCase(),
                    style: TextStyle(
                        color: categoryFontColor, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    widget.course.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.lessonsCompleted + 1}/${widget.course.lessons.length} Lessons',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 50, // Increase width to make the progress indicator larger
              height:
                  50, // Increase height to make the progress indicator larger
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[300],
                    color: progressIndicatorColor,
                    strokeWidth: 4,
                  ),
                  Text(
                    '${(progress * 100).toInt()}%', // Display percentage
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
