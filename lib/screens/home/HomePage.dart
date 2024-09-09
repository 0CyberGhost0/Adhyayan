import 'package:adhyayan/Data_Models/courseModel.dart';
import 'package:adhyayan/Data_Models/userModel.dart';

import 'package:adhyayan/commons/color.dart';
import 'package:adhyayan/provider/userProvider.dart';
import 'package:adhyayan/screens/auth/UploadCourseScreen.dart';

import 'package:adhyayan/screens/course/courseDetailScreen.dart';
import 'package:adhyayan/screens/home/NavBar.dart';
import 'package:adhyayan/screens/home/NotificationDrawer.dart';
import 'package:adhyayan/screens/home/PopularCoursePage.dart';
import 'package:adhyayan/screens/home/searchScreen.dart';
import 'package:adhyayan/services/CourseServices.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../provider/notficationProvider.dart';
import '../../widgets/PopularCardShimmer.dart';
import '../../widgets/categoryIcon.dart';
import '../../widgets/continueLearningCard.dart';
import '../../widgets/continueLearningShimmer.dart';
import '../../widgets/popularCourse.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Course recentCourse = Course(
    title: '',
    description: '',
    instructor: '',
    price: 0,
    rating: 0,
    enrolledCount: 0,
    thumbnailUrl: '',
    category: '',
    lessons: [],
  );

  List<Course> popularCourses = [];
  bool isLoading = true;
  bool hasCourse = false;
  int lessonCompleted = 0;

  @override
  void initState() {
    super.initState();
    getPopularCourse();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userProvider = Provider.of<UserProvider>(context);
    hasCourse = userProvider.user.enrolledCourses.isNotEmpty;
    if (hasCourse) {
      getRecentCourse();
    }
  }

  Future<void> getRecentCourse() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final EnrolledCourse enrolledCourse = user.enrolledCourses.first;
    lessonCompleted = enrolledCourse.completedLessonNo;

    CourseServices courseServices = CourseServices();
    Course fetchedCourse =
        await courseServices.getCourseById(enrolledCourse.courseId);

    if (!mounted) return; // Check if the widget is still mounted
    setState(() {
      recentCourse = fetchedCourse;
    });
  }

  Future<void> getPopularCourse() async {
    try {
      CourseServices courseService = CourseServices();
      final fetchedCourses = await courseService.getPopularCourse();
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        popularCourses = fetchedCourses;
        isLoading = false;
      });
    } catch (error) {
      print('Failed to fetch popular courses: $error');
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: NavBar(),
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black, size: 28),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
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
            child: Consumer<NotificationProvider>(
              builder: (context, notificationProvider, child) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      icon: Image.asset(
                        'assets/images/notification.png',
                        width: 26,
                        height: 26,
                      ),
                      onPressed: () {
                        // Mark all notifications as read when the dialog is shown
                        notificationProvider.markAllAsRead();
                        showDialog(
                          context: context,
                          builder: (context) => NotificationDialog(),
                        );
                      },
                    ),
                    if (notificationProvider.unreadNotificationCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2.0,
                            horizontal: 6.0,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Center(
                            child: Text(
                              '${notificationProvider.unreadNotificationCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(),
                  ),
                ).then((_) {
                  getPopularCourse(); // Refresh after returning from SearchScreen
                });
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
            if (hasCourse) ...[
              Text(
                "Continue Learning",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              recentCourse.title.isEmpty
                  ? const ContinueLearningCardShimmer()
                  : ContinueLearningCard(
                      course: recentCourse,
                      lessonsCompleted: lessonCompleted,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CourseDetailScreen(course: recentCourse)));
                      },
                    ),
              const SizedBox(height: 24),
            ],
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PopularCourseScreen()));
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
            const SizedBox(height: 16),
            isLoading
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return const Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: PopularCourseCardShimmer(),
                      );
                    },
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
