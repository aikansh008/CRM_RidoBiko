import 'package:crm_app/Widgets/circular_circular.dart';
import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final Color c1;
  final Color c2;
  final String days;
  final String numbers;
  const CardContainer({
    super.key,
    required this.c1,
    required this.c2,
    required this.days,
    required this.numbers,
  });

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    // final double containerHeight = size.height * 0.75; // 75% of screen height
    // final double conatinerWidth = size.height * 0.90; // 75% of screen height

    return Container(
     width: double.infinity,
      height: 85,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        gradient: LinearGradient(
          colors: [c1, c2], // Define your gradient colors here
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        children: [
          const Positioned(
            top: -20, // Adjust this value to position the circle vertically
            right:
                -42.5, // Adjust this value to position the circle horizontally
            child: CircularContainer(
              backgroundcolor: Colors.white,
              opacity: 0.2,
            ),
          ),
          const Positioned(
            bottom:
                -42.5, // Adjust this value to position the circle vertically
            right: -10, // Adjust this value to position the circle horizontally
            child: CircularContainer(
              backgroundcolor: Colors.white,
              opacity: 0.2,
            ),
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              //width:double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(days,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.white)),
                  Text(
                    numbers,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
