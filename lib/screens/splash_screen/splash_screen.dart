// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_assignment/constant/appcolors.dart';
import 'package:flutter_assignment/constant/appimage.dart';
import 'package:flutter_assignment/models/SessionManager.dart';
import 'package:flutter_assignment/models/user_info.dart';
import 'package:flutter_assignment/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLogin = prefs.getBool("isLogin") ?? false;

    await Future.delayed(const Duration(seconds: 1));
    if (isLogin) {
      String? userJson = prefs.getString("currentUser");
      if (userJson != null) {
        SessionManager.currentUser = UserInfo.fromJson(jsonDecode(userJson));
      }
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.main, (route) => false);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.onboard);
    }
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Appimages.logo,
              width: 200,
              height: 200,
            ),
          ],
        ),
      ),
    );
  }
}
