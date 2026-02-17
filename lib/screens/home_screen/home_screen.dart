import 'package:flutter/material.dart';
import 'package:flutter_assignment/constant/appcolors.dart';
import 'package:flutter_assignment/constant/appimage.dart';
import 'package:flutter_assignment/widgets/customcard.dart';
import 'package:flutter_assignment/widgets/custompopup.dart';
import 'package:flutter_assignment/widgets/customtextfield.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: Text("Explore"),
        centerTitle: false,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
            ),
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
            child: Image.asset(Appimages.notification),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchEngine(),
            SizedBox(height: 15),
            SizedBox(height: 50, child: _buildCategory()),
            _buildListPost(),
          ],
        ),
      ),
    );
  }

  Widget _buildListPost() {
    return ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Customcard();
        },
        separatorBuilder: (context, index) => SizedBox(height: 10),
        itemCount: 5);
  }

  Widget _buildCategory() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 15),
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Appcolors.primary,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(child: Text("Temples")),
        );
      },
      separatorBuilder: (context, index) => SizedBox(width: 10),
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
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 45,
                  child: Customtextfield(
                    prefix: Icon(Icons.location_on_outlined, size: 24),
                    hintText: "Search your destination",
                  ),
                ),
              ),
              SizedBox(width: 10),
              Container(
                height: 45,
                width: 45,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  Appimages.sort,
                  width: 30,
                  height: 30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
