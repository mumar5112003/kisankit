import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kisankit/controllers/user_controller.dart';

class ProfileComponent extends StatelessWidget {
  // Initialize the UserController
  final UserController userController = Get.put(UserController());

  // Format the phone number with '+' at the beginning if the language is Urdu

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Obx(() {
        // Watch for changes in userController's state
        if (userController.user.value == null) {
          return Center(child: Text('No user logged in'));
        }

        // Check if the user is logged in via email or phone and display accordingly
        bool isEmailLogin =
            userController.user.value!.displayName?.isNotEmpty ?? false;
        bool isPhoneLogin =
            userController.user.value!.displayName?.isEmpty ?? true;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Show either email or phone as text based on login method
              if (isEmailLogin) ...[
                Text('${'email'.tr}:', style: TextStyle(fontSize: 16)),
                Text(
                  userController.user.value!.email ??
                      '', // Display email as text
                  style: TextStyle(fontSize: 16),
                ),
              ] else if (isPhoneLogin) ...[
                Text('${'phone_number'.tr}:', style: TextStyle(fontSize: 16)),
                Text(
                  userController.user.value!.phoneNumber ??
                      '', // Display phone number as text
                  style: TextStyle(fontSize: 16),
                ),
              ],
              SizedBox(height: 20),

              // Name field - display as Text if logged in via email, else TextField if logged in via phone
              Text('${'name'.tr}:', style: TextStyle(fontSize: 16)),
              if (isEmailLogin) ...[
                // Display name as Text if logged in via email
                Text(userController.user.value?.displayName ?? '',
                    style: TextStyle(
                      fontSize: 16,
                    )),
              ] else ...[
                // Display name as TextField if logged in via phone
                TextField(
                  controller: userController.nameController,
                  decoration: InputDecoration(
                    hintText: 'enter_name'.tr,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors
                              .black), // Set border color to black when focused
                    ),
                    border: OutlineInputBorder(),
                  ),
                  cursorColor: Colors.black,
                ),
              ],
              SizedBox(height: 20),

              // Display email field only if the user logged in with phone
              if (isPhoneLogin) ...[
                Text('${'email'.tr}:', style: TextStyle(fontSize: 16)),
                TextField(
                  controller: userController.emailController,
                  decoration: InputDecoration(
                    hintText: 'enter_email'.tr,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors
                              .black), // Set border color to black when focused
                    ),
                    border: OutlineInputBorder(),
                  ),
                  cursorColor: Colors.black,
                ),
                SizedBox(height: 20),
              ],

              // Display phone number field only if the user logged in with email
              if (isEmailLogin) ...[
                Text('${'phone_number'.tr}:', style: TextStyle(fontSize: 16)),
                TextField(
                  controller: userController.phoneController,
                  decoration: InputDecoration(
                    hintText: 'enter_contact_number'.tr,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors
                              .black), // Set border color to black when focused
                    ),
                    border: OutlineInputBorder(),
                  ),
                  cursorColor: Colors.black,
                ),
                SizedBox(height: 20),
              ],

              // Location field
              Text('${'location'.tr}:', style: TextStyle(fontSize: 16)),
              TextField(
                controller: userController.locationController,
                decoration: InputDecoration(
                  hintText: 'enter_location'.tr,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .black), // Set border color to black when focused
                  ),
                  border: OutlineInputBorder(),
                ),
                cursorColor: Colors.black,
              ),
              SizedBox(height: 20),

              // Save Changes Button
              ElevatedButton(
                onPressed: userController.updateUserData,
                child:
                    Text('save_changes'.tr), // Use translation for Save Changes
              ),
            ],
          ),
        );
      }),
    );
  }
}
