import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kisankit/theme/app_theme.dart';

class DetectionResultScreen extends StatelessWidget {
  const DetectionResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final File imageFile = args['image'];
    final Map<String, dynamic> responseData = args['response'];
    final String label = responseData['label'] ?? 'Unknown';
    final double confidence = responseData['confidence']?.toDouble() ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('detection_result'.tr),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // Image Preview
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                imageFile,
                height: 250,
                width: 250,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Label
          Text(
            '${'detected'.tr}: $label',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          // Confidence
          Text(
            '${'confidence'.tr}: % ${confidence.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),

          const Spacer(),

          // Button
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(),
              ),
              onPressed: () {
                Get.toNamed('/recommendations', arguments: {
                  'label': label,
                  'imageFile': imageFile,
                  'isUrl': false
                });
              },
              child: Text(
                'see_recommendations'.tr,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
