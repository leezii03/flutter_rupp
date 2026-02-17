import 'package:flutter/material.dart';
import 'package:flutter_assignment/constant/appcolors.dart';
import 'package:flutter_assignment/constant/appimage.dart';

class Customcard extends StatelessWidget {
  const Customcard({super.key});

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
              child: Image.asset(
                Appimages.angkorwat,
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
                Text("Siemreap, Cambodia"),
              ],
            ),
            Text("Siemreap's most iconic temples destination"),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Appcolors.primary.withValues(alpha: .30),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text("History"),
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(width: 10),
                itemCount: 3,
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
                      color: Appcolors.background,
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
