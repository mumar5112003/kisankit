import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;
  var user = Rxn<User>();
  final isLoading = false.obs;
  var phoneNumber = ''.obs;
  var otpSent = false.obs;
  var verificationId = ''.obs;
  var verificationCompleted = false.obs;
  var isFirstTimeUser = true.obs;
  late SharedPreferences prefs;
  @override
  void onInit() {
    super.onInit();

    _checkUserStatus();
  }

  void updateLocalePreference(value) {
    prefs.setBool('isEnglishSelected', value);
  }

  // Check if the user has seen the intro screen
  Future<void> _checkFirstTimeUser() async {
    prefs = await SharedPreferences.getInstance();
    isFirstTimeUser.value = prefs.getBool('hasSeenIntro') ?? true;
  }

  // Call this method after the intro screen is viewed
  Future<void> markIntroSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenIntro', false);
    isFirstTimeUser.value = false;
  }

  void _checkUserStatus() async {
    await _checkFirstTimeUser().then((a) {
      FirebaseAuth.instance.authStateChanges().listen((currentUser) {
        if (currentUser != null) {
          isLoggedIn.value = true;
          user.value = currentUser;
          Get.offAllNamed('/home'); // Navigate to home screen if logged in
        } else {
          isLoggedIn.value = false;
          user.value = null;
          if (isFirstTimeUser.value) {
            Get.offAllNamed('/intro');
          } else {
            Get.offAllNamed('/login');
          } // Navigate to login screen if not logged in
        }
      });
    });
  }
  // Check user login status and navigate accordingly

  Future<void> logOut() async {
    try {
      isLoading.value = true;

      // Sign out from Firebase Authentication
      await FirebaseAuth.instance.signOut();

      // If the user is signed in with Google, also sign them out of Google
      final GoogleSignIn googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }

      // Update login state and navigate to the login screen
      isLoggedIn.value = false;
      user.value = null;
      otpSent.value = false;
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('error'.tr, 'logout_failed'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      print("Starting Google Sign-In...");
      isLoading.value = true;

      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        print("Google user is null (user cancelled login?)");
        Get.snackbar('Error', 'Login cancelled');
        return;
      }

      print("User selected account: ${googleUser.email}");

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print("Authentication received: accessToken = ${googleAuth.accessToken}");

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred =
          await FirebaseAuth.instance.signInWithCredential(credential);

      print("User signed in: ${userCred.user?.displayName}");
    } catch (e, stack) {
      print("❌ Google Sign-In failed: $e");
      print(stack);
      Get.snackbar('Error', 'Sign-in failed');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithPhoneNumber(String phone) async {
    try {
      isLoading.value = true;
      phoneNumber.value = phone;
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          isLoading.value = false;
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar('error'.tr, 'otp_send_failed'.tr);
          isLoading.value = false;
        },
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId.value = verificationId;
          otpSent.value = true;
          isLoading.value = false;
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      Get.snackbar('error'.tr, 'otp_send_failed'.tr);
      isLoading.value = false;
    }
  }

  Future<void> verifyOTP(String otp) async {
    try {
      isLoading.value = true;
      final credential = PhoneAuthProvider.credential(
          verificationId: verificationId.value, smsCode: otp);
      await FirebaseAuth.instance.signInWithCredential(credential);
      verificationCompleted.value = true;
      isLoading.value = false;
    } catch (e) {
      Get.snackbar('error'.tr, 'otp_verification_failed'.tr);
      isLoading.value = false;
    }
  }
}
