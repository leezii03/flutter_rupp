import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_assignment/constant/appcolors.dart';
import 'package:flutter_assignment/constant/appimage.dart';
import 'package:flutter_assignment/services/auth_service.dart';
import 'package:flutter_assignment/widgets/customshimmer.dart';
import 'package:flutter_assignment/widgets/customtextfield.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = false;
  bool isObscure = true;
  String? apiError;

  final _formKey = GlobalKey<FormState>();

  final usernameCtr = TextEditingController();
  final emailCtr = TextEditingController();
  final passwordCtr = TextEditingController();

  Future<void> register() async {
    setState(() {
      isLoading = true;
      apiError = null;
    });

    final url = Uri.parse('${ApiConfig.baseUrl}/api/v1/Profile/save');

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "username": usernameCtr.text.trim(),
          "email": emailCtr.text.trim(),
          "password": passwordCtr.text.trim(),
        }),
      );
      if (!mounted) return;

      final message = response.body.trim();
      debugPrint(message);

      if (response.statusCode == 200 && message == "successfully") {
        Navigator.pop(context);
      } else {
        setState(() {
          apiError = "Registration failed.";
        });
      }
    } catch (e) {
      setState(() {
        apiError = "Something went wrong";
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    usernameCtr.dispose();
    emailCtr.dispose();
    passwordCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
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
          controller: usernameCtr,
          obscureText: false,
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Username is required.";
            }
            return null;
          },
          prefix: Icon(Icons.person_outline),
          hintText: "Full Name",
        ),
        Customtextfield(
          controller: emailCtr,
          obscureText: false,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Email is required.";
            }
            if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                .hasMatch(value)) {
              return "Enter valid email";
            }
            return null;
          },
          prefix: Icon(Icons.email_outlined),
          hintText: "Email Address",
        ),
        Customtextfield(
          controller: passwordCtr,
          obscureText: isObscure,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Password is required.";
            }
            if (apiError != null) {
              return apiError;
            }
            return null;
          },
          prefix: Icon(Icons.lock_outline),
          hintText: "Password",
          suffix: IconButton(
            onPressed: () {
              setState(() {
                isObscure = !isObscure;
              });
            },
            icon: Icon(
              isObscure
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
          ),
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
                  onPressed: isLoading
                      ? null
                      : () {
                          setState(() {
                            apiError = null;
                          });
                          if (_formKey.currentState!.validate()) {
                            register();
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "Sign up".toUpperCase(),
                          style: TextStyle(fontWeight: FontWeight.bold),
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
