import 'package:flutter/material.dart';
import 'package:flutter_assignment/constant/appcolors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Center(
              child: Column(
                children: [
                  _buildProfile(),
                  _buildDestination(),
                  SizedBox(height: 15),
                  _buildAppearance(),
                  SizedBox(height: 15),
                  _buildSetting(),
                  SizedBox(height: 15),
                  _buildSupport(),
                  SizedBox(height: 15),
                  _buildLogout(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogout() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Column(
        children: [
          _buildSettings(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            title: "Logout",
            icon: Icon(Icons.arrow_forward_ios, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildSupport() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Support",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: Appcolors.primary.withValues(alpha: .20),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              _buildSettings(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Appcolors.background, shape: BoxShape.circle),
                ),
                title: "Report on issue",
                icon: Icon(Icons.arrow_forward_ios, size: 18),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Divider(color: Appcolors.background),
              ),
              _buildSettings(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Appcolors.background, shape: BoxShape.circle),
                ),
                title: "FAQ",
                icon: Icon(Icons.arrow_forward_ios, size: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSetting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: Appcolors.primary.withValues(alpha: .20),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              _buildSettings(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Appcolors.background, shape: BoxShape.circle),
                ),
                title: "Account",
                icon: Icon(Icons.arrow_forward_ios, size: 18),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Divider(color: Appcolors.background),
              ),
              _buildSettings(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Appcolors.background, shape: BoxShape.circle),
                ),
                title: "Notification",
                icon: Transform.scale(
                  scale: .8,
                  child: Switch.adaptive(
                    activeThumbColor: Colors.white,
                    activeTrackColor: Colors.black,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey.shade400,
                    trackOutlineColor:
                        WidgetStateProperty.all(Colors.transparent),
                    value: false,
                    onChanged: (value) {},
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Divider(color: Appcolors.background),
              ),
              _buildSettings(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Appcolors.background, shape: BoxShape.circle),
                ),
                title: "Language",
                icon: Icon(Icons.arrow_forward_ios, size: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppearance() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Appearance",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: Appcolors.primary.withValues(alpha: .20),
            borderRadius: BorderRadius.circular(50),
          ),
          child: _buildSettings(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: Appcolors.background, shape: BoxShape.circle),
            ),
            title: "Dark Mode",
            icon: Transform.scale(
              scale: .8,
              child: Switch.adaptive(
                activeThumbColor: Colors.white,
                activeTrackColor: Colors.black,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey.shade400,
                trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                value: false,
                onChanged: (value) {},
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDestination() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Destination",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: Appcolors.primary.withValues(alpha: .20),
            borderRadius: BorderRadius.circular(50),
          ),
          child: _buildSettings(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: Appcolors.background, shape: BoxShape.circle),
            ),
            title: "My Favorite Destination",
            icon: Icon(Icons.arrow_forward_ios, size: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildSettings({
    required Widget leading,
    required String title,
    required Widget icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6),
          width: double.infinity,
          height: 50,
          child: Row(
            spacing: 10,
            children: [
              leading,
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Spacer(),
              icon,
            ],
          ),
        )
      ],
    );
  }

  Widget _buildProfile() {
    return Column(
      children: [
        Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        SizedBox(height: 10),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Appcolors.background,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Theav LyLy",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        Text("lylyisabatukam@gmail.com"),
        SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Appcolors.primary,
            foregroundColor: Colors.white,
          ),
          onPressed: () {},
          child: Text(
            "Edit Profile",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
