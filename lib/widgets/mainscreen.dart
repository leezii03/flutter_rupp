import 'package:flutter/material.dart';
import 'package:flutter_assignment/constant/appcolors.dart';
import 'package:flutter_assignment/constant/appimage.dart';
import 'package:flutter_assignment/screens/favorite_screen/favorite_screen.dart';
import 'package:flutter_assignment/screens/home_screen/home_screen.dart';
import 'package:flutter_assignment/screens/post_screen/post_screen.dart';
import 'package:flutter_assignment/screens/profile_screen/profile_screen.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  int index = 0;
  List<Widget> screens = [
    HomeScreen(),
    FavoriteScreen(),
    PostScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Appcolors.primary,
          selectedFontSize: 14,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedFontSize: 14,
          currentIndex: index,
          onTap: (value) {
            setState(() {
              index = value;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: index == 0
                  ? Image.asset(
                      Appimages.homefill,
                      width: 24,
                      color: Appcolors.primary,
                    )
                  : Image.asset(Appimages.home, width: 24),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: index == 1
                  ? Image.asset(
                      Appimages.favoritefill,
                      width: 24,
                      color: Appcolors.primary,
                    )
                  : Image.asset(Appimages.favorite, width: 24),
              label: "Favorite",
            ),
            BottomNavigationBarItem(
              icon: index == 2
                  ? Image.asset(
                      Appimages.addfill,
                      width: 24,
                      color: Appcolors.primary,
                    )
                  : Image.asset(Appimages.add, width: 24),
              label: "Post",
            ),
            BottomNavigationBarItem(
              icon: index == 3
                  ? Image.asset(
                      Appimages.profilefill,
                      width: 24,
                      color: Appcolors.primary,
                    )
                  : Image.asset(Appimages.profile, width: 24),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
