import 'package:adhyayan/commons/color.dart';
import 'package:adhyayan/screens/MyCourse.dart';
import 'package:adhyayan/screens/course/savedCourse.dart';
import 'package:adhyayan/screens/home/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: Center(
        child: _getSelectedPage(_selectedIndex),
      ),
      bottomNavigationBar: Padding(
        padding:
            const EdgeInsets.only(left: 16.0, right: 16, top: 12, bottom: 16),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            // color: backGroundColor,
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(35), // Circular shape
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // Shadow color
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 5), // Offset in x and y
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: NavigationBar(
              backgroundColor: Colors.white,
              height: 60, // Adjusted height for better visibility
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              destinations: const [
                NavigationDestination(icon: Icon(Iconsax.home), label: "Home"),
                NavigationDestination(
                    icon: Icon(Iconsax.shop), label: "Course"),
                NavigationDestination(
                    icon: Icon(Iconsax.bookmark), label: "Saved"),
                NavigationDestination(
                    icon: Icon(Iconsax.user), label: "Profile"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getSelectedPage(int index) {
    switch (index) {
      case 0:
        return HomePage(); // Replace with actual HomeScreen widget
      case 1:
        return MyCoursePage(); // Replace with actual CourseScreen widget
      case 2:
        return SavedCourse(); // Replace with actual SavedScreen widget
      case 3:
        return const Text(
            "Profile Screen"); // Replace with actual ProfileScreen widget
      default:
        return const Text("Home Screen");
    }
  }
}
