import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kisankit/controllers/auth_controller.dart';
import 'package:kisankit/theme/app_theme.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());
    return Scaffold(
      body: Stack(
        children: [
          // Main content of the IntroScreen
          Center(
            child: Padding(
              padding: EdgeInsets.all(Get.height * 0.04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  // Your app logo
                  Image.asset(
                    'assets/icons/app-icon.png',
                    height: Get.height * .35,
                  ),
                  // Space between logo and text
                  Container(
                    height: 8,
                    width: Get.width * .7,
                    color: Colors.white,
                  ),
                  SizedBox(height: Get.height * .05),
                  // Introductory lines
                  Text(
                    'intro_title'.tr,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: Get.height * .038),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: Get.height * .02),
                  Text(
                    'intro_desc'.tr,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: Get.height * .02,
                          color: Colors.black54,
                        ),
                  ),
                  SizedBox(height: Get.height * .08), // Space for the button

                  // Get Started button
                  ElevatedButton(
                    onPressed: () {
                      authController.markIntroSeen();
                      Get.offAndToNamed('/login');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: Get.width * .2,
                          vertical: Get.height * .015),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8), // Adjust this value as needed
                      ),
                    ),
                    child: Text(
                      'get_started'.tr,
                      style: TextStyle(
                          fontSize: Get.height * 0.025,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Positioned language toggle buttons at the top-right
          Positioned(
            top: 50,
            right: 20,
            child: ToggleButtons(
              isSelected: [
                Get.locale?.languageCode == 'en',
                Get.locale?.languageCode == 'ur',
              ],
              onPressed: (index) async {
                if (index == 0 && Get.locale?.languageCode == 'en' ||
                    index == 1 && Get.locale?.languageCode == 'ur') {
                  return; // Do nothing if selected language is the current one
                }
                Get.updateLocale(
                    index == 0 ? const Locale('en') : const Locale('ur'));
                authController.updateLocalePreference(index == 0);
              },
              selectedColor: Colors.black,
              disabledColor: Colors.black,
              fillColor: AppTheme.primaryColor,
              borderColor: AppTheme.primaryColor,
              selectedBorderColor: AppTheme.primaryColor,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'English',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'اردو',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
