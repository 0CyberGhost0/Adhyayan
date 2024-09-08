import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:collection';
import '../../Data_Models/courseModel.dart';
import '../../Data_Models/userModel.dart';
import '../../commons/color.dart';
import '../../provider/userProvider.dart';
import '../../services/CourseServices.dart';
import '../../widgets/continueLearningCard.dart';
import '../../widgets/continueLearningShimmer.dart';
import 'courseDetailScreen.dart';

class MyCoursePage extends StatefulWidget {
  const MyCoursePage({super.key});

  @override
  State<MyCoursePage> createState() => _MyCoursePageState();
}

class _MyCoursePageState extends State<MyCoursePage> {
  LinkedHashMap<Course, int> myCourses = LinkedHashMap<Course, int>();
  LinkedHashMap<Course, int> filteredCourses = LinkedHashMap<Course, int>();
  bool isLoading = true; // Add a loading state
  String searchTerm = '';

  @override
  void initState() {
    super.initState();
    fetchMyCourses();
  }

  void fetchMyCourses() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<EnrolledCourse> enrolledCourses = userProvider.user.enrolledCourses;

    // Use a map to track course IDs and their completed lesson numbers
    Map<String, int> courseIdToLessonsCompleted = {};

    for (EnrolledCourse enrolledCourse in enrolledCourses) {
      String courseId = enrolledCourse.courseId;
      CourseServices courseServices = CourseServices();
      Course? course = await courseServices.getCourseById(courseId);

      if (course != null) {
        courseIdToLessonsCompleted[courseId] = enrolledCourse.completedLessonNo;
      }
    }

    // Fetch all courses once and map them to lessons completed
    LinkedHashMap<Course, int> tempCourses = LinkedHashMap<Course, int>();
    for (var entry in courseIdToLessonsCompleted.entries) {
      Course? course = await CourseServices().getCourseById(entry.key);
      if (course != null) {
        tempCourses[course] = entry.value;
      }
    }

    setState(() {
      myCourses = tempCourses;
      isLoading = false; // Update the loading state
      applySearchFilter(); // Apply search filter initially
    });
  }

  void applySearchFilter() {
    if (searchTerm.isEmpty) {
      setState(() {
        filteredCourses = LinkedHashMap<Course, int>.from(myCourses);
      });
    } else {
      setState(() {
        filteredCourses = LinkedHashMap<Course, int>.fromEntries(
          myCourses.entries.where((entry) =>
              entry.key.title.toLowerCase().contains(searchTerm.toLowerCase())),
        );
      });
    }
  }

  void _navigateToCourseDetail(Course course) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailScreen(course: course),
      ),
    );

    // Fetch courses again after returning from CourseDetailScreen
    fetchMyCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              // Row with "My Courses" and result count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My Courses",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // Shadow color
                      spreadRadius: 1, // Spread radius
                      blurRadius: 4, // Blur radius
                      offset: const Offset(0, 4), // Offset in x and y direction
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchTerm = value;
                      applySearchFilter();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Discover your next lesson",
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(
                          12.0), // Adjust padding as needed
                      child: Image.asset(
                        'assets/images/search.png',
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Display "Search Course" when there are no courses
              if (isLoading) // Show shimmer when loading
                Expanded(
                  child: ListView.builder(
                    itemCount: 5, // Example shimmer items
                    itemBuilder: (context, index) {
                      return const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: ContinueLearningCardShimmer(),
                      );
                    },
                  ),
                )
              else if (filteredCourses.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/searchImage.png",
                          width: 150,
                          height: 150,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Search Course",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              // Display the courses if available
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredCourses.length,
                    itemBuilder: (context, index) {
                      // Get the course and completed lessons from the filtered map
                      final course = filteredCourses.keys.elementAt(index);
                      final lessonsCompleted = filteredCourses[course] ?? 0;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 14.0,
                          ), // Add margin to prevent shadow cutoff
                          child: ContinueLearningCard(
                            course: course,
                            lessonsCompleted: lessonsCompleted,
                            onTap: () {
                              _navigateToCourseDetail(course);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
