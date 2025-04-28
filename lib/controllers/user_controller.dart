import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kisankit/models/chat_message_model.dart';

class UserController extends GetxController {
  // User details
  Rx<User?> user = Rx<User?>(null);
  RxString name = ''.obs;
  RxString email = ''.obs;
  RxString phoneNumber = ''.obs;
  RxString location = ''.obs;

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
    // TODO: implement dispose
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

  // Update user data in Firestore
  Future<void> updateUserData() async {
    if (user.value != null) {
      try {
        // Firestore reference to user's document
        final userDocRef =
            FirebaseFirestore.instance.collection('users').doc(user.value!.uid);

        // Check if the document exists
        DocumentSnapshot userDoc = await userDocRef.get();

        if (userDoc.exists) {
          // Update user info in Firestore if the document exists
          await userDocRef.update({
            'name': user.value!.displayName != null
                ? user.value?.displayName
                : nameController.text,
            'location': locationController.text,
            'phoneNumber': user.value!.phoneNumber != null
                ? user.value?.phoneNumber
                : phoneController.text,
            'email': user.value!.email != null
                ? user.value?.email
                : emailController.text,
          });
        } else {
          // Create a new document if it doesn't exist
          await userDocRef.set({
            'name': user.value!.displayName != null
                ? user.value?.displayName
                : nameController.text,
            'phoneNumber': user.value!.phoneNumber != null
                ? user.value?.phoneNumber
                : phoneController.text,
            'email': user.value!.email != null
                ? user.value?.email
                : emailController.text,
            'location': locationController.text,
          });
        }

        // Success message with translation
        Get.snackbar('success_title'.tr, 'user_data_updated_successfully'.tr);
      } catch (e) {
        // Error message with translation
        Get.snackbar('error_title'.tr, 'failed_to_update_user_data'.tr);
        print(e);
      }
    }
  }
}
