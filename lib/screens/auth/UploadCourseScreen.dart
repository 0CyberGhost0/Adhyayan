import 'package:adhyayan/Data_Models/courseModel.dart';
import 'package:adhyayan/services/CourseServices.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../commons/color.dart';

import '../../commons/utils.dart';
// Ensure you have this widget or adapt it if necessary

class UploadCoursePage extends StatefulWidget {
  @override
  _UploadCoursePageState createState() => _UploadCoursePageState();
}

class _UploadCoursePageState extends State<UploadCoursePage> {
  final TextEditingController _courseTitleController = TextEditingController();
  final TextEditingController _courseDescriptionController =
      TextEditingController();
  final TextEditingController _instructorController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final List<Lesson> _lessons = [];
  late String thumbnailUrl = "";

  File? _thumbnail;
  final ImagePicker _picker = ImagePicker();

  void _pickThumbnail() async {
    final pickedFile = await pickImage();
    if (pickedFile != null) {
      String imageUrl = await uploadToCloudinary(pickedFile);
      setState(() {
        thumbnailUrl = imageUrl;
        _thumbnail = File(pickedFile.path);
      });
    }
  }

  void _addLesson() {
    final TextEditingController _lessonTitleController =
        TextEditingController();
    final TextEditingController _lessonContentController =
        TextEditingController();
    File? _lessonVideo;
    bool _isUploading = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              backgroundColor: backGroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Text(
                    'Add Lesson',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: TColors.black,
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    TextField(
                      controller: _lessonTitleController,
                      decoration: inputDecoration(
                        labelText: 'Lesson Title',
                        prefixIcon: const Icon(Iconsax.text_block),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _lessonContentController,
                      maxLines: 3,
                      decoration: inputDecoration(
                        labelText: 'Lesson Content',
                        prefixIcon: const Icon(Iconsax.document),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          final pickedFile = await pickVideo();
                          if (pickedFile != null) {
                            setDialogState(() {
                              _lessonVideo = pickedFile;
                            });
                          }
                        },
                        child: DottedBorder(
                          color: Colors.grey,
                          strokeWidth: 2,
                          dashPattern: [8, 4],
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(12),
                          child: Container(
                            width: 200,
                            height: 150,
                            padding: const EdgeInsets.all(16),
                            child: _lessonVideo != null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/upload.png',
                                        height: 40,
                                      ),
                                      const SizedBox(width: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            _lessonVideo!.path.split('/').last,
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                                Iconsax.close_circle,
                                                color: Colors.red),
                                            onPressed: () {
                                              setDialogState(() {
                                                _lessonVideo = null;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/upload.png',
                                        height: 40,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Tap to upload video',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_isUploading)
                      const Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_lessonTitleController.text.isEmpty ||
                        _lessonContentController.text.isEmpty ||
                        _lessonVideo == null) {
                      showCustomSnackBar(
                        context,
                        title: 'Warning',
                        message:
                            'Please provide a lesson title, content, and upload a video.',
                        isSuccess: false,
                        isWarning: true,
                      );
                    } else {
                      setDialogState(() {
                        _isUploading = true;
                      });
                      // Upload the video and get the URL
                      String videoUrl = await uploadToCloudinary(_lessonVideo!);
                      setState(() {
                        _lessons.add(Lesson(
                          title: _lessonTitleController.text,
                          content: _lessonContentController.text,
                          url: videoUrl,
                        ));
                      });
                      setDialogState(() {
                        _isUploading = false;
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColour,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Add Lesson',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _submitCourse() {
    // Validate that all necessary fields are filled

    if (_courseTitleController.text.isEmpty ||
        _courseDescriptionController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _categoryController.text.isEmpty ||
        _lessons.isEmpty ||
        thumbnailUrl.isEmpty) {
      // Show a snackbar or dialog if any required field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Please fill in all required fields and add lessons')),
      );
      return;
    }

    // Try to parse the price and handle any parsing errors
    double? price;
    try {
      price = double.parse(_priceController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid price')),
      );
      return;
    }

    // Log the data for debugging purposes (can be removed in production)

    // Create the course object
    Course course = Course(
      title: _courseTitleController.text,
      description: _courseDescriptionController.text,
      instructor: _instructorController.text,
      price: price,
      rating:
          4.6, // Set a default rating or calculate from form input if applicable
      enrolledCount: 0, // Initially set to 0 for a new course
      thumbnailUrl:
          thumbnailUrl, // You can update this to include a file upload logic
      category: _categoryController.text, lessons: _lessons,
      // lessons: _lessons,
    );

    // Call the CourseServices to post the course
    CourseServices courseServices = CourseServices();
    courseServices.postCourse(context, course);
  }

  void _clearForm() {
    _courseTitleController.clear();
    _courseDescriptionController.clear();
    _instructorController.clear();
    _priceController.clear();
    _ratingController.clear();
    _categoryController.clear();
    _lessons.clear(); // Clear lessons list
    setState(() {}); // Update the UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Center(
          child: Text(
            "Upload Course",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: backGroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _pickThumbnail,
                  child: DottedBorder(
                    color: Colors.grey,
                    strokeWidth: 2,
                    dashPattern: const [8, 4],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      padding: const EdgeInsets.all(16),
                      child: _thumbnail != null
                          ? Image.file(
                              _thumbnail!,
                              fit: BoxFit.cover,
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/upload.png',
                                  height: 60,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Tap to upload course thumbnail',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Recommended size: 800x600',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _courseTitleController,
                  decoration: inputDecoration(
                    labelText: 'Course Title',
                    prefixIcon: const Icon(Iconsax.text_block),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _courseDescriptionController,
                  decoration: inputDecoration(
                    labelText: 'Course Description',
                    prefixIcon: const Icon(Iconsax.note),
                  ),
                ),

                const SizedBox(height: 16),
                TextField(
                    controller: _priceController,
                    decoration: inputDecoration(
                      labelText: 'Price',
                      prefixIcon: const Icon(Icons.currency_rupee),
                    )),

                const SizedBox(height: 16),
                TextField(
                  controller: _categoryController,
                  decoration: inputDecoration(
                    labelText: 'Category',
                    prefixIcon: const Icon(Iconsax.category),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _addLesson,
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: Text(
                      'Add Lesson',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColour,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Improved UI for displaying lessons
                for (var lesson in _lessons) ...[
                  Card(
                    color: backGroundColor,
                    margin: const EdgeInsets.only(
                        bottom: 12), // Reduced margin for card height
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12), // Reduced padding
                      leading: CircleAvatar(
                        radius: 20, // Smaller radius for a smaller circle
                        backgroundColor: Colors.grey[300],
                        child: Text(
                          (_lessons.indexOf(lesson) + 1).toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      title: Text(
                        lesson.title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            _lessons.remove(lesson);
                          });
                        },
                      ),
                    ),
                  ),
                ],
                const SizedBox(
                    height: 100), // Extra space to accommodate the fixed button
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitCourse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColour,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Submit Course',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Input decoration function
  InputDecoration inputDecoration({
    required String labelText,
    required Icon prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      errorMaxLines: 3,
      prefixIconColor: TColors.darkGrey,
      suffixIconColor: TColors.darkGrey,
      labelStyle: const TextStyle(
        fontSize: TSizes.fontSizeMd,
        color: TColors.black,
        fontWeight: FontWeight.bold,
      ),
      hintStyle: const TextStyle(
        fontSize: TSizes.fontSizeSm,
        color: TColors.black,
      ),
      errorStyle: const TextStyle(fontStyle: FontStyle.normal),
      floatingLabelStyle: TextStyle(
        color: TColors.black.withOpacity(0.8),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TSizes.inputFieldRadius),
        borderSide: const BorderSide(width: 1, color: TColors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TSizes.inputFieldRadius),
        borderSide: const BorderSide(width: 1, color: TColors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TSizes.inputFieldRadius),
        borderSide: const BorderSide(width: 1, color: TColors.dark),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TSizes.inputFieldRadius),
        borderSide: const BorderSide(width: 1, color: TColors.warning),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TSizes.inputFieldRadius),
        borderSide: const BorderSide(width: 2, color: TColors.warning),
      ),
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    );
  }
}
