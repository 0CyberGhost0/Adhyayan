import 'package:adhyayan/commons/color.dart';
import 'package:adhyayan/provider/userProvider.dart';
import 'package:adhyayan/screens/course/courseDetailScreen.dart';
import 'package:adhyayan/services/CourseServices.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
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
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 160,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      widget.course.thumbnailUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 160,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: double.infinity,
                              height: 160,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          );
                        }
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 160,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.error,
                              color: Colors.red,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
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
            const SizedBox(height: 12),
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
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.course.lessons.length} Lessons  •  Approx ${widget.course.lessons.length * 3} Hours',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: isBookmarked ? unsaveCourse : saveCourse,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: categoryBoxColor,
                      shape: BoxShape.circle,
                    ),
                    child: isBookmarked
                        ? Image.asset(
                            'assets/images/bookmark2.png',
                            width: 20,
                            height: 20,
                          )
                        : Image.asset(
                            'assets/images/bookmark1.png',
                            width: 20,
                            height: 20,
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
