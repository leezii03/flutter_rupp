import 'package:flutter/material.dart';
import 'package:flutter_assignment/routes/app_routes.dart';
import 'package:flutter_assignment/widgets/custompopup.dart';

class Customappbar extends StatelessWidget implements PreferredSizeWidget {
  const Customappbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0,
      title: const Text("Explore"),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => Custompopup(
                title: "Coming Soon!!!",
                message:
                    "We're still working on this feature.\nStay tuned it will be available soon!",
                confirmText: "Okay",
              ),
            );
          },
          icon: const Icon(Icons.notifications_none_outlined),
        ),
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.search);
          },
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }
}
