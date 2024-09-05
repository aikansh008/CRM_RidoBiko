import 'package:flutter/material.dart';

class CircularContainer extends StatelessWidget {
  final Color backgroundcolor;
  final double opacity;

  const CircularContainer({
    super.key,
    required this.backgroundcolor,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85,
      height: 85,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundcolor.withOpacity(opacity),
      ),
    );
  }
}
