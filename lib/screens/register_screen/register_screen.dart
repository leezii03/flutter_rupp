import 'package:flutter/material.dart';
import 'package:flutter_assignment/constant/appcolors.dart';
import 'package:flutter_assignment/constant/appimage.dart';
import 'package:flutter_assignment/widgets/customshimmer.dart';
import 'package:flutter_assignment/widgets/customtextfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isClick = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 40),
              _buildGreeting(),
              SizedBox(height: 40),
              _buildRegisterForm(),
              Spacer(),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      spacing: 10,
      children: [
        Row(
          spacing: 10,
          children: [
            Expanded(child: Container(height: 1, color: Colors.black)),
            Text("or continue with"),
            Expanded(child: Container(height: 1, color: Colors.black)),
          ],
        ),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Image.asset(
            Appimages.google,
            width: 40,
            height: 40,
          ),
        ),
        Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Already have account?"),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                "Sign In",
                style: TextStyle(
                  color: Appcolors.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: Appcolors.primary,
                  decorationThickness: 2,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      spacing: 10,
      children: [
        Customtextfield(
          prefix: Icon(Icons.person_outline),
          hintText: "Full Name",
        ),
        Customtextfield(
          prefix: Icon(Icons.email_outlined),
          hintText: "Email Address",
        ),
        Customtextfield(
          prefix: Icon(Icons.lock_outline),
          hintText: "Password",
          suffix: Icon(Icons.visibility_outlined),
        ),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Appcolors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Sign Up".toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * .8,
          child: FittedBox(
            child: Text(
              "Sign in or create \nan account".toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold, height: 1.2),
            ),
          ),
        ),
        Text(
          "Log in to continue planning your next adventure, saved trips, itineraries, and dream destinations.",
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      spacing: 10,
      children: [
        Customshimmer(width: 50, height: 50),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Explore",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                height: 1,
              ),
            ),
            Text("by Theav LyLy"),
          ],
        ),
      ],
    );
  }
}
