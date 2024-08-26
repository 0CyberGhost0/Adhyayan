import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PopularCourseCardShimmer extends StatelessWidget {
  const PopularCourseCardShimmer({super.key});

  Widget buildShimmerPlaceholder(
      {required double width,
      required double height,
      BorderRadius? borderRadius}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: borderRadius ?? BorderRadius.circular(4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder for Course Image
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: buildShimmerPlaceholder(
              width: double.infinity,
              height: 100,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: 12),

          // Placeholder for Category Text
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: buildShimmerPlaceholder(width: 80, height: 16),
          ),
          const SizedBox(height: 4),

          // Placeholder for Title Text
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: buildShimmerPlaceholder(width: double.infinity, height: 20),
          ),
          const SizedBox(height: 4),

          // Placeholder for Lessons and Duration Text
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: buildShimmerPlaceholder(width: 150, height: 16),
          ),
          const SizedBox(height: 12),

          // Placeholder for Bookmark Icon
          Align(
            alignment: Alignment.topRight,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: buildShimmerPlaceholder(
                width: 30,
                height: 30,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
