import 'package:flutter/material.dart';
import 'package:flutter_assignment/constant/appcolors.dart';
import 'package:flutter_assignment/constant/appimage.dart';

class Customcard extends StatelessWidget {
  final Map<String, dynamic> post;
  const Customcard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                post['image'],
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Row(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Appcolors.primary.withValues(alpha: .30),
                  ),
                  child: Image.asset(
                    Appimages.location,
                    color: Appcolors.primary,
                  ),
                ),
                SizedBox(width: 10),
                Text(post['location']),
              ],
            ),
            Text(post['caption']),
            Container(
              height: 35,
              width: 120,
              decoration: BoxDecoration(
                color: Appcolors.primary.withValues(alpha: .30),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(post['category']),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Appcolors.primary,
                        side: BorderSide(width: 1, color: Appcolors.primary),
                        splashFactory: NoSplash.splashFactory,
                      ),
                      onPressed: () {},
                      child: Text(
                        "View Details",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 1,
                      color: Appcolors.primary,
                    ),
                  ),
                  child: Icon(
                    Icons.favorite_outline,
                    color: Appcolors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
