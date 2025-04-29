import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kisankit/helpers/upload_image_helper.dart';
import 'package:kisankit/theme/app_theme.dart';

class HomeComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isUrdu = Get.locale?.languageCode == 'ur';

    return Stack(
      children: [
        // Main content
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Banner
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  // Use an image if available, fallback to gradient

                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor.withOpacity(0.9),
                      AppTheme.secondaryColor.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeInDown(
                      duration: const Duration(milliseconds: 800),
                      child: Text(
                        'agriculture_assistance_title'.tr,
                        style: GoogleFonts.poppins(
                          fontSize: isUrdu ? 24 : 30,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.scaffoldBackgroundColor,
                          //  fontFamily: isUrdu ? 'Jameel Noori Nastaleeq' : null,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Text(
                          'agriculture_assistance_description'.tr,
                          style: GoogleFonts.poppins(
                            fontSize: isUrdu ? 14 : 16,
                            color: AppTheme.scaffoldBackgroundColor
                                .withOpacity(0.9),
                            //   fontFamily: isUrdu ? 'Jameel Noori Nastaleeq' : null,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ZoomIn(
                      duration: const Duration(milliseconds: 1200),
                      child: ElevatedButton(
                        onPressed: () => Get.toNamed('/voice'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.scaffoldBackgroundColor,
                          foregroundColor: AppTheme.primaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          'get_started'.tr,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            // fontFamily: isUrdu ? 'Jameel Noori Nastaleeq' : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Showcase Section
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInLeft(
                      duration: const Duration(milliseconds: 800),
                      child: Text(
                        'our_features'.tr,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor,
                          //  fontFamily: isUrdu ? 'Jameel Noori Nastaleeq' : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Feature Tiles
                    _buildShowcaseTile(
                      context,
                      Icons.camera_alt,
                      'disease_scan'.tr,
                      'disease_scan_desc'.tr,
                      0,
                    ),
                    _buildShowcaseTile(
                      context,
                      Icons.mic,
                      'voice_interaction'.tr,
                      'voice_interaction_desc'.tr,
                      1,
                    ),
                    // _buildShowcaseTile(
                    //   context,
                    //   Icons.lightbulb,
                    //   'instant_advice'.tr,
                    //   'instant_advice_desc'.tr,
                    //   2,
                    // ),
                  ],
                ),
              ),
              // Benefits Section
              Container(
                color: AppTheme.scaffoldBackgroundColor.withOpacity(0.8),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInRight(
                      duration: const Duration(milliseconds: 800),
                      child: Text(
                        'why_kisankit'.tr,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor,
                          //    fontFamily: isUrdu ? 'Jameel Noori Nastaleeq' : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildBenefitItem(
                      context,
                      'benefit_1_title'.tr,
                      'benefit_1_desc'.tr,
                      0,
                    ),
                    _buildBenefitItem(
                      context,
                      'benefit_2_title'.tr,
                      'benefit_2_desc'.tr,
                      1,
                    ),
                    _buildBenefitItem(
                      context,
                      'benefit_3_title'.tr,
                      'benefit_3_desc'.tr,
                      2,
                    ),
                  ],
                ),
              ),
              // Footer
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                color: AppTheme.primaryColor,
                child: Column(
                  children: [
                    BounceInUp(
                      duration: const Duration(milliseconds: 1000),
                      child: Text(
                        'join_kisankit'.tr,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.scaffoldBackgroundColor,
                          //    fontFamily: isUrdu ? 'Jameel Noori Nastaleeq' : null,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 12),
                    BounceInUp(
                      duration: const Duration(milliseconds: 1200),
                      child: Text(
                        'join_kisankit_desc'.tr,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color:
                              AppTheme.scaffoldBackgroundColor.withOpacity(0.9),
                          //    fontFamily: isUrdu ? 'Jameel Noori Nastaleeq' : null,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100), // Space for FAB and navigation bar
            ],
          ),
        ),
        // Fixed Voice Interaction Button
        // Positioned(
        //   bottom: 100, // Adjusted to avoid FAB overlap
        //   right: Get.locale?.languageCode == 'en'
        //       ? Get.width * .1
        //       : Get.width * .80,

        //   child: ElasticIn(
        //     duration: const Duration(milliseconds: 1000),
        //     child: InkWell(
        //       onTap: () => Get.toNamed('/voice'),
        //       child: Container(
        //         height: 60,
        //         width: 60,
        //         decoration: BoxDecoration(
        //           color: AppTheme.secondaryColor,
        //           shape: BoxShape.circle,
        //           boxShadow: [
        //             BoxShadow(
        //               color: AppTheme.secondaryColor.withOpacity(0.4),
        //               blurRadius: 10,
        //               offset: const Offset(0, 4),
        //             ),
        //           ],
        //         ),
        //         child: Icon(
        //           Icons.mic,
        //           size: 30,
        //           color: AppTheme.scaffoldBackgroundColor,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  // Helper function to create showcase tiles
  Widget _buildShowcaseTile(BuildContext context, IconData icon, String title,
      String description, int index) {
    return FadeInUp(
      duration: Duration(milliseconds: 800 + index * 200),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () async {
                if (icon == Icons.camera_alt) {
                  final result = await pickAndUploadImage();

                  if (result != null) {
                    Get.toNamed(
                      '/detect',
                      arguments: {
                        'image': result['image'],
                        'response': result['response'],
                      },
                    );
                  }
                } else {
                  Get.toNamed('/voice');
                }
              },
              child: CircleAvatar(
                radius: 30,
                backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                child: Icon(
                  icon,
                  size: 32,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                      // fontFamily: isUrdu ? 'Jameel Noori Nastaleeq' : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppTheme.secondaryColor,
                      // fontFamily: isUrdu ? 'Jameel Noori Nastaleeq' : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to create benefit items
  Widget _buildBenefitItem(
      BuildContext context, String title, String description, int index) {
    // final isUrdu = Get.locale?.languageCode == 'ur';
    return FadeInRight(
      duration: Duration(milliseconds: 800 + index * 200),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: AppTheme.primaryColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primaryColor,
                      //  fontFamily: isUrdu ? 'Jameel Noori Nastaleeq' : null,
                    ),
                  ),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppTheme.secondaryColor,
                      //   fontFamily: isUrdu ? 'Jameel Noori Nastaleeq' : null,
                    ),
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
