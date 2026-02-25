import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_assignment/models/SessionManager.dart';
import 'package:flutter_assignment/models/user_info.dart';
import 'package:flutter_assignment/services/api_config.dart';
import 'package:flutter_assignment/services/post_service.dart';
import 'package:flutter_assignment/widgets/customappbar.dart';
import 'package:flutter_assignment/widgets/customcard.dart';
import 'package:http/http.dart' as http;

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<dynamic> favoritePosts = [];
  bool isLoading = true;
  int? currentUserId;
  var user = UserInfo();

  Future<void> _loadUser() async {
    user = SessionManager.currentUser!;
    currentUserId = user.userId;
  }

  Future<void> fetchFavoritePosts() async {
    setState(() {
      isLoading = true;
    });
    if (currentUserId == null) {
      setState(() {
        isLoading = false;
        return;
      });
    }

    try {
      final favUrl =
          Uri.parse('${ApiConfig.baseUrl}/api/v1/Favorite/user/$currentUserId');
      final favResp = await http.get(favUrl);

      if (favResp.statusCode == 200) {
        List<dynamic> favIds = jsonDecode(favResp.body);

        final allPosts = await PostService.getAllPosts();

        final filtered =
            allPosts.where((post) => favIds.contains(post['id'])).toList();

        setState(() {
          favoritePosts = filtered;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Failed to fetch favorite IDs');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching favorites: $e');
    }
  }

  Future<void> _initialize() async {
    await _loadUser();
    await fetchFavoritePosts();
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Customappbar(),
      body: RefreshIndicator(
        onRefresh: fetchFavoritePosts,
        child: isLoading && favoritePosts.isEmpty
            ? ListView(
                children: const [
                  SizedBox(height: 50),
                  Center(child: Text('No favorite posts yet')),
                ],
              )
            : ListView.separated(
                padding: const EdgeInsets.all(10),
                itemCount: favoritePosts.length,
                itemBuilder: (context, index) {
                  return Customcard(
                    post: favoritePosts[index],
                    userId: SessionManager.currentUser!.userId,
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 10),
              ),
      ),
    );
  }
}
