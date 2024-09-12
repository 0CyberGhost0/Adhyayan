import 'dart:io';
import 'package:adhyayan/commons/utils.dart';
import 'package:adhyayan/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bottom_navigation.dart';
import '../../commons/color.dart';
import '../../provider/userProvider.dart';
import 'loginScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isUploadingProfilePic = false; // Add loading state for profile picture

  @override
  void initState() {
    super.initState();
    AuthService authService = AuthService();
    authService.getUserData(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;
    String profilePic = user.profilePictureUrl ??
        'https://res.cloudinary.com/dxa9xqx3t/image/upload/v1724310891/profileImage/jb2yekqpwv61rkh9wlpu.png'; // Fallback if null

    void selectImage() async {
      setState(() {
        _isUploadingProfilePic =
            true; // Show loading indicator for profile picture
      });

      File? res = await pickImage();
      if (res != null) {
        try {
          String newImage = await uploadToCloudinary(res);
          userProvider.saveProfilePicture(newImage);

          AuthService authService = AuthService();
          await authService.uploadProfilePic(
              context: context, imageUrl: newImage);

          setState(() {
            profilePic = newImage;
            _isUploadingProfilePic =
                false; // Hide loading indicator for profile picture
          });

          // Update the user model and notify listeners
          userProvider.saveProfilePicture(newImage);
        } catch (error) {
          setState(() {
            _isUploadingProfilePic = false; // Hide loading indicator on error
          });
          // Handle errors (e.g., show an error message)
        }
      } else {
        setState(() {
          _isUploadingProfilePic =
              false; // Hide loading indicator if no image selected
        });
      }
      print(profilePic);
    }

    Future<void> logoutUser() async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.remove("x-auth-token");
      Provider.of<UserProvider>(context, listen: false).clearData();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }

    void editPhoneNumber() {
      TextEditingController phoneController = TextEditingController();
      InputDecoration customInputDecoration({
        required String labelText,
        required Icon prefixIcon,
        Icon? suffixIcon,
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

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Rounded corners
            ),
            backgroundColor: backGroundColor, // Custom background color
            titlePadding: const EdgeInsets.all(20),
            contentPadding: const EdgeInsets.all(20),
            title: Center(
              child: Text(
                "Edit Phone Number",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Custom title color
                    ),
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Please enter your new phone number:',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                        ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: customInputDecoration(
                      labelText: 'New Phone Number',
                      prefixIcon:
                          const Icon(Icons.phone, color: TColors.darkGrey),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
            actionsPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text(
                      'Cancel',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.black, // Custom button text color
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 2,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor:
                          Theme.of(context).primaryColor, // Custom button color
                    ),
                    onPressed: () async {
                      String newPhoneNumber = phoneController.text.trim();

                      if (newPhoneNumber.isEmpty ||
                          newPhoneNumber.length < 10) {
                        showCustomSnackBar(
                          context,
                          message: 'Please enter a valid phone number',
                          title: "Incorrect Phone Number",
                          isSuccess: false,
                          isWarning: true,
                        );
                        return;
                      }

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      );

                      try {
                        user.phone = newPhoneNumber;
                        userProvider.updatePhoneNumber(newPhoneNumber);

                        AuthService authService = AuthService();
                        await authService.updatePhoneNumber(
                          context: context,
                          phoneNumber: newPhoneNumber,
                        );
                        setState(() {
                          user.phone = newPhoneNumber;
                        });
                        Navigator.of(context, rootNavigator: true)
                            .pop(); // Close progress indicator
                        Navigator.of(context).pop(); // Close the dialog
                      } catch (error) {
                        Navigator.of(context, rootNavigator: true)
                            .pop(); // Close progress indicator
                      }
                    },
                    child: Text(
                      'Save',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Custom button text color
                          ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavigation()),
            (Route<dynamic> route) => false,
          ),
        ),
        title: Center(
          child: Text(
            'User Profile           ',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Avatar Image
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blue,
                    backgroundImage: NetworkImage(profilePic),
                  ),
                  if (_isUploadingProfilePic) // Show loading indicator only if uploading
                    const Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child:
                            const CircularProgressIndicator(), // Show loading indicator
                      ),
                    ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: selectImage,
                      child: const CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.camera_alt,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            _buildInfoTile(
              icon: Iconsax.user,
              label: 'Name',
              value: "${user.firstName} ${user.lastName}",
            ),
            const SizedBox(height: 20),

            _buildInfoTile(
              icon: Icons.email_outlined,
              label: 'Email',
              value: user.email,
            ),
            const SizedBox(height: 20),

            _buildInfoTile(
              icon: Iconsax.user_octagon,
              label: 'Username',
              value: "@${user.firstName}",
            ),
            const SizedBox(height: 20),

            _buildInfoTile(
              icon: Icons.phone_outlined,
              label: 'Phone Number',
              value: user.phone,
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: editPhoneNumber,
              ),
            ),

            const SizedBox(height: 30),

            Center(
              child: ElevatedButton.icon(
                onPressed: logoutUser,
                icon: const Icon(Icons.logout, color: Colors.white),
                label: Text(
                  'Logout',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blueAccent.withOpacity(0.2),
            Colors.blueAccent.withOpacity(0.05)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 28),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }
}
