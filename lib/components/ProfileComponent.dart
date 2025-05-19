import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kisankit/controllers/user_controller.dart';
import 'package:kisankit/theme/app_theme.dart';

class ProfileComponent extends StatelessWidget {
  final UserController userController = Get.find<UserController>();

  // Show edit dialog
  void _showEditDialog(BuildContext context) {
    final isUrdu = Get.locale?.languageCode == 'ur';
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FadeInDown(
                    duration: const Duration(milliseconds: 800),
                    child: Text(
                      'edit_profile'.tr,
                      style: GoogleFonts.poppins(
                        fontSize: isUrdu ? 18 : 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.scaffoldBackgroundColor,
                        //    fontFamily: isUrdu ? 'Jameel Noori Nastaleeq' : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeInUp(
                    duration: const Duration(milliseconds: 900),
                    child: TextField(
                      controller: userController.nameController,
                      decoration: InputDecoration(
                        labelText: 'name'.tr,
                        labelStyle:
                            TextStyle(color: AppTheme.scaffoldBackgroundColor),
                        filled: true,
                        fillColor:
                            AppTheme.scaffoldBackgroundColor.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: AppTheme.scaffoldBackgroundColor),
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        color: AppTheme.scaffoldBackgroundColor,
                        //    fontFamily: isUrdu ? 'Jameel Noori Nastaleeq' : null,
                      ),
                      cursorColor: AppTheme.scaffoldBackgroundColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1000),
                    child: TextField(
                      controller: userController.emailController,
                      decoration: InputDecoration(
                        labelText: 'email'.tr,
                        labelStyle:
                            TextStyle(color: AppTheme.scaffoldBackgroundColor),
                        filled: true,
                        fillColor:
                            AppTheme.scaffoldBackgroundColor.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: AppTheme.scaffoldBackgroundColor),
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        color: AppTheme.scaffoldBackgroundColor,
                        //    fontFamily: isUrdu ? 'Jameel Noori Nastaleeq' : null,
                      ),
                      cursorColor: AppTheme.scaffoldBackgroundColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1100),
                    child: TextField(
                      controller: userController.phoneController,
                      decoration: InputDecoration(
                        labelText: 'phone_number'.tr,
                        labelStyle:
                            TextStyle(color: AppTheme.scaffoldBackgroundColor),
                        filled: true,
                        fillColor:
                            AppTheme.scaffoldBackgroundColor.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: AppTheme.scaffoldBackgroundColor),
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        color: AppTheme.scaffoldBackgroundColor,
                        //    fontFamily: isUrdu ? 'Jameel Noori Nastaleeq' : null,
                      ),
                      cursorColor: AppTheme.scaffoldBackgroundColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1200),
                    child: TextField(
                      controller: userController.locationController,
                      decoration: InputDecoration(
                        labelText: 'location'.tr,
                        labelStyle:
                            TextStyle(color: AppTheme.scaffoldBackgroundColor),
                        filled: true,
                        fillColor:
                            AppTheme.scaffoldBackgroundColor.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: AppTheme.scaffoldBackgroundColor),
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        color: AppTheme.scaffoldBackgroundColor,
                        //   fontFamily: isUrdu ? 'Jameel Noori Nastaleeq' : null,
                      ),
                      cursorColor: AppTheme.scaffoldBackgroundColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FadeInUp(
                        duration: const Duration(milliseconds: 1300),
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'cancel'.tr,
                            style: GoogleFonts.poppins(
                              color: AppTheme.scaffoldBackgroundColor,
                              //      fontFamily: isUrdu ? 'Jameel Noori Nastaleeq' : null,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1400),
                        child: Obx(() => ElevatedButton(
                              onPressed: userController.isLoading.value
                                  ? null
                                  : () {
                                      userController.updateUserData();
                                      Navigator.pop(context);
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppTheme.scaffoldBackgroundColor,
                                foregroundColor: AppTheme.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                              ),
                              child: userController.isLoading.value
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: AppTheme.primaryColor,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      'save'.tr,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        //             fontFamily: isUrdu ? 'Jameel Noori Nastaleeq' : null,
                                      ),
                                    ),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isUrdu = Get.locale?.languageCode == 'ur';
    return Directionality(
      textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.9),
                    AppTheme.secondaryColor.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                // image: const DecorationImage(
                //   image: AssetImage('assets/images/profile_header.jpg'),
                //   fit: BoxFit.cover,
                //   opacity: 0.7,
                // ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: FadeInDown(
                duration: const Duration(milliseconds: 800),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor:
                          AppTheme.scaffoldBackgroundColor.withOpacity(0.9),
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      userController.name.value.isEmpty
                          ? 'user'.tr
                          : userController.name.value,
                      style: GoogleFonts.poppins(
                        fontSize: isUrdu ? 20 : 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.scaffoldBackgroundColor,
                        //   fontFamily: isUrdu ? 'Jameel Noori Nastaleeq' : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Profile Card
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: FadeInUp(
                duration: const Duration(milliseconds: 900),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.scaffoldBackgroundColor,
                          AppTheme.primaryColor.withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'profile_details'.tr,
                          style: GoogleFonts.poppins(
                            fontSize: isUrdu ? 18 : 20,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryColor,
                            //  fontFamily: isUrdu ? 'Jameel Noori Nastaleeq' : null,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Obx(() => _buildInfoRow(
                            'name'.tr, userController.name.value)),
                        const SizedBox(height: 12),
                        Obx(() => _buildInfoRow(
                            'email'.tr, userController.email.value)),
                        const SizedBox(height: 12),
                        Obx(() => _buildInfoRow('phone_number'.tr,
                            userController.phoneNumber.value)),
                        const SizedBox(height: 12),
                        Obx(() => _buildInfoRow(
                            'location'.tr, userController.location.value)),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ZoomIn(
                            duration: const Duration(milliseconds: 1000),
                            child: ElevatedButton.icon(
                              onPressed: () => _showEditDialog(context),
                              icon: Icon(Icons.edit,
                                  color: AppTheme.scaffoldBackgroundColor),
                              label: Text(
                                'edit'.tr,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  //          fontFamily: isUrdu ? 'Jameel Noori Nastaleeq' : null,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                foregroundColor:
                                    AppTheme.scaffoldBackgroundColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Detection History
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: FadeInUp(
                duration: const Duration(milliseconds: 1100),
                child: Text(
                  'detection_history'.tr,
                  style: GoogleFonts.poppins(
                    fontSize: isUrdu ? 18 : 20,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                    //   fontFamily: isUrdu ? 'Jameel Noori Nastaleeq' : null,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: userController.getDetectionHistory(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child:
                        CircularProgressIndicator(color: AppTheme.primaryColor),
                  );
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                        'no_history_found'.tr,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: AppTheme.secondaryColor,
                          //     fontFamily: isUrdu ? 'Jameel Noori Nastaleeq' : null,
                        ),
                      ),
                    ),
                  );
                }
                final history = snapshot.data!;
                if (history.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                        'no_history_found'.tr,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: AppTheme.secondaryColor,
                          //   fontFamily: isUrdu ? 'Jameel Noori Nastaleeq' : null,
                        ),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final item = history[index];
                    final prediction = item['prediction'];
                    return FadeInUp(
                      duration: Duration(milliseconds: 1200 + index * 100),
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () => Get.toNamed('/recommendations',
                                arguments: {
                                  'label': prediction['label'],
                                  'imageUrl': item['imageUrl'],
                                  'isUrl': true
                                }),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: item['imageUrl'],
                                  width: 60,
                                  height: 60,
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
                                ),
                              ),
                              title: Text(
                                prediction['label'] ?? 'unknown'.tr,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryColor,
                                  //     fontFamily: isUrdu ? 'Jameel Noori Nastaleeq' : null,
                                ),
                              ),
                              subtitle: Text(
                                '${'confidence'.tr}: ${(prediction['confidence']).toStringAsFixed(2)}%',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: AppTheme.secondaryColor,
                                  //        fontFamily: isUrdu ? 'Jameel Noori Nastaleeq' : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 80), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    //  final isUrdu = Get.locale?.languageCode == 'ur';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryColor,
            //  fontFamily: isUrdu ? 'Jameel Noori Nastaleeq' : null,
          ),
        ),
        Expanded(
          child: Text(
            value.isEmpty ? 'not_set'.tr : value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppTheme.secondaryColor,
              //    fontFamily: isUrdu ? 'Jameel Noori Nastaleeq' : null,
            ),
          ),
        ),
      ],
    );
  }
}
