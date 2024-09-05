import 'package:crm_app/Utils/Constants/Helpers/helper_functions.dart';
import 'package:crm_app/Utils/Sizes.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  final String heading;
  final String subheading;
  final Widget widget;

  const DrawerWidget({
    super.key,
    required this.heading,
    this.subheading = "",
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context); // Close the drawer
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widget),
        );
      },
      child: Padding(
        padding: EdgeInsets.all(HelperFunctions.screenHeight() * 0.025),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              heading,
              style: const TextStyle(fontSize: Sizes.iconSm),
            ),
            if (subheading.isNotEmpty)
              Text(
                subheading,
                style: const TextStyle(
                    fontSize: Sizes.iconXs, fontWeight: FontWeight.w300),
              ),
          ],
        ),
      ),
    );
  }
  
}

