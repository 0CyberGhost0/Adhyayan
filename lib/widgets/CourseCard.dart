import 'package:adhyayan/screens/course/courseDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:adhyayan/Data_Models/courseModel.dart';
import 'package:adhyayan/provider/userProvider.dart';
import 'package:adhyayan/services/CourseServices.dart';
import 'package:shimmer/shimmer.dart';
import '../commons/color.dart';

class CourseCard extends StatefulWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
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
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final String currCourseId = widget.course.id!;
    bool flag = user.savedCourses.contains(currCourseId);
    setState(() {
      isBookmarked = flag;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CourseDetailScreen(course: widget.course),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 8, // Blur radius
                  offset: const Offset(0, 4), // Offset in x and y direction
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumbnail
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.course.thumbnailUrl,
                        fit: BoxFit.fill,
                        width: double.infinity,
                        height: 100,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          }
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
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
                  const SizedBox(height: 8),
                  // Course Title
                  Text(
                    widget.course.title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Course Instructor
                  Text(
                    "${widget.course.instructor}",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Course Price
                  Text(
                    '  ₹ ${widget.course.price.toInt()}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Course Rating
                  Row(
                    children: [
                      Icon(
                        Iconsax.star1,
                        color: Colors.orange[400],
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.course.rating.toStringAsFixed(1),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        // Bookmark Icon
        Positioned(
          top: 180,
          right: 16,
          child: GestureDetector(
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
                      width: 18,
                      height: 18,
                    )
                  : Image.asset(
                      'assets/images/bookmark1.png',
                      width: 18,
                      height: 18,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
