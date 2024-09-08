import 'package:adhyayan/commons/color.dart';
import 'package:adhyayan/provider/userProvider.dart';
import 'package:adhyayan/screens/auth/loginScreen.dart';
import 'package:adhyayan/screens/auth/profileScreen.dart';
import 'package:adhyayan/screens/course/MyCourse.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/UploadCourseScreen.dart';
import '../course/categoryScreen.dart';

class CustomDrawer extends StatelessWidget {
  final Widget child;
  final double width;

  const CustomDrawer({
    Key? key,
    required this.child,
    this.width = 250.0, // Set default width
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Drawer(
        backgroundColor: backGroundColor,
        child: child,
      ),
    );
  }
}

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return CustomDrawer(
      width: 270, // Set your desired width here
      child: ListView(
        padding: EdgeInsets.all(0),
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              user.firstName +
                  " " +
                  user.lastName, // Fetch user's name from provider
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            accountEmail: Text(
              user.email, // Fetch user's email from provider
              style: const TextStyle(fontWeight: FontWeight.w300),
            ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: user.profilePictureUrl!.isNotEmpty
                    ? Image.network(
                        user.profilePictureUrl!,
                        fit: BoxFit.cover,
                        width: 90,
                        height: 90,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            "assets/images/mentor.png", // Placeholder image
                            fit: BoxFit.cover,
                            width: 90,
                            height: 90,
                          );
                        },
                      )
                    : Image.asset(
                        "assets/images/mentor.png", // Placeholder image
                        fit: BoxFit.cover,
                        width: 90,
                        height: 90,
                      ),
              ),
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background1.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Home
          ListTile(
            leading: Icon(Iconsax.home),
            title: Text("Home"),
            onTap: () {
              Navigator.of(context).pop();
              // Navigate to Home Page
            },
          ),
          // My Courses
          ListTile(
            leading: Icon(Iconsax.shop),
            title: Text("My Courses"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyCoursePage()),
              );
              // Navigate to My Courses Page
            },
          ),
          // Categories with dropdown menu using ExpansionTile
          ExpansionTile(
            showTrailingIcon: false,
            leading: Icon(Iconsax.category),
            title: Text("Categories"),
            children: [
              ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Text('Design'),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryScreen(title: "Design"),
                    ),
                  );
                },
              ),
              ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Text('Code'),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryScreen(title: "Code"),
                    ),
                  );
                },
              ),
              ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Text('Business'),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryScreen(title: "Business"),
                    ),
                  );
                },
              ),
              ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Text('Data'),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryScreen(title: "Data"),
                    ),
                  );
                },
              ),
              ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Text('Finance'),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryScreen(title: "Finance"),
                    ),
                  );
                },
              ),
            ],
          ),
          // Profile
          ListTile(
            leading: Icon(Iconsax.user),
            title: Text("Profile"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
          // Become a Mentor
          ListTile(
            leading: Icon(Iconsax.teacher),
            title: Text("Become a Mentor"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UploadCoursePage()),
              );
            },
          ),
          Divider(),
          // Logout
          ListTile(
            leading: Icon(
              Iconsax.logout,
              color: Colors.red,
            ),
            title: Text(
              "Logout",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
            ),
            onTap: () async {
              SharedPreferences sharedPreference =
                  await SharedPreferences.getInstance();
              sharedPreference.setString("x-auth-token", "");
              Provider.of<UserProvider>(context, listen: false).clearData();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
