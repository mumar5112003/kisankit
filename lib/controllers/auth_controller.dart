import 'dart:ui';

import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kisankit/controllers/user_controller.dart'; // Import UserController

class AuthController extends GetxController {
  var isLoggedIn = false.obs;
  var user = Rxn<User>();
  var isLoading = true.obs;
  var phoneNumber = ''.obs;
  var otpSent = false.obs;
  var verificationId = ''.obs;
  var verificationCompleted = false.obs;
  var isFirstTimeUser = true.obs;
  var locale = const Locale('en').obs; // Reactive locale
  late SharedPreferences prefs;
  bool _isInitialized = false;

  @override
  void onInit() {
    super.onInit();
    if (!_isInitialized) {
      _initialize();
      // Listen to Firebase auth state changes
      FirebaseAuth.instance.authStateChanges().listen((User? firebaseUser) {
        print(
            'authStateChanges: user=${firebaseUser?.uid}, isLoggedIn=$isLoggedIn');
        isLoggedIn.value = firebaseUser != null;
        user.value = firebaseUser;
      });
    }
  }

  Future<void> _initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;

    try {
      isLoading.value = true;
      print('Initializing AuthController');
      prefs = await SharedPreferences.getInstance();

      // Initialize locale
      bool isEnglish = prefs.getBool('isEnglishSelected') ?? true;
      locale.value = isEnglish ? const Locale('en') : const Locale('ur');

      // Check if user has seen intro
      isFirstTimeUser.value = prefs.getBool('hasSeenIntro') ?? true;

      // Check authentication state
      final currentUser = FirebaseAuth.instance.currentUser;
      print('Initial user check: ${currentUser?.uid}');
      if (currentUser != null) {
        isLoggedIn.value = true;
        user.value = currentUser;
      } else {
        isLoggedIn.value = false;
        user.value = null;
      }
    } catch (e) {
      print('Initialization error: $e');
      Get.snackbar('error'.tr, 'Initialization failed'.tr);
    } finally {
      isLoading.value = false;
      print('Initialization complete, isLoggedIn=$isLoggedIn');
    }
  }

  Future<void> updateLocalePreference(bool isEnglish) async {
    await prefs.setBool('isEnglishSelected', isEnglish);
    locale.value = isEnglish ? const Locale('en') : const Locale('ur');
    Get.updateLocale(locale.value);
  }

  Future<void> markIntroSeen() async {
    await prefs.setBool('hasSeenIntro', false);
    isFirstTimeUser.value = false;
  }

  Future<void> logOut() async {
    try {
      isLoading.value = true;
      print('Logging out');
      await FirebaseAuth.instance.signOut();
      final GoogleSignIn googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
      isLoggedIn.value = false;
      user.value = null;
      otpSent.value = false;

      // Clear UserController state
      final userController = Get.find<UserController>();
      userController.clearState();
      print('UserController state cleared');

      Get.offAllNamed('/login');
    } catch (e) {
      print('Logout error: $e');
      Get.snackbar('error'.tr, 'logout_failed'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      print('Starting Google Sign-In');
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        print('Google Sign-In cancelled');
        Get.snackbar('Error', 'Login cancelled');
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print('Google Sign-In success: user=${userCredential.user?.uid}');
      isLoggedIn.value = true;
      user.value = userCredential.user;

      // Fallback navigation
      Future.delayed(Duration.zero, () {
        if (Get.currentRoute != '/home') {
          print('Navigating to /home after Google Sign-In');
          Get.offAllNamed('/home');
        }
      });
    } catch (e) {
      print('Google Sign-In error: $e');
      Get.snackbar('Error', 'Sign-in failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithPhoneNumber(String phone) async {
    try {
      isLoading.value = true;
      print('Starting Phone Sign-In: $phone');
      phoneNumber.value = phone;
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          final userCredential =
              await FirebaseAuth.instance.signInWithCredential(credential);
          print(
              'Phone auto-verification success: user=${userCredential.user?.uid}');
          isLoggedIn.value = true;
          user.value = userCredential.user;
          isLoading.value = false;

          // Fallback navigation
          Future.delayed(Duration.zero, () {
            if (Get.currentRoute != '/home') {
              print('Navigating to /home after phone auto-verification');
              Get.offAllNamed('/home');
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Phone verification failed: $e');
          Get.snackbar('error'.tr, 'otp_send_failed'.tr);
          isLoading.value = false;
        },
        codeSent: (String verificationId, int? resendToken) {
          print('OTP sent, verificationId=$verificationId');
          this.verificationId.value = verificationId;
          otpSent.value = true;
          isLoading.value = false;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('Code auto-retrieval timeout');
        },
      );
    } catch (e) {
      print('Phone Sign-In error: $e');
      Get.snackbar('error'.tr, 'otp_send_failed'.tr);
      isLoading.value = false;
    }
  }

  Future<void> verifyOTP(String otp) async {
    try {
      isLoading.value = true;
      print('Verifying OTP: $otp');
      final credential = PhoneAuthProvider.credential(
          verificationId: verificationId.value, smsCode: otp);
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print('OTP verification success: user=${userCredential.user?.uid}');
      isLoggedIn.value = true;
      user.value = userCredential.user;
      verificationCompleted.value = true;

      // Fallback navigation
      Future.delayed(Duration.zero, () {
        if (Get.currentRoute != '/home') {
          print('Navigating to /home after OTP verification');
          Get.offAllNamed('/home');
        }
      });
    } catch (e) {
      print('OTP verification error: $e');
      Get.snackbar('error'.tr, 'otp_verification_failed'.tr);
    } finally {
      isLoading.value = false;
    }
  }
}
