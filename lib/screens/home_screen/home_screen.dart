import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignment/constant/appcolors.dart';
import 'package:flutter_assignment/data/category.dart';
import 'package:flutter_assignment/models/SessionManager.dart';
import 'package:flutter_assignment/models/user_info.dart';
import 'package:flutter_assignment/services/post_service.dart';
import 'package:flutter_assignment/widgets/customappbar.dart';
import 'package:flutter_assignment/widgets/customcard.dart';
import 'package:flutter_assignment/widgets/customshimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? currentUserId;
  int selectedIndex = 0;
  List<dynamic> posts = [];
  List<dynamic> filteredPosts = [];
  bool isLoading = true;

  Future<void> fetchPosts() async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await PostService.getAllPosts();
      data.sort((a, b) => b['id'].compareTo(a['id']));
      setState(() {
        posts = data;
        filteredPosts = data;
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  // final user = SessionManager.currentUser;
  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('currentUser');

    if (userString != null) {
      final userMap = jsonDecode(userString);
      final user = UserInfo.fromJson(userMap);
      SessionManager.currentUser = user;
      setState(() {
        currentUserId = user.userId;
      });
    }
  }

  Future<void> _initialize() async {
    await _loadUser();
    await fetchPosts();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Customappbar(),
      body: Platform.isIOS
          ? CustomScrollView(
              slivers: [
                CupertinoSliverRefreshControl(
                  onRefresh: fetchPosts,
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      _buildSearchEngine(),
                      SizedBox(height: 15),
                      SizedBox(height: 50, child: _buildCategory()),
                      _buildListPost(),
                    ],
                  ),
                )
              ],
            )
          : RefreshIndicator(
              onRefresh: fetchPosts,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchEngine(),
                    SizedBox(height: 15),
                    SizedBox(height: 50, child: _buildCategory()),
                    _buildListPost(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildShimmerPost() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 2,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Customshimmer(
                width: double.infinity,
                height: 220,
              ),
            ),
            const SizedBox(height: 12),
            Customshimmer(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 16,
            ),
            const SizedBox(height: 8),
            Customshimmer(
              width: MediaQuery.of(context).size.width * 0.5,
              height: 14,
            ),
            const SizedBox(height: 8),
            Customshimmer(
              width: MediaQuery.of(context).size.width * 0.3,
              height: 12,
            ),
          ],
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 20),
    );
  }

  Widget _buildListPost() {
    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.only(top: 15),
        child: _buildShimmerPost(),
      );
    }

    if (filteredPosts.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text("No posts available"),
        ),
      );
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Customcard(
          post: filteredPosts[index],
          userId: currentUserId ?? 0,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: filteredPosts.length,
    );
  }

  Widget _buildCategory() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 15),
      itemCount: categories.length,
      scrollDirection: Axis.horizontal,
      separatorBuilder: (context, index) => SizedBox(width: 10),
      itemBuilder: (context, index) {
        final bool isActive = selectedIndex == index;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
              final selectedCategory = categories[index];
              if (selectedCategory == "All") {
                filteredPosts = posts;
              } else {
                filteredPosts = posts
                    .where((post) => post['category'] == selectedCategory)
                    .toList();
              }
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: isActive ? Appcolors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(5),
              border: isActive
                  ? null
                  : Border.all(
                      color: Appcolors.primary,
                      width: 1,
                    ),
            ),
            child: Center(
              child: Text(
                categories[index],
                style: TextStyle(
                  color: isActive ? Colors.white : Appcolors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchEngine() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Where are you going?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
