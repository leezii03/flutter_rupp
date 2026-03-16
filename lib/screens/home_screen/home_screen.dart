import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
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
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? currentUserId;
  int selectedIndex = 0;
  int sliderIndex = 0;
  List<dynamic> posts = [];
  List<dynamic> filteredPosts = [];
  bool isLoading = true;

  var user = UserInfo();

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

  Future<void> _loadUser() async {
    user = SessionManager.currentUser!;
    currentUserId = user.userId;
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
                      _buildSlider(),
                      SizedBox(height: 15),
                      SizedBox(height: 50, child: _buildCategory()),
                      SizedBox(height: 15),
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
                    _buildSlider(),
                    SizedBox(height: 15),
                    SizedBox(height: 50, child: _buildCategory()),
                    SizedBox(height: 15),
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

  Widget _buildSlider() {
    var images = [
      "https://afar.brightspotcdn.com/dims4/default/943e99c/2147483647/strip/true/crop/3000x1592+0+295/resize/1440x764!/quality/90/?url=https%3A%2F%2Fk3-prod-afar-media.s3.us-west-2.amazonaws.com%2Fbrightspot%2F34%2F8c%2F0a3f548947909b5b8d79b935b03f%2Ftravelguides-siemreap-guitarphotographer-shutterstock.jpg",
      "https://api.asiavivatravel.com/wp-content/uploads/2024/12/Pristine-Saracen-Bay_-Turquoise-waters-and-serene-white-sands-of-Koh-Rong-Samloem.png",
      "https://cdn-az.allevents.in/events1/banners/1c40f9fcae94a501f8ef73ec7ea67da554a2ec761d59d2773ff018b87cfb6b2b-rimg-w1024-h595-dcaac1d6-gmir?v=1735362533",
    ];
    return Column(
      children: [
        CarouselSlider(
          items: images.map((image) {
            return Builder(builder: (context) {
              return Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                      image: NetworkImage(image), fit: BoxFit.cover),
                ),
              );
            });
          }).toList(),
          options: CarouselOptions(
            enableInfiniteScroll: false,
            viewportFraction: 1,
            height: 200,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 4),
            onPageChanged: (index, reason) {
              setState(() {
                sliderIndex = index;
              });
            },
          ),
        ),
        SizedBox(height: 10),
        AnimatedSmoothIndicator(
          activeIndex: sliderIndex,
          count: 3,
          effect: WormEffect(
              dotWidth: 30, dotHeight: 5, activeDotColor: Appcolors.primary),
        )
      ],
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
