import 'package:flutter/material.dart';
import 'package:flutter_assignment/constant/appcolors.dart';
import 'package:flutter_assignment/routes/app_routes.dart';
import 'package:flutter_assignment/widgets/customonboard.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  final PageController controller = PageController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: controller,
                onPageChanged: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                },
                children: [
                  Customonboard(
                    title: "Welcome to Cambodia",
                    description:
                        "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.",
                  ),
                  Customonboard(
                    title: "Your First Adventure Awaits",
                    description:
                        "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.",
                  ),
                  Customonboard(
                    title: "Creating Memory with Cambodia",
                    description:
                        "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.",
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Appcolors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {
                  if (currentIndex == 2) {
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  } else {
                    controller.jumpToPage(currentIndex + 1);
                  }
                },
                child: Text(currentIndex == 2 ? "Get Started" : "Next"),
              ),
            ),
            SizedBox(height: 10),
            AnimatedSmoothIndicator(
              activeIndex: currentIndex,
              count: 3,
              effect: WormEffect(
                dotWidth: 10,
                dotHeight: 10,
                dotColor: Colors.grey.shade400,
                activeDotColor: Appcolors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
