class Lesson {
  final String title;
  final String content;
  final String url;
  bool completed = false;

  Lesson({
    required this.title,
    required this.content,
    required this.url,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      title: json['title'],
      content: json['content'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'url': url,
    };
  }
}

class Course {
  String? id;
  final String title;
  final String description;
  final String instructor;
  final double price;
  final double rating;
  final int enrolledCount;
  final String thumbnailUrl;
  final String category;
  final List<Lesson> lessons;

  Course({
    this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.price,
    required this.rating,
    required this.enrolledCount,
    required this.thumbnailUrl,
    required this.category,
    required this.lessons,
  });
  factory Course.sample() {
    final lessons = [
      Lesson(
        title: "Introduction to Dart",
        content:
            "This lesson covers the basics of the Dart programming language, including its syntax, variables, and basic data structures.",
        url:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      ),
      Lesson(
        title: "Flutter Widgets",
        content:
            "Learn about the core widgets in Flutter and how to use them to build user interfaces.",
        url:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      ),
      Lesson(
        title: "State Management",
        url:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        content:
            "Understand different state management approaches in Flutter, including Provider, Riverpod, and Bloc.",
      ),
    ];

    return Course(
      id: "1234567890",
      title: "Mastering Flutter Development",
      description:
          "This comprehensive course takes you from beginner to advanced in Flutter development. You'll learn everything from basic Dart programming to complex state management and custom widgets.",
      instructor: "Ved Prakash",
      price: 99.99,
      rating: 4.8,
      enrolledCount: 250,
      thumbnailUrl:
          "https://res.cloudinary.com/dxa9xqx3t/image/upload/v1724362040/courseImage/nxwwl7tycp25ttqzoz6s.png",
      category: "Design",
      lessons: lessons,
    );
  }
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      instructor: json['instructor'],
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      enrolledCount: json['enrolledCount'],
      thumbnailUrl: json['thumbnailUrl'],
      category: json['category'],
      lessons: (json['lessons'] as List)
          .map((lessonJson) => Lesson.fromJson(lessonJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'instructor': instructor,
      'price': price,
      'rating': rating,
      'enrolledCount': enrolledCount,
      'thumbnailUrl': thumbnailUrl,
      'category': category,
      'lessons': lessons.map((lesson) => lesson.toJson()).toList(),
    };
  }
}
