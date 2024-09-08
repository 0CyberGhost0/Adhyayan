import 'dart:io';

import 'package:adhyayan/commons/color.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iconsax/iconsax.dart';

import '../services/AuthService.dart';

Future<File?> pickImage() async {
  File? image;
  try {
    var file = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (file != null && file.files.isNotEmpty) {
      image = File(file.files.single.path!);
    } else {
      print('No image selected.');
    }
  } catch (e) {
    print('Error picking image: $e');
  }
  return image;
}

Future<File?> pickVideo() async {
  File? video;
  try {
    var result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    if (result != null && result.files.isNotEmpty) {
      video = File(result.files.single.path!);
    } else {
      print('No video selected.');
    }
  } catch (e) {
    print('Error picking video: $e');
  }
  return video;
}

Future<String> uploadToCloudinary(File file) async {
  try {
    final cloudinary = CloudinaryPublic("dxa9xqx3t", "wqrufpob");
    CloudinaryResponse res = await cloudinary
        .uploadFile(CloudinaryFile.fromFile(file.path, folder: "Profile"));

    return res.secureUrl;
  } catch (e) {
    print(e);
  }
  return "";
}

void showCustomSnackBar(
  BuildContext context, {
  required String message,
  required String title,
  required bool isSuccess, // Determines if the notification is success
  bool isWarning = false, // Determines if the notification is a warning
}) {
  // Set image based on success, failure, or warning
  String imagePath;
  if (isWarning) {
    imagePath = 'assets/images/warning.png'; // Warning image
  } else {
    imagePath =
        isSuccess ? 'assets/images/success.png' : 'assets/images/failure.png';
  }

  // Set border color based on success, failure, or warning
  Color borderColor;
  if (isWarning) {
    borderColor = Color(0xffffd769); // Yellow for warning
  } else {
    borderColor = isSuccess
        ? Color(0xff50DC6C)
        : Color(0xfffc5758); // Green for success, red for failure
  }

  // Set background color based on success, failure, or warning
  Color backgroundColor;
  if (isWarning) {
    backgroundColor = Color(0xffFFF8E1); // Light yellow for warning
  } else {
    backgroundColor = isSuccess
        ? snackBarGreen
        : Color(0xffFAEEEB); // Green for success, light red for failure
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: backgroundColor,
      content: Row(
        children: [
          // Wrap the image inside a white container with padding
          Container(
            decoration: BoxDecoration(
              color: Colors.white, // White background for the image
              borderRadius: BorderRadius.circular(50), // Circular container
            ),
            padding: EdgeInsets.all(8), // Add some padding
            child: Image.asset(
              imagePath,
              height: 32,
              width: 32,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  message,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Iconsax.close_circle,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .hideCurrentSnackBar(); // Close the SnackBar
            },
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(
          color:
              borderColor, // Yellow for warning, dark green for success, dark red for failure
          width: 2.0,
        ),
      ),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(10),
    ),
  );
}
