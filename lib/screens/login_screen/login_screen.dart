import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_assignment/constant/appcolors.dart';
import 'package:flutter_assignment/constant/appimage.dart';
import 'package:flutter_assignment/models/SessionManager.dart';
import 'package:flutter_assignment/models/user_info.dart';
import 'package:flutter_assignment/routes/app_routes.dart';
import 'package:flutter_assignment/services/api_config.dart';
import 'package:flutter_assignment/widgets/customtextfield.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  bool isClick = false;
  bool isObscure = true;
  String? apiError;
  final _formKey = GlobalKey<FormState>();
  final emailCtr = TextEditingController();
  final passwordCtr = TextEditingController();

  Future<void> login() async {
    setState(() {
      isLoading = true;
      apiError = null;
    });
    final url = Uri.parse('${ApiConfig.baseUrl}/api/v1/Profile/login');
    try {
      final response = await http.post(
        url,
        body: {
          "email": emailCtr.text.trim(),
          "password": passwordCtr.text.trim(),
        },
      );

      if (!mounted) return;

      final message = response.body.trim();

      if (response.statusCode == 200 && message.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool("isLogin", true);
        debugPrint(message);
        final data = jsonDecode(message);
        final userinfo = UserInfo();
        userinfo.userId = data["userId"];
        userinfo.username = data["username"];
        userinfo.email = data["email"];
        userinfo.password = data["password"];
        SessionManager.currentUser = userinfo;

        var userData = {
          "userId": data["userId"],
          "username": data["username"],
          "email": data["email"],
          "password": data["password"],
        };
        prefs.setString("currentUser", jsonEncode(userData));

        await Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.main, (route) => false);
      } else {
        setState(() {
          apiError = "Email or password is incorrect.";
        });
        _formKey.currentState!.validate();
      }
    } catch (e) {
      setState(() {
        apiError = "Something went wrong.";
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
                _buildLoginForm(),
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
            Text("Don't have an account?"),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.register);
              },
              child: Text(
                "Sign Up",
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

  Widget _buildLoginForm() {
    return Column(
      spacing: 10,
      children: [
        Customtextfield(
          controller: emailCtr,
          obscureText: false,
          keyboardType: TextInputType.emailAddress,
          prefix: Icon(Icons.email_outlined),
          hintText: "Email Address",
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
        ),
        Customtextfield(
          controller: passwordCtr,
          obscureText: isObscure,
          prefix: Icon(Icons.lock_outline),
          hintText: "Password",
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Password is required";
            }
            if (apiError != null) {
              return apiError;
            }
            return null;
          },
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
          children: [
            Transform.scale(
              scale: 1.1,
              child: Checkbox(
                activeColor: Appcolors.primary,
                side: BorderSide(width: .5),
                value: isClick,
                onChanged: (value) {
                  setState(() {
                    isClick = !isClick;
                  });
                },
              ),
            ),
            Text("Remember me?"),
            Spacer(),
            Text("Forgot Password?"),
          ],
        ),
        SizedBox(
          height: 50,
          width: double.infinity,
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
                      login();
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
                : const Text(
                    "Login",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
          ),
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
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(),
          child: Image.asset(Appimages.logo2),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "RukRok",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                height: 1,
              ),
            ),
            Text("by Team 007"),
          ],
        ),
      ],
    );
  }
}
