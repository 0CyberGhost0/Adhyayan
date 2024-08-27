import 'package:adhyayan/commons/color.dart';
import 'package:adhyayan/provider/userProvider.dart';
import 'package:adhyayan/widgets/PopularCardShimmer.dart';
import 'package:adhyayan/widgets/popularCourse.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../Data_Models/courseModel.dart';
import '../../services/CourseServices.dart';

class SavedCourse extends StatefulWidget {
  const SavedCourse({super.key});

  @override
  State<SavedCourse> createState() => _SavedCourseState();
}

class _SavedCourseState extends State<SavedCourse> {
  List<Course> savedCourses = [];
  List<Course> filteredCourses = [];
  bool isLoading = true; // To manage loading state
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchSavedCourses();
    searchController.addListener(_filterCourses);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchSavedCourses() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final List<String> savedCourseIds = user.savedCourses;
    CourseServices courseServices = CourseServices();

    List<Course> fetchedCourses = [];
    for (String courseId in savedCourseIds) {
      try {
        Course? course = await courseServices.getCourseById(courseId);
        fetchedCourses.add(course);
      } catch (e) {
        print('Failed to fetch course with ID $courseId: $e');
      }
    }

    setState(() {
      savedCourses = fetchedCourses;
      filteredCourses = fetchedCourses; // Initially, show all saved courses
      isLoading = false; // Set to false once data is loaded
    });
  }

  void _filterCourses() {
    String searchTerm = searchController.text.toLowerCase();

    setState(() {
      filteredCourses = savedCourses
          .where((course) => course.title.toLowerCase().contains(searchTerm))
          .toList();
    });
  }

  void unsaveCourse(String courseId) {
    CourseServices courseService = CourseServices();
    courseService.unsaveCourse(courseId, context);
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
              const SizedBox(height: 20),
              // Row with "Saved Courses" title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Saved Courses",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Search Bar with updated styling
              GestureDetector(
                onTap: () {
                  // Handle search bar tap if needed
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1), // Shadow color
                        spreadRadius: 1, // Spread radius
                        blurRadius: 4, // Blur radius
                        offset:
                            const Offset(0, 4), // Offset in x and y direction
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: searchController, // Attach controller here
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
              ),
              const SizedBox(height: 20),

              // Display the shimmer effect while loading
              if (isLoading)
                Expanded(
                  child: ListView.builder(
                    itemCount: 2, // Show 2 shimmer placeholders
                    itemBuilder: (context, index) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child:
                            PopularCourseCardShimmer(), // Shimmer placeholder
                      );
                    },
                  ),
                )
              // Display "Search Course" when there are no courses
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
                          "No Courses Found",
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
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 14.0,
                          vertical: 10.0,
                        ), // Add margin to prevent shadow cutoff
                        child: Dismissible(
                          // Unique key based on course ID
                          key: Key(filteredCourses[index].id!),
                          direction:
                              DismissDirection.endToStart, // Swipe direction
                          onDismissed: (direction) {
                            setState(() {
                              String courseId = filteredCourses[index].id!;
                              unsaveCourse(
                                  courseId); // Call unsaveCourse function to remove the course

                              // Remove the dismissed course from both lists
                              savedCourses.removeWhere(
                                  (course) => course.id == courseId);
                              filteredCourses.removeAt(
                                  index); // Remove from the filtered list
                            });
                          },
                          background: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.centerRight,
                            color: Colors
                                .transparent, // Background color when swiped
                            child: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                          ),
                          child: PopularCourseCard(
                            course: filteredCourses[index],
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
