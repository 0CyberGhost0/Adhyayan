import 'package:adhyayan/commons/color.dart';
import 'package:adhyayan/screens/course/courseDetailScreen.dart';
import 'package:flutter/material.dart';
import '../Data_Models/courseModel.dart';

class ContinueLearningCard extends StatelessWidget {
  final Course course;
  const ContinueLearningCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    // Example progress value, replace with actual calculation
    double progress = 0.72;

    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CourseDetailScreen()));
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
                image: const DecorationImage(
                  image: AssetImage('assets/images/uiux.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 20),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "DESIGN",
                    style: TextStyle(
                        color: categoryFontColor, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    'UI/UX Design',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text('12/16 Lessons',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      )),
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
