import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:kisankit/theme/app_theme.dart';

Future<Map<String, dynamic>?> pickAndUploadImage() async {
  final picker = ImagePicker();
  final isUrdu = Get.locale?.languageCode == 'ur';
  final user = FirebaseAuth.instance.currentUser;

  // Ensure user is logged in
  if (user == null) {
    Get.snackbar('error'.tr, 'please_login_to_save_detection'.tr);
    return null;
  }

  // Ask user to pick Camera or Gallery
  final ImageSource? source = await showModalBottomSheet<ImageSource>(
    context: Get.context!,
    builder: (context) {
      return Directionality(
        textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
        child: SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text('camera'.tr),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text('gallery'.tr),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
            ],
          ),
        ),
      );
    },
  );

  if (source == null) return null;

  final pickedFile = await picker.pickImage(source: source);
  if (pickedFile == null) return null;

  final imageFile = File(pickedFile.path);

  // Show loading spinner
  Get.dialog(
    const Center(
      child: CircularProgressIndicator(color: AppTheme.primaryColor),
    ),
    barrierDismissible: false,
  );

  try {
    // Step 1: Upload image to prediction API
    final uri = Uri.parse('http://192.168.100.176:5000/predict');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    final response = await request.send();

    if (response.statusCode != 200) {
      Get.back(); // Hide loading
      Get.snackbar('error'.tr, '${'upload_failed'.tr}: ${response.statusCode}');
      return null;
    }

    final resBody = await http.Response.fromStream(response);
    final data = jsonDecode(resBody.body);

    // Step 2: Upload image to Firebase Storage
    final storageRef = FirebaseStorage.instance.ref().child(
        'detectionHistory/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = await storageRef.putFile(imageFile);
    final imageUrl = await uploadTask.ref.getDownloadURL();

    // Step 3: Save to Firestore
    await FirebaseFirestore.instance.collection('detectionHistory').add({
      'userId': user.uid,
      'imageUrl': imageUrl,
      'prediction': data, // Store entire prediction response
      'timestamp': FieldValue.serverTimestamp(),
      'source': source == ImageSource.camera ? 'camera' : 'gallery',
    });

    Get.back(); // Hide loading

    return {
      'image': imageFile,
      'response': data,
    };
  } catch (e) {
    Get.back(); // Hide loading
    Get.snackbar('error'.tr, '${'something_went_wrong'.tr}: $e');
    return null;
  }
}
