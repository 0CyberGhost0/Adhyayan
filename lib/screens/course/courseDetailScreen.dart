import 'package:adhyayan/commons/socialButton.dart';
import 'package:adhyayan/provider/userProvider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:adhyayan/commons/color.dart';
import 'package:adhyayan/services/CourseServices.dart';
import 'package:adhyayan/widgets/courseLessonList.dart';
import 'package:adhyayan/widgets/EnrollButton.dart';
import 'package:adhyayan/widgets/mentorCard.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../Data_Models/courseModel.dart';

class CourseDetailScreen extends StatefulWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  bool isCourseSelected = true;
  bool isEnrolled = false;
  Razorpay razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    isCourseEnrolled();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void isCourseEnrolled() async {
    CourseServices courseServices = CourseServices();
    bool enrolled = await courseServices.isEnrolled(context, widget.course.id!);
    setState(() {
      isEnrolled = enrolled;
    });
  }

  void _enrollCourse() async {
    CourseServices courseServices = CourseServices();
    final success =
        await courseServices.enrollCourse(context, widget.course.id!);
    if (success) {
      setState(() {
        isEnrolled = true;
      });
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("SUCCESSFUL!!")));
    _enrollCourse();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("FAILED!! : ${response.message}")));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

  @override
  void dispose() {
    razorpay.clear();
    super.dispose();
  }

  void _toggleTab() {
    setState(() {
      isCourseSelected = !isCourseSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Align(
          alignment: Alignment.center,
          child: Text(
            widget.course.title,
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
                      image: DecorationImage(
                        image: NetworkImage(widget.course.thumbnailUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      'Instructor',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  MentorCard(
                    mentorName: widget.course.instructor,
                    mentorTitle: 'Instructor • ${widget.course.category}',
                    mentorImage: 'assets/images/mentor.png',
                    rating: widget.course.rating,
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
                                    'Course (${widget.course.lessons.length})',
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
                  Text(
                    '${widget.course.lessons.length} Lessons • ${widget.course.enrolledCount} Enrolled',
                    style: const TextStyle(
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
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.course.lessons.length,
                    itemBuilder: (context, index) {
                      bool enrolled = isEnrolled &&
                          (userProvider.getCompletedLessonNumber(
                                  widget.course.id!) >=
                              index - 1);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: CourseListItem(
                          isEnrolled: enrolled || index == 0,
                          course: widget.course,
                          index: index,
                        ),
                      );
                    },
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      widget.course.description,
                      style: GoogleFonts.poppins(fontSize: 18),
                    ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: !isEnrolled
          ? EnrollButton(
              price: widget.course.price,
              courseID: widget.course.id!,
              onTap: () {
                var options = {
                  'key': 'rzp_test_T9pURegWa78aId',
                  'amount': widget.course.price * 100,
                  'name': 'Adhyayan Pvt Ltd',
                  'description': widget.course.title,
                  'prefill': {
                    'contact': userProvider.user.phone,
                    'email': userProvider.user.email,
                  }
                };
                razorpay.open(options);
              },
            )
          : null,
    );
  }
}
