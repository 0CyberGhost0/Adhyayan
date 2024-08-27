import 'dart:convert';

class EnrolledCourse {
  final String courseId;
  int completedLessonNo;

  EnrolledCourse({
    required this.courseId,
    required this.completedLessonNo,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'courseId': courseId,
      'completedLessonNo': completedLessonNo,
    };
  }

  factory EnrolledCourse.fromMap(Map<String, dynamic> map) {
    return EnrolledCourse(
      courseId: map['courseId'] ?? '',
      completedLessonNo: map['completedLessonNo'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory EnrolledCourse.fromJson(String source) =>
      EnrolledCourse.fromMap(json.decode(source));
}

class User {
  final String? id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String? profilePictureUrl;
  final String phone;
  final List<EnrolledCourse> enrolledCourses;
  final List<String> savedCourses;
  final String userName;

  User({
    this.id,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.profilePictureUrl,
    required this.enrolledCourses,
    required this.savedCourses,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'profilePictureUrl': profilePictureUrl,
      'phone': phone,
      'enrolledCourses':
          enrolledCourses.map((course) => course.toMap()).toList(),
      'savedCourses': savedCourses,
      'userName': userName,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'],
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      profilePictureUrl: map['profilePictureUrl'] ?? '',
      phone: map['phone'] ?? '',
      enrolledCourses: List<EnrolledCourse>.from(
        (map['enrolledCourses'] ?? [])
            .map((course) => EnrolledCourse.fromMap(course)),
      ),
      savedCourses: List<String>.from(
        (map['savedCourses'] ?? [])
            .map((course) => course['courseId'] as String),
      ),
      userName: map['userName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
