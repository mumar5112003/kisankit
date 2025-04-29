import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kisankit/theme/app_theme.dart';

class RecommendationsScreen extends StatelessWidget {
  const RecommendationsScreen({super.key});

  Future<DocumentSnapshot?> getDiseaseDetails(String label) async {
    final query = await FirebaseFirestore.instance
        .collection('diseaseDetails')
        .where('label', isEqualTo: label)
        .get();

    if (query.docs.isNotEmpty) {
      return query.docs.first;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final String label = Get.arguments['label'];
    final bool isUrl = Get.arguments['isUrl'];
    File imageFile = File('');
    String imageUrl = '';
    if (isUrl) {
      imageUrl = Get.arguments['imageUrl'];
    } else {
      imageFile = Get.arguments['imageFile'];
    }

    final bool isEnglish = Get.locale?.languageCode == 'en';

    return Scaffold(
      appBar: AppBar(title: Text('recommendations'.tr)),
      body: FutureBuilder<DocumentSnapshot?>(
        future: getDiseaseDetails(label),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('no_details_found'.tr));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Show uploaded image
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          height: 200,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.primaryColor,
                              strokeWidth: 2,
                            ),
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.error,
                            color: AppTheme.secondaryColor,
                            size: 40,
                          ),
                        )
                      : Image.file(
                          imageFile,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  isEnglish ? data['english_name'] : data['urdu_name'],
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const Divider(height: 30),

                _buildSection('cause', data['cause_en'], data['cause_ur']),
                _buildSection(
                    'symptoms', data['symptoms_en'], data['symptoms_ur']),
                _buildSection('prevention', data['preventions_en'],
                    data['preventions_ur']),
                _buildSection('organic_cure', data['organic_cure_en'],
                    data['organic_cure_ur']),
                _buildSection('chemical_cure', data['chemical_cure_en'],
                    data['chemical_cure_ur']),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(String titleKey, String enText, String urText) {
    final isEnglish = Get.locale?.languageCode == 'en';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleKey.tr,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        if (isEnglish) ...[
          Text(enText,
              style: const TextStyle(fontSize: 14, color: Colors.black87)),
        ] else ...[
          Text(urText,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontFamily: 'Jameel Noori Nastaleeq',
              )),
        ],
        const Divider(height: 30),
      ],
    );
  }
}
