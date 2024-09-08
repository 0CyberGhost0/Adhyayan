import 'package:adhyayan/Data_Models/courseModel.dart';
import 'package:adhyayan/commons/color.dart';
import 'package:adhyayan/services/CourseServices.dart';
import 'package:adhyayan/widgets/mentorCard.dart';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Data_Models/notificationModel.dart';
import '../../provider/notficationProvider.dart';
import '../../widgets/courseLessonList.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Course course;
  final int index;

  const VideoPlayerScreen(
      {super.key, required this.course, required this.index});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late CustomVideoPlayerController _customVideoPlayerController;
  late CachedVideoPlayerController _videoPlayerController;
  bool _videoLoadError = false;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  final String sampleNetworkVideo =
      "https://res.cloudinary.com/dxa9xqx3t/video/upload/v1724822198/sampleVideo/SampleVideo_bohfbx.mp4";

  void initializeVideoPlayer() {
    _videoPlayerController = CachedVideoPlayerController.network(
        widget.course.lessons[widget.index].url)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      }).catchError((error) {
        setState(() {
          _videoLoadError = true;
        });
      });

    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.position >=
          _videoPlayerController.value.duration) {
        CourseServices courseServices = CourseServices();
        courseServices.updateCompletedLessonNumber(
            context, widget.course.id!, widget.index);
        if (widget.course.lessons[widget.index].completed == false) {
          if (widget.course.lessons.length - 1 == widget.index) {
            String formattedTime =
                DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());
            Provider.of<NotificationProvider>(context, listen: false)
                .addNotification(
              NotificationModel(
                icon: Icons.check_circle,
                title: '🎉 Congratulations!',
                description:
                    'You have successfully completed the course: ${widget.course.title}. Well done on your achievement!',
                time: formattedTime,
                statusColor: Colors.green,
              ),
            );
          }
        }
        setState(() {
          widget.course.lessons[widget.index].completed = true;
          _isCompleted = true;
        });
      }
    });

    _customVideoPlayerController = CustomVideoPlayerController(
      customVideoPlayerSettings: CustomVideoPlayerSettings(
        allowVolumeOnSlide: true,
      ),
      context: context,
      videoPlayerController: _videoPlayerController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_isCompleted);
        return false;
      },
      child: Scaffold(
        backgroundColor: backGroundColor,
        appBar: AppBar(
          title: Text(
            widget.course.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop(_isCompleted);
            },
          ),
          backgroundColor: backGroundColor,
          elevation: 0,
          centerTitle: true,
          toolbarHeight: 80,
        ),
        body: Column(
          children: [
            Container(
              height: 200,
              margin: const EdgeInsets.only(bottom: 20),
              child: _videoLoadError
                  ? Center(
                      child: Text(
                        'Failed to load video. Please check your connection.',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    )
                  : _videoPlayerController.value.isInitialized
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CustomVideoPlayer(
                            customVideoPlayerController:
                                _customVideoPlayerController,
                          ),
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        widget.course.lessons[widget.index].title,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                      child: Text(
                        widget.course.lessons[widget.index].content,
                        style: const TextStyle(
                            fontSize: 16.0, color: Colors.black87),
                      ),
                    ),

                    // Check if there is a next lesson

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                      child: Text(
                        "Instructor",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: MentorCard(
                        mentorName: widget.course.instructor,
                        mentorTitle: widget.course.category,
                        mentorImage: "assets/images/mentor.png",
                        rating: widget.course.rating,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
