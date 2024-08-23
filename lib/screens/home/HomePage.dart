import 'package:adhyayan/Data_Models/courseModel.dart';
import 'package:adhyayan/commons/color.dart';
import 'package:adhyayan/screens/home/searchScreen.dart';
import 'package:adhyayan/services/CourseServices.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../widgets/categoryIcon.dart';
import '../../widgets/continueLearningCard.dart';
import '../../widgets/popularCourse.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final tempCourse = Course.sample();
  final List<Course> enrolledCourses = [];
  List<Course> popularCourses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getPopularCourse();
  }

  Future<void> getPopularCourse() async {
    try {
      CourseServices _courseService = CourseServices();
      final fetchedCourses = await _courseService.getPopularCourse();
      setState(() {
        popularCourses = fetchedCourses;
        isLoading = false;
      });
    } catch (error) {
      print('Failed to fetch popular courses: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(
          Icons.menu,
          color: Colors.black,
          size: 28,
        ),
        title: Align(
          alignment: Alignment.center,
          child: Text(
            "Adhyayan",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              'assets/images/notification.png',
              width: 26,
              height: 26,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(),
                  ),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/search.png',
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'What do you want to learn today?',
                          border: InputBorder.none,
                        ),
                        enabled: false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CategoryIcon(title: 'Design'),
                CategoryIcon(title: 'Code'),
                CategoryIcon(title: 'Business'),
                CategoryIcon(title: 'Data'),
                CategoryIcon(title: 'Finance'),
              ],
            ),
            const SizedBox(height: 22),
            Text(
              "Continue Learning",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ContinueLearningCard(
              course: tempCourse,
              lessonsCompleted: 2,
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Popular Course",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Handle 'View All' action
                  },
                  child: Text(
                    'View All',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: progressIndicatorColor,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            isLoading
                ? ShimmerSkelton()
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: popularCourses.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: PopularCourseCard(
                          course: popularCourses[index],
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

class ShimmerSkelton extends StatelessWidget {
  const ShimmerSkelton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      ),
    );
  }
}
