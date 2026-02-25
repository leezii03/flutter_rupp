import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_assignment/constant/appcolors.dart';
import 'package:flutter_assignment/services/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final ImagePicker picker = ImagePicker();
  final TextEditingController captionCtr = TextEditingController();
  final TextEditingController locationCtr = TextEditingController();
  final TextEditingController directionCtr = TextEditingController();
  String selectedCategory = "";
  List<File> selectedImages = [];
  bool isLoading = false;

  Future<void> pickMultiImages() async {
    try {
      final List<XFile> pickedFiles = await picker.pickMultiImage(
        imageQuality: 80,
        maxWidth: 1200,
        maxHeight: 1200,
        requestFullMetadata: false,
      );

      if (pickedFiles.isNotEmpty) {
        setState(() {
          selectedImages = [
            ...selectedImages,
            ...pickedFiles.map((x) => File(x.path)),
          ];
        });
      }
    } catch (e) {
      debugPrint("Image pick error: $e");
    }
  }

  Future<void> createPost() async {
    if (selectedImages.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please select images")));
      return;
    }
    setState(() {
      isLoading = true;
    });

    try {
      List<String> imagesUrls = await uploadImagesToCloudinary();
      final bodyData = {
        "image": imagesUrls,
        "caption": captionCtr.text.trim(),
        "location": locationCtr.text.trim(),
        "direction": directionCtr.text.trim(),
        "category": selectedCategory,
        "isFav": false,
      };
      var response =
          await http.post(Uri.parse("${ApiConfig.baseUrl}/api/v1/Upload"),
              headers: {
                "Content-Type": "application/json",
              },
              body: jsonEncode(bodyData));
      if (response.statusCode == 200 || response.statusCode == 201) {
        clearForm();
      } else {
        debugPrint(response.body);
      }
    } catch (e) {
      "Upload error: $e";
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<List<String>> uploadImagesToCloudinary() async {
    List<String> imageUrls = [];

    for (var image in selectedImages) {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.cloudinary.com/v1_1/dti8ledhh/upload'),
      );

      request.fields['upload_preset'] = 'jkdhedut';

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          image.path,
        ),
      );

      var response = await request.send();
      var resBody = await response.stream.bytesToString();
      var data = jsonDecode(resBody);

      if (response.statusCode == 200) {
        imageUrls.add(data['secure_url']);
      } else {
        throw Exception("Cloud upload failed");
      }
    }
    return imageUrls;
  }

  void clearForm() {
    captionCtr.clear();
    locationCtr.clear();
    directionCtr.clear();

    setState(() {
      selectedImages.clear();
      selectedCategory = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        scrolledUnderElevation: 0,
        title: const Text(
          "Create Post",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUploadImage(),
            const SizedBox(height: 15),
            _buildCaption(),
            SizedBox(height: 15),
            _buildLocation(),
            const SizedBox(height: 15),
            _buildDirection(),
            const SizedBox(height: 15),
            _buildCategory(),
            const SizedBox(height: 20),
            _buildButtonPost(),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonPost() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : createPost,
        style: ElevatedButton.styleFrom(
          backgroundColor: Appcolors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
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
                "Post",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildCategory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: const Text("Category",
              style: TextStyle(fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 40,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 15),
            scrollDirection: Axis.horizontal,
            children: [
              _buildCategoryItem("Temple"),
              SizedBox(width: 10),
              _buildCategoryItem("Beach"),
              SizedBox(width: 10),
              _buildCategoryItem("Mountain"),
              SizedBox(width: 10),
              _buildCategoryItem("Culture"),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildCategoryItem(String label) {
    final isSelected = selectedCategory == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: isSelected ? Appcolors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: isSelected ? Colors.green : Appcolors.primary),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Appcolors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDirection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Direction",
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: directionCtr,
              decoration: const InputDecoration(
                icon: Icon(Icons.map_outlined),
                hintText: "Enter Direction...",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Location", style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: locationCtr,
              decoration: const InputDecoration(
                icon: Icon(Icons.location_on_outlined),
                hintText: "Enter location...",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaption() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Caption",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: captionCtr,
              maxLines: 4,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: "Share your experience...",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: GestureDetector(
        onTap: pickMultiImages,
        child: Container(
          constraints: BoxConstraints(
            minHeight: selectedImages.isEmpty ? 220 : 300,
            maxHeight: 400,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Appcolors.primary),
          ),
          child: selectedImages.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo,
                      size: 40,
                      color: Appcolors.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Tap to upload from gallery",
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                  ],
                )
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildPreviewByCount(),
                    Positioned(
                      bottom: 12,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(400),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Tap to add more",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildPreviewByCount() {
    final count = selectedImages.length;

    if (count == 1) {
      return _buildSingleImage(0);
    } else if (count == 2) {
      return _buildTwoImages();
    } else if (count == 3) {
      return _buildThreeImages();
    } else if (count == 4) {
      return _buildFourImagesGrid();
    } else {
      return _buildFourImagesWithCounter();
    }
  }

  Widget _buildSingleImage(int index) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.file(
          selectedImages[index],
          fit: BoxFit.cover,
        ),
        _buildDeleteButton(index),
      ],
    );
  }

  Widget _buildTwoImages() {
    return Row(
      children: [
        Expanded(child: _buildImageWithDelete(0)),
        Expanded(child: _buildImageWithDelete(1)),
      ],
    );
  }

  Widget _buildThreeImages() {
    return Row(
      children: [
        Expanded(
          child: _buildImageWithDelete(0),
        ),
        Expanded(
          child: Column(
            children: [
              Expanded(child: _buildImageWithDelete(1)),
              Expanded(child: _buildImageWithDelete(2)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFourImagesGrid() {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildImageWithDelete(0)),
              Expanded(child: _buildImageWithDelete(1)),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildImageWithDelete(2)),
              Expanded(child: _buildImageWithDelete(3)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFourImagesWithCounter() {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildImageWithDelete(0)),
              Expanded(child: _buildImageWithDelete(1)),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildImageWithDelete(2)),
              Expanded(child: _buildStackWithCounter(3)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStackWithCounter(int index) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.file(
          selectedImages[index],
          fit: BoxFit.cover,
        ),
        Container(
          color: Colors.black.withAlpha(100),
          alignment: Alignment.center,
          child: Text(
            "+${selectedImages.length - 4}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildDeleteButton(index),
      ],
    );
  }

  Widget _buildImageWithDelete(int index) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.file(
          selectedImages[index],
          fit: BoxFit.cover,
        ),
        _buildDeleteButton(index),
      ],
    );
  }

  Widget _buildDeleteButton(int index) {
    return Positioned(
      top: 8,
      right: 8,
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedImages.removeAt(index);
          });
        },
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(600),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.close,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }
}
