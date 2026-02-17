import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Customshimmer extends StatelessWidget {
  final double width;
  final double height;
  const Customshimmer({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade400,
        highlightColor: Colors.white60,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}
