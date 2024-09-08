import 'package:adhyayan/commons/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Import the package

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Your logo or any image here
              const SizedBox(height: 20),
              // Dotted Circular Progress Indicator from flutter_spinkit
              const SpinKitCircle(
                color: buttonColour, // You can change the color as needed
                size: 100.0, // Increase the size
              ),
              const SizedBox(height: 20),
              const Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
