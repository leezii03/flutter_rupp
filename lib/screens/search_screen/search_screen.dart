import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_assignment/models/SessionManager.dart';
import 'package:flutter_assignment/models/user_info.dart';
import 'package:flutter_assignment/services/api_config.dart';
import 'package:flutter_assignment/widgets/customcard.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int? currentUserId;
  List<dynamic> posts = [];
  bool isLoading = false;
  TextEditingController searchCtr = TextEditingController();

  Future<void> searchPosts(String location) async {
    if (location.isEmpty || currentUserId == null) return;
    setState(() {
      isLoading = true;
      posts = [];
    });
    final encodeLocation = Uri.encodeComponent(location);
    final url = Uri.parse(
        '${ApiConfig.baseUrl}/api/v1/Upload/searchBylocation?location=$encodeLocation');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          posts = data;
        });
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching posts: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        title: Container(
          margin: const EdgeInsets.only(right: 15),
          padding: EdgeInsets.only(left: 10),
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(6),
          ),
          child: TextField(
            controller: searchCtr,
            decoration: InputDecoration(
              hintText: "Search...",
              hintStyle: TextStyle(color: Colors.grey.shade600),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  searchPosts(searchCtr.text.trim());
                },
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : posts.isEmpty
              ? const Center(child: Text("No results found"))
              : ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return Customcard(
                      post: post,
                      userId: currentUserId!,
                    );
                  },
                ),
    );
  }
}
