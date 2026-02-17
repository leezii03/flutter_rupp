import 'package:flutter/material.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool up = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: up ? -15 : 0),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                onEnd: () {
                  setState(() {
                    up = !up;
                  });
                },
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, value),
                    child: child,
                  );
                },
                child: const Text(
                  "Coming Soon!",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4CAF81),
                  ),
                ),
              ),
              Text(
                "We're still working on this feature.\nStay tuned it will be available soon!",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
