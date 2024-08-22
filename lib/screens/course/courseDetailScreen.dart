import 'package:adhyayan/commons/color.dart';
import 'package:adhyayan/widgets/courseLessonList.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/EnrollButton.dart';
import '../../widgets/mentorCard.dart';

class CourseDetailScreen extends StatefulWidget {
  final bool isEnrolled =
      false; // Add this parameter to handle enrollment status

  const CourseDetailScreen({super.key});

  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  bool isCourseSelected = true;

  void _toggleTab() {
    setState(() {
      isCourseSelected = !isCourseSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // Handle back button action
          },
        ),
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'Mastering Illustration',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/uiux.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      'Mentor',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20),
                    ),
                  ),
                  const MentorCard(
                    mentorName: 'Simon Simorangkir',
                    mentorTitle: 'Mentor • Illustrator at Google',
                    mentorImage: 'assets/images/mentor.png',
                    rating: 4.9,
                  ),
                  const SizedBox(height: 3),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffe6e1fa),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                if (!isCourseSelected) {
                                  _toggleTab();
                                }
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isCourseSelected
                                      ? buttonColour
                                      : const Color(0xffe6e1fa),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    'Course (25)',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      color: isCourseSelected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                if (isCourseSelected) {
                                  _toggleTab();
                                }
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isCourseSelected
                                      ? const Color(0xffe6e1fa)
                                      : buttonColour,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    'Description',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      color: isCourseSelected
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '25 Lessons • 72 Hours',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: isCourseSelected
                ? ListView.builder(
                    shrinkWrap: true, // Allows the ListView to wrap its content
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      // Set isEnrolled true for the first item, otherwise false
                      bool isEnrolled = index == 0 ? true : false;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: CourseListItem(
                          title: 'Introduction',
                          duration: '20 min',
                          isEnrolled: isEnrolled,
                        ),
                      );
                    },
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'This course on mastering illustration provides comprehensive training in the principles and techniques of digital and traditional illustration. Whether you’re a beginner or an experienced artist, this course is designed to help you refine your skills, understand key design concepts, and explore various styles and mediums. You’ll learn how to create stunning illustrations from concept to final piece, using tools like Adobe Illustrator, Photoshop, and Procreate. The course also covers important topics such as color theory, composition, and the creative process. With practical assignments and expert guidance, you’ll build a portfolio that showcases your unique artistic voice. This course is ideal for aspiring illustrators, graphic designers, and anyone interested in the visual arts.',
                      style: GoogleFonts.poppins(fontSize: 18),
                    ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: widget.isEnrolled ? null : EnrollButton(),
    );
  }
}
