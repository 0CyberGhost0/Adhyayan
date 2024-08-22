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
  final List<String> lessons;

  Course({
    required this.id,
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

  // Factory constructor for creating a Course instance from JSON
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
      lessons: List<String>.from(json['lessons']),
    );
  }

  // Method for converting Course instance to JSON
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
      'lessons': lessons,
    };
  }
}
