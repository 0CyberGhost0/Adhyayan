import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ContinueLearningCardShimmer extends StatelessWidget {
  const ContinueLearningCardShimmer({super.key});

  Widget buildImageShimmerPlaceholder(
      {required double width,
      required double height,
      BorderRadius? borderRadius}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget buildTextShimmerPlaceholder(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            // Shadow color
            spreadRadius: 2, // Spread radius
            blurRadius: 10, // Blur radius
            offset: const Offset(0, 5), // Offset in the x and y direction
          ),
        ],
      ),
      child: Row(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: buildImageShimmerPlaceholder(
              width: 70,
              height: 70,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextShimmerPlaceholder(80, 14),
                const SizedBox(height: 4),
                buildTextShimmerPlaceholder(100, 16),
                const SizedBox(height: 4),
                buildTextShimmerPlaceholder(100, 14),
              ],
            ),
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: buildImageShimmerPlaceholder(
              width: 40,
              height: 40,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ],
      ),
    );
  }
}
