import 'package:flutter/material.dart';
import 'package:flutter_assignment/constant/appimage.dart';

class Customonboard extends StatelessWidget {
  final String title, description;
  const Customonboard({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 42,
            ),
          ),
          Image.asset(Appimages.onboard),
          SizedBox(height: 20),
          Text(
            description,
            style: TextStyle(color: Colors.white),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
