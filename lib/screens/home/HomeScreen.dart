import 'package:animate_do/animate_do.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kisankit/components/HomeComponent.dart';
import 'package:kisankit/components/ProfileComponent.dart';
import 'package:kisankit/controllers/auth_controller.dart';
import 'package:kisankit/helpers/upload_image_helper.dart';
import 'package:kisankit/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthController authController = Get.find<AuthController>();

  // Function to toggle language
  void _toggleLanguage(String languageCode) {
    if (languageCode == 'en') {
      Get.updateLocale(const Locale('en', 'US'));
      authController.updateLocalePreference(true); // English
    } else {
      Get.updateLocale(const Locale('ur', 'PK'));
      authController.updateLocalePreference(false); // Urdu
    }
  }

  // Function for logout
  void _logout() {
    authController.logOut();
  }

  @override
  Widget build(BuildContext context) {
    final isUrdu = Get.locale?.languageCode == 'ur';

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(color: AppTheme.scaffoldBackgroundColor),
          ),
          automaticallyImplyLeading: false,
          actions: [
            FadeInRight(
              duration: const Duration(milliseconds: 800),
              child: IconButton(
                icon: Icon(
                  Icons.settings,
                  color: AppTheme.primaryColor,
                  size: 28,
                ),
                onPressed: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                },
              ),
            ),
          ],
          title: FadeInDown(
            duration: const Duration(milliseconds: 800),
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Image.asset(
                'assets/icons/app-icon.png',
                height: Get.height * 0.15,
              ),
            ),
          ),
          elevation: 4,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 20,
            color: AppTheme.scaffoldBackgroundColor,
            // fontFamily: isUrdu ? 'Jameel Noori Nastaleeq' : null,
          ),
        ),
        endDrawer: Drawer(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor.withOpacity(0.9),
                  AppTheme.secondaryColor.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                // Drawer Header
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/drawer_header.jpg'),
                      fit: BoxFit.cover,
                      opacity: 0.7,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: FadeInDown(
                    duration: const Duration(milliseconds: 800),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'kisankit'.tr,
                          style: GoogleFonts.poppins(
                            fontSize: isUrdu ? 22 : 26,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.scaffoldBackgroundColor,
                            //  fontFamily:
                            //     isUrdu ? 'Jameel Noori Nastaleeq' : null,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'change_language'.tr,
                          style: GoogleFonts.poppins(
                            fontSize: isUrdu ? 14 : 16,
                            color: AppTheme.scaffoldBackgroundColor
                                .withOpacity(0.9),
                            //     fontFamily:
                            //      isUrdu ? 'Jameel Noori Nastaleeq' : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Language Selection
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeInUp(
                          duration: const Duration(milliseconds: 900),
                          child: _buildLanguageTile(
                            context,
                            'English',
                            'en',
                            isUrdu,
                          ),
                        ),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1000),
                          child: _buildLanguageTile(
                            context,
                            'اردو',
                            'ur',
                            isUrdu,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Logout Button
                FadeInUp(
                  duration: const Duration(milliseconds: 1100),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.scaffoldBackgroundColor,
                        foregroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 32,
                        ),
                        elevation: 4,
                      ),
                      onPressed: _logout,
                      child: Text(
                        'logout'.tr,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor,
                          //     fontFamily: isUrdu ? 'Jameel Noori Nastaleeq' : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    kBottomNavigationBarHeight -
                    MediaQuery.of(context).padding.top,
              ),
              child: _selectedIndex == 0
                  ? Directionality(
                      textDirection:
                          isUrdu ? TextDirection.rtl : TextDirection.ltr,
                      child: HomeComponent(),
                    )
                  : ProfileComponent(),
            ),
          ),
        ),
        bottomNavigationBar: AnimatedBottomNavigationBar(
          backgroundGradient: LinearGradient(
            colors: [
              AppTheme.primaryColor.withOpacity(0.9),
              AppTheme.secondaryColor.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          icons: const [Icons.home, Icons.person],
          activeIndex: _selectedIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.softEdge,
          activeColor: AppTheme.scaffoldBackgroundColor,
          inactiveColor: AppTheme.scaffoldBackgroundColor.withOpacity(0.7),
          leftCornerRadius: 30,
          rightCornerRadius: 30,
          elevation: 8,
          onTap: (index) => setState(() => _selectedIndex = index),
        ),
        floatingActionButton: ZoomIn(
          duration: const Duration(milliseconds: 1000),
          child: Container(
            width: 60, // Adjust size if needed
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor.withOpacity(0.9),
                  AppTheme.secondaryColor.withOpacity(0.7),
                ],
              ),
            ),
            child: FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor:
                  Colors.transparent, // Important for gradient visibility
              elevation: 0, // Optional: clean flat look
              child: Icon(
                Icons.camera_alt,
                color: AppTheme.scaffoldBackgroundColor,
              ),
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
              },
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  // Helper function to build language selection tiles
  Widget _buildLanguageTile(
      BuildContext context, String language, String code, bool isUrdu) {
    final isSelected = Get.locale?.languageCode == code;
    return GestureDetector(
      onTap: () => _toggleLanguage(code),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.scaffoldBackgroundColor.withOpacity(0.9)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryColor
                : AppTheme.secondaryColor.withOpacity(0.4),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 8,
              backgroundColor: isSelected
                  ? AppTheme.primaryColor
                  : AppTheme.secondaryColor.withOpacity(0.4),
            ),
            const SizedBox(width: 12),
            Text(
              language,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.scaffoldBackgroundColor,
                //  fontFamily: isUrdu ? 'Jameel Noori Nastaleeq' : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
