import 'package:adhyayan/commons/color.dart';
import 'package:adhyayan/widgets/popularCourse.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Data_Models/courseModel.dart';
import '../../Data_Models/courseModel.dart';

class SavedCourse extends StatefulWidget {
  const SavedCourse({super.key});

  @override
  State<SavedCourse> createState() => _SavedCourseState();
}

class _SavedCourseState extends State<SavedCourse> {
  final List<Course> courses = [
    // Sample courses
    Course(
      id: "1",
      title: "Create 3D With Blender",
      description: "Learn the basics of 3D design with Blender.",
      instructor: "John Doe",
      price: 400,
      rating: 4.5,
      enrolledCount: 150,
      thumbnailUrl: "assets/images/blender.jpg",
      category: "DESIGN",
      lessons: ["Introduction", "Modeling", "Texturing", "Rendering"],
    ),
    Course(
      id: "2",
      title: "Mastering Flutter",
      description: "Master Flutter for building cross-platform apps.",
      instructor: "Jane Smith",
      price: 500,
      rating: 4.8,
      enrolledCount: 200,
      thumbnailUrl: "assets/images/flutter.jpg",
      category: "DEVELOPMENT",
      lessons: ["Setup", "Widgets", "State Management", "Deployment"],
    ),
  ];

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

              // Display "Search Course" when there are no courses
              if (courses.isEmpty)
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
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 14.0,
                          vertical: 10.0,
                        ), // Add margin to prevent shadow cutoff
                        child: const PopularCourseCard(),
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
