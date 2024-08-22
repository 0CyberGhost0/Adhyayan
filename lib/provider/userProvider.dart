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
}
