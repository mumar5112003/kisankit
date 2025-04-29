import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kisankit/models/chat_message_model.dart';
import 'package:kisankit/theme/app_theme.dart';

class UserController extends GetxController {
  // User details
  Rx<User?> user = Rx<User?>(null);
  RxString name = ''.obs;
  RxString email = ''.obs;
  RxString phoneNumber = ''.obs;
  RxString location = ''.obs;
  RxBool isLoading = false.obs;
  // Controllers for text inputs
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _initializeUser();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    super.dispose();
  }

  // Initialize the user data from Firebase
  void _initializeUser() {
    FirebaseAuth.instance.authStateChanges().listen((userData) {
      if (userData != null) {
        user.value = userData;

        // Check if user is logged in with email or phone
        if (userData.email != null) {
          email.value = userData.email!;
          phoneController.text = userData.phoneNumber ?? '';
        } else if (userData.phoneNumber != null) {
          phoneNumber.value = userData.phoneNumber!;
          emailController.text = userData.email ?? '';
        }

        // Fetch additional data from Firestore (name, contact, location)
        _fetchUserDetailsFromFirestore();
      }
    });
  }

  // Clear all user-related state
  void clearState() {
    user.value = null;
    name.value = '';
    email.value = '';
    phoneNumber.value = '';
    location.value = '';
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    locationController.clear();
  }

  Future<void> saveChat(ChatMessage chatMessage) async {
    try {
      if (user.value != null) {
        final chatData = chatMessage.toMap();
        chatData['userUid'] = user.value!.uid; // Add user UID to chat message

        final docRef = FirebaseFirestore.instance.collection('chats').doc();
        await docRef.set(chatData);
      }
    } catch (e) {
      print('Error saving chat: $e');
    }
  }

  Future<List<ChatMessage>> getChatHistory() async {
    try {
      if (user.value != null) {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('chats')
            .where('userUid', isEqualTo: user.value!.uid) // Filter by user UID
            .orderBy('timestamp', descending: true)
            .get();

        return querySnapshot.docs.map((doc) {
          return ChatMessage.fromMap(doc.data());
        }).toList();
      }
      return [];
    } catch (e) {
      print('Error retrieving chat history: $e');
      return [];
    }
  }

  // Fetch additional user details from Firestore
  void _fetchUserDetailsFromFirestore() async {
    if (user.value != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.value!.uid)
            .get();

        if (userDoc.exists) {
          // Update controllers with data from Firestore
          name.value = userDoc['name'] ?? '';
          location.value = userDoc['location'] ?? '';
          email.value = userDoc['email'] ?? '';
          emailController.text = email.value;
          phoneNumber.value = userDoc['phoneNumber'] ?? '';
          // Set text in controllers
          nameController.text = name.value;
          locationController.text = location.value;
          phoneController.text = phoneNumber.value;
        }
      } catch (e) {
        print("Error fetching user details: $e");
      }
    }
  }

  Future<List<Map<String, dynamic>>> getDetectionHistory() async {
    try {
      if (user.value == null) return [];
      final querySnapshot = await FirebaseFirestore.instance
          .collection('detectionHistory')
          .where('userId', isEqualTo: user.value!.uid)
          .orderBy('timestamp', descending: true)
          .get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching detection history: $e');
      Get.snackbar('error'.tr, 'failed_to_fetch_history'.tr);
      return [];
    }
  }

  // Update user data in Firestore
  Future<void> updateUserData() async {
    if (user.value == null) return;
    isLoading.value = true;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.value!.uid)
          .update({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phoneNumber': phoneController.text.trim(),
        'location': locationController.text.trim(),
      });
      // Update RxString values to trigger UI rebuild
      name.value = nameController.text.trim();
      email.value = emailController.text.trim();
      phoneNumber.value = phoneController.text.trim();
      location.value = locationController.text.trim();
      Get.snackbar(
        'success'.tr,
        'profile_updated'.tr,
        backgroundColor: AppTheme.primaryColor,
        colorText: AppTheme.scaffoldBackgroundColor,
      );
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'failed_to_update_profile'.tr,
        backgroundColor: AppTheme.secondaryColor,
        colorText: AppTheme.scaffoldBackgroundColor,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
