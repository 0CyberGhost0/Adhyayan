import 'package:adhyayan/Data_Models/courseModel.dart';
import 'package:adhyayan/commons/color.dart';
import 'package:adhyayan/services/CourseServices.dart';
import 'package:adhyayan/widgets/mentorCard.dart';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:google_fonts/google_fonts.dart';

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

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose(); // Dispose the video player controller
    _customVideoPlayerController
        .dispose(); // Dispose the custom video player controller
    super.dispose();
  }

  final String sampleNetworkVideo =
      "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";

  void initializeVideoPlayer() {
    _videoPlayerController =
        CachedVideoPlayerController.network(sampleNetworkVideo)
          ..initialize().then((_) {
            if (mounted) {
              setState(() {});
            }
          }).catchError((error) {
            setState(() {
              _videoLoadError = true;
            });
          });

    // Listen to the video state to detect completion
    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.position >=
          _videoPlayerController.value.duration) {
        print("video complete");
        CourseServices courseServices = CourseServices();
        courseServices.updateCompletedLessonNumber(
            context, widget.course.id!, widget.index);
        setState(() {
          widget.course.lessons[widget.index].completed = true;
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
    return SafeArea(
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
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: backGroundColor,
          elevation: 0,
          centerTitle: true,
          toolbarHeight: 80,
        ),
        body: Column(
          children: [
            // Video Player
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
                      ? CustomVideoPlayer(
                          customVideoPlayerController:
                              _customVideoPlayerController,
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
            ),
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Lesson Title
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

                    // Lesson Description
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                      child: Text(
                        widget.course.lessons[widget.index].content,
                        style: const TextStyle(
                            fontSize: 16.0, color: Colors.black87),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                      child: Text(
                        "Upcoming Lessons",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

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
                    // Mentor Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: MentorCard(
                        mentorName: "Ved Prakash",
                        mentorTitle: 'Coding',
                        mentorImage: "assets/images/mentor.png",
                        rating: 5.6,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
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
