import 'package:flutter/material.dart';
import '../Data_Models/userModel.dart';

class UserProvider with ChangeNotifier {
  User _user = User(
    userName: '',
    firstName: '',
    lastName: '',
    email: '',
    password: '',
    enrolledCourses: [],
    savedCourses: [],
    phone: '',
  );

  User get user => _user;

  void setFromModel(User user) {
    _user = user;
    notifyListeners();
  }

  void setUser(String user) {
    print("set user called in provider");
    _user = User.fromJson(user);
    print("after user called in provider");
    notifyListeners();
  }

  // Save course method
  void saveCourse(String courseId) {
    print("saveCourse called in provider");

    bool isCourseSaved =
        _user.savedCourses.any((savedCourse) => savedCourse == courseId);

    if (!isCourseSaved) {
      _user.savedCourses.insert(0, courseId);
      print("Course saved in provider: $courseId");
      notifyListeners();
    } else {
      print("Course is already saved in provider: $courseId");
    }
  }

  // Unsave course method
  void unsaveCourse(String courseId) {
    print("unsaveCourse called in provider");

    bool isCourseSaved =
        _user.savedCourses.any((savedCourse) => savedCourse == courseId);

    if (isCourseSaved) {
      _user.savedCourses.removeWhere((savedCourse) => savedCourse == courseId);
      print("Course unsaved in provider: $courseId");
      notifyListeners();
    } else {
      print("Course is not saved in provider: $courseId");
    }
  }

  // Enroll course method
  void enrollCourse(String courseId) {
    print("enrollCourse called in provider");

    // Check if the course is already enrolled
    bool isCourseEnrolled = _user.enrolledCourses.any(
      (enrolledCourse) => enrolledCourse.courseId == courseId,
    );

    if (!isCourseEnrolled) {
      _user.enrolledCourses.insert(0, EnrolledCourse(courseId: courseId));
      print("Course enrolled in provider: $courseId");
      notifyListeners();
    } else {
      print("User is already enrolled in provider: $courseId");
    }
  }
}
