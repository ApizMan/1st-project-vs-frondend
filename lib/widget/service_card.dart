import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:project/theme.dart';

class ServiceCard extends StatelessWidget {
  final String image;
  final String title;
  final dynamic onPressed;
  const ServiceCard({
    super.key,
    required this.image,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTap(
      onPressed: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            image,
            width: 90,
            height: 90,
            fit: BoxFit.fill,
          ),
          Text(
            title,
            style: textStyleNormal(),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
