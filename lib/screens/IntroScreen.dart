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
          Center(
            child: Padding(
              padding: EdgeInsets.all(Get.height * 0.04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  Image.asset(
                    'assets/icons/app-icon.png',
                    height: Get.height * .35,
                  ),
                  Container(
                    height: 8,
                    width: Get.width * .7,
                    color: Colors.white,
                  ),
                  SizedBox(height: Get.height * .05),
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
                  SizedBox(height: Get.height * .06),
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
                        borderRadius: BorderRadius.circular(8),
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
          Positioned(
            top: 50,
            right: 20,
            child: Obx(() => ToggleButtons(
                  isSelected: [
                    authController.locale.value.languageCode == 'en',
                    authController.locale.value.languageCode == 'ur',
                  ],
                  onPressed: (index) async {
                    if (index == 0 &&
                            authController.locale.value.languageCode == 'en' ||
                        index == 1 &&
                            authController.locale.value.languageCode == 'ur') {
                      return; // Prevent redundant updates
                    }
                    await authController.updateLocalePreference(index == 0);
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
                )),
          ),
        ],
      ),
    );
  }
}
