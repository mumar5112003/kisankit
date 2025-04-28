import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kisankit/components/HomeComponent.dart';
import 'package:kisankit/components/ProfileComponent.dart';
import 'package:kisankit/controllers/auth_controller.dart';
import 'package:kisankit/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthController authController = Get.put(AuthController());
  // Function to toggle language
  void _toggleLanguage(String languageCode) {
    if (languageCode == 'en') {
      Get.updateLocale(Locale('en', 'US'));
      authController.updateLocalePreference(languageCode == 'en');
      // Switch to English
    } else {
      Get.updateLocale(Locale('ur', 'PK'));
      authController
          .updateLocalePreference(languageCode == 'en'); // Switch to Urdu
    }
  }

  // Function for logout
  void _logout() {
    authController.logOut();
  }

  Future<Map<String, dynamic>?> pickAndUploadImage() async {
    final picker = ImagePicker();
    final isUrdu = Get.locale?.languageCode == 'ur';

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
      final uri = Uri.parse('http://192.168.100.176:5000/predict');

      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      final response = await request.send();

      Get.back(); // Hide loading

      if (response.statusCode == 200) {
        final resBody = await http.Response.fromStream(response);
        final data = jsonDecode(resBody.body);

        return {
          'image': imageFile,
          'response': data,
        };
      } else {
        Get.snackbar(
            'error'.tr, '${'upload_failed'.tr}: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      Get.back(); // Hide loading
      Get.snackbar('error'.tr, '${'something_went_wrong'.tr}: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        endDrawer: Directionality(
          textDirection: Get.locale?.languageCode == 'en'
              ? TextDirection.ltr
              : TextDirection.rtl,
          child: Drawer(
            child: Container(
              color: AppTheme.primaryColor, // Background color of the drawer
              child: Column(
                children: [
                  // Drawer Header with Select Language title
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 40, right: 20, left: 20),
                          child: Text(
                            'change_language'.tr,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        // Language Selection Buttons with improved visual design
                        GestureDetector(
                          onTap: () =>
                              _toggleLanguage('en'), // Switch to English
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 15),
                              decoration: BoxDecoration(
                                color: Get.locale?.languageCode == 'en'
                                    ? AppTheme.secondaryColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Get.locale?.languageCode == 'en'
                                      ? AppTheme.secondaryColor
                                      : AppTheme.secondaryColor
                                          .withOpacity(0.4),
                                  width: 1.5,
                                ),
                                boxShadow: Get.locale?.languageCode == 'en'
                                    ? [
                                        BoxShadow(
                                          color: AppTheme.secondaryColor
                                              .withOpacity(0.4),
                                          spreadRadius: 1,
                                          blurRadius: 6,
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Row(
                                children: [
                                  // Indicator for selected language
                                  CircleAvatar(
                                    radius: 6,
                                    backgroundColor: Get.locale?.languageCode ==
                                            'en'
                                        ? AppTheme.scaffoldBackgroundColor
                                        : Colors
                                            .transparent, // White dot for selected language
                                  ),
                                  SizedBox(width: 10),
                                  // Text for English
                                  Text(
                                    'English',
                                    style: TextStyle(
                                      color: Get.locale?.languageCode == 'en'
                                          ? AppTheme.scaffoldBackgroundColor
                                          : AppTheme
                                              .secondaryColor, // Highlight English if selected
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _toggleLanguage('ur'), // Switch to Urdu
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 15),
                              decoration: BoxDecoration(
                                color: Get.locale?.languageCode == 'ur'
                                    ? AppTheme.secondaryColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Get.locale?.languageCode == 'ur'
                                      ? AppTheme.secondaryColor
                                      : AppTheme.secondaryColor
                                          .withOpacity(0.4),
                                  width: 1.5,
                                ),
                                boxShadow: Get.locale?.languageCode == 'ur'
                                    ? [
                                        BoxShadow(
                                          color: AppTheme.secondaryColor
                                              .withOpacity(0.4),
                                          spreadRadius: 1,
                                          blurRadius: 6,
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Row(
                                children: [
                                  // Indicator for selected language
                                  CircleAvatar(
                                    radius: 6,
                                    backgroundColor: Get.locale?.languageCode ==
                                            'ur'
                                        ? AppTheme.scaffoldBackgroundColor
                                        : Colors
                                            .transparent, // White dot for selected language
                                  ),
                                  SizedBox(width: 10),
                                  // Text for Urdu
                                  Text(
                                    'اردو',
                                    style: TextStyle(
                                      color: Get.locale?.languageCode == 'ur'
                                          ? AppTheme.scaffoldBackgroundColor
                                          : AppTheme
                                              .secondaryColor, // Highlight Urdu if selected
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme
                          .primaryColor, // Match the drawer background color
                    ),
                  ),

                  // Spacer to push the logout button to the bottom
                  Spacer(),

                  // Logout Button at the bottom
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme
                            .scaffoldBackgroundColor, // Background color
                        foregroundColor:
                            AppTheme.secondaryColor, // Text and icon color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      ),
                      onPressed: _logout,
                      child: Text('Logout'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        key: _scaffoldKey, // Assign the scaffold key to manage the drawer
        appBar: AppBar(
          backgroundColor: AppTheme.scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(
                Icons.settings,
                color: AppTheme.secondaryColor,
              ),
              onPressed: () {
                // Open Drawer when settings icon is pressed
                _scaffoldKey.currentState
                    ?.openEndDrawer(); // Open the drawer from the right
              },
            ),
          ],
          title: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Image.asset('assets/icons/app-icon.png',
                height: Get.height * .15),
          ),
        ),
        body: _selectedIndex == 0
            ? Directionality(
                textDirection: Get.locale?.languageCode == 'en'
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                child: HomeComponent())
            : ProfileComponent(),
        bottomNavigationBar: AnimatedBottomNavigationBar(
          backgroundColor: AppTheme.primaryColor,
          icons: [Icons.home, Icons.person],
          activeIndex: _selectedIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.defaultEdge,
          activeColor: AppTheme.secondaryColor,
          inactiveColor: AppTheme.scaffoldBackgroundColor,
          leftCornerRadius: 30,
          rightCornerRadius: 30,
          onTap: (index) => setState(() => _selectedIndex = index),
        ),
        floatingActionButton: FloatingActionButton(
            shape: CircleBorder(),
            backgroundColor: AppTheme.primaryColor,
            child:
                Icon(Icons.camera_alt, color: AppTheme.scaffoldBackgroundColor),
            onPressed: () async {
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
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
