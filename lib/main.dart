import 'package:adhyayan/bottom_navigation.dart';
import 'package:adhyayan/provider/notficationProvider.dart';
import 'package:adhyayan/provider/userProvider.dart';
import 'package:adhyayan/screens/auth/UploadCourseScreen.dart';
// Import the notification provider
import 'package:adhyayan/screens/auth/forgotPasswordScreen.dart';
import 'package:adhyayan/screens/auth/loginScreen.dart';
import 'package:adhyayan/screens/auth/signupScreen.dart';
import 'package:adhyayan/screens/auth/verify_email.dart';
import 'package:adhyayan/screens/course/videoPlayerScreen.dart';
import 'package:adhyayan/screens/home/HomePage.dart';
import 'package:adhyayan/screens/onboarding/splashScreen.dart';
import 'package:adhyayan/services/AuthService.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
      ],
      child: const AdhyayanApp(),
    );
  }
}

class AdhyayanApp extends StatefulWidget {
  const AdhyayanApp({super.key});

  @override
  State<AdhyayanApp> createState() => _AdhyayanAppState();
}

class _AdhyayanAppState extends State<AdhyayanApp> {
  bool _isLoading = true; // Add this flag to track loading state

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    AuthService authService = AuthService();
    await authService.getUserData(context: context);
    setState(() {
      _isLoading = false; // Set loading to false after fetching data
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Adhyayan',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontFamily: 'Poppins'),
          headlineLarge: TextStyle(fontFamily: 'Poppins'),
          headlineSmall: TextStyle(fontFamily: 'Poppins'),
          bodyLarge: TextStyle(fontFamily: 'Poppins'),
          bodyMedium: TextStyle(fontFamily: 'Poppins'),
          bodySmall: TextStyle(fontFamily: 'Poppins'),
          labelLarge: TextStyle(fontFamily: 'Poppins'),
          labelMedium: TextStyle(fontFamily: 'Poppins'),
        ),
      ),
      // Show SplashScreen if loading, else show the main screen
      home: _isLoading
          ? const SplashScreen() // Display the SplashScreen while loading
          : Provider.of<UserProvider>(context).user.token.isNotEmpty
              ? BottomNavigation()
              : LoginScreen(),
    );
  }
}
