import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_assignment/constant/appcolors.dart';
import 'package:flutter_assignment/routes/app_routes.dart';
import 'package:flutter_assignment/services/api_config.dart';
import 'package:http/http.dart' as http;

class Customcard extends StatefulWidget {
  final Map<String, dynamic> post;
  final int userId;
  const Customcard({super.key, required this.post, required this.userId});

  @override
  State<Customcard> createState() => _CustomcardState();
}

class _CustomcardState extends State<Customcard> {
  bool isFav = false;

  Future<void> checkIfFav() async {
    final url =
        Uri.parse('${ApiConfig.baseUrl}/api/v1/Favorite/user/${widget.userId}');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> favIds = jsonDecode(response.body);
        setState(() {
          isFav = favIds.contains(widget.post['id']);
        });
      }
    } catch (e) {
      debugPrint("Error fetching favorites: $e");
    }
  }

  Future<void> toggleFavorite() async {
    try {
      if (!isFav) {
        final url = Uri.parse('${ApiConfig.baseUrl}/api/v1/Favorite/save');
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "userId": widget.userId,
            "uploadId": widget.post['id'],
          }),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          setState(() {
            isFav = true;
          });
        }
      }
    } catch (e) {
      print("Error toggling favorite: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfFav();
  }

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
                widget.post['image'][0],
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
                  child: Icon(
                    Icons.location_on,
                    color: Appcolors.primary,
                  ),
                ),
                SizedBox(width: 10),
                Text(widget.post['location']),
              ],
            ),
            Text(
              widget.post['caption'],
              maxLines: 2,
              style: TextStyle(overflow: TextOverflow.ellipsis),
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
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.details,
                          arguments: widget.post,
                        );
                      },
                      child: Text(
                        "View Details",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: toggleFavorite,
                  child: Container(
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
                      isFav ? Icons.favorite : Icons.favorite_outline,
                      color: Appcolors.primary,
                    ),
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
