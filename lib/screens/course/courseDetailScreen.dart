import 'package:adhyayan/Data_Models/notificationModel.dart';

import 'package:adhyayan/provider/userProvider.dart';
import 'package:adhyayan/screens/course/videoPlayerScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:adhyayan/commons/color.dart';
import 'package:adhyayan/services/CourseServices.dart';
import 'package:adhyayan/widgets/courseLessonList.dart';
import 'package:adhyayan/widgets/EnrollButton.dart';
import 'package:adhyayan/widgets/mentorCard.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../Data_Models/courseModel.dart';
import '../../commons/utils.dart';
import '../../provider/notficationProvider.dart';

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
    showCustomSnackBar(
      context,
      message:
          "Your payment has been processed successfully. Thank you for your purchase!",
      title: "Payment Successful",
      isSuccess: true,
    );

    _enrollCourse();
    String formattedTime =
        DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());

    // Add notification for successful payment
    Provider.of<NotificationProvider>(context, listen: false)
        .addNotification(NotificationModel(
      icon: Icons.monetization_on_outlined,
      title: 'Payment Successful',
      description: 'You have successfully enrolled in ${widget.course.title}.',
      time: formattedTime,
      statusColor: Colors.green,
    ));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showCustomSnackBar(
      context,
      message:
          "We were unable to process your payment. Please check your details and try again, or contact your bank.",
      title: "Payment Failed!",
      isSuccess: false,
    );
    String formattedTime =
        DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());
    // Add notification for failed payment
    Provider.of<NotificationProvider>(context, listen: false).addNotification(
      NotificationModel(
        icon: Icons.monetization_on_outlined,
        title: 'Payment Failed',
        description:
            'Your payment for ${widget.course.title} was not successful. If money was deducted, it will be refunded.',
        time: formattedTime,
        statusColor: Colors.red,
      ),
    );
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

  void _openVideoPlayer(int index) async {
    final bool? isCompleted = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          course: widget.course,
          index: index,
        ),
      ),
    );

    // Update the lesson completion status if the video was completed
    if (isCompleted == true) {
      setState(() {
        widget.course.lessons[index].completed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: backGroundColor,
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
                          onTap: () {
                            _openVideoPlayer(index);
                          },
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
