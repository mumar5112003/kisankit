import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kisankit/theme/app_theme.dart'; // For translations

class HomeComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content wrapped in a SingleChildScrollView
        SingleChildScrollView(
          child: Column(
            children: [
              // App Introduction
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App Title
                    Text(
                      'agriculture_assistance_title'
                          .tr, // Using translation key
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'agriculture_assistance_description'
                          .tr, // Description for the app
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 16),

                    // Additional Information
                    Text(
                      'app_description_title'
                          .tr, // Translation key for "App Description"
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('app_description_details'
                        .tr), // A brief explanation of the app's purpose
                    SizedBox(height: 16),

                    // Features section with stylish cards
                    Text(
                      'features_title'.tr, // Translation key for "Features"
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),

                    // Feature list with visually appealing cards
                    _buildFeatureCard(
                      Icons.mic,
                      'voice_interaction'.tr, // Using translation for title
                      'voice_interaction_desc'
                          .tr, // Using translation for description
                    ),
                    _buildFeatureCard(
                      Icons.camera_alt,
                      'disease_scan'.tr, // Using translation for title
                      'disease_scan_desc'
                          .tr, // Using translation for description
                    ),
                    _buildFeatureCard(
                      Icons.lightbulb,
                      'instant_advice'.tr, // Using translation for title
                      'instant_advice_desc'
                          .tr, // Using translation for description
                    ),
                    // Padding for bottom spacing before floating button
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Floating Voice Interaction Button fixed to the center-right of the screen
        Positioned(
          bottom: 130,
          right: 16,
          child: InkWell(
            onTap: () {
              Get.toNamed('/voice');
            },
            child: Container(
              height: context.height * .08,
              width: context.height * .08,
              decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(50)),
              child: Icon(
                size: context.height * 0.05,
                Icons.mic,
                color: AppTheme.scaffoldBackgroundColor,
              ),
            ),

            //  style: ButtonStyle(shape:),// Ensure the button is fully round
          ),
        ),
      ],
    );
  }

  // Helper function to create visually appealing feature cards
  Widget _buildFeatureCard(IconData icon, String title, String description) {
    return Card(
      elevation: 6, // Adds shadow for depth
      margin: EdgeInsets.symmetric(vertical: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white, // Card background color
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Icon on the left with a soft background
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor
                    .withOpacity(0.1), // Light background color for the icon
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppTheme.primaryColor, size: 32),
            ),
            SizedBox(width: 16),
            // Text content for the card
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
