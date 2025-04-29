import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kisankit/controllers/auth_controller.dart';
import 'package:kisankit/controllers/user_controller.dart';
import 'package:kisankit/screens/IntroScreen.dart';
import 'package:kisankit/screens/auth/LoginScreen.dart';
import 'package:kisankit/screens/detect/DetectionResultScreen.dart';
import 'package:kisankit/screens/detect/RecommendationsScreen.dart';
import 'package:kisankit/screens/home/HomeScreen.dart';
import 'package:kisankit/screens/voice/VoiceInputScreen.dart';
import 'package:kisankit/theme/app_theme.dart';
import 'package:kisankit/translations/MyTranslations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(UserController());
  Get.put(AuthController()); // Initialize AuthController early
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    return Obx(() {
      return GetMaterialApp(
        title: 'KisanKit',
        translations: MyTranslations(),
        locale: authController.locale.value, // Use reactive locale
        fallbackLocale: const Locale('en'),
        theme: AppTheme.getTheme(authController.locale.value),
        debugShowCheckedModeBanner: false,
        home: Obx(() {
          if (authController.isLoading.value) {
            return const Scaffold(
              backgroundColor:
                  AppTheme.scaffoldBackgroundColor, // Set background color
              body: Center(
                child: CircularProgressIndicator(
                  color: AppTheme.primaryColor,
                  backgroundColor: AppTheme.scaffoldBackgroundColor,
                ),
              ),
            );
          }
          if (authController.isLoggedIn.value) {
            return HomeScreen();
          }
          return authController.isFirstTimeUser.value
              ? IntroScreen()
              : LoginScreen();
        }),
        getPages: [
          GetPage(name: '/intro', page: () => IntroScreen()),
          GetPage(name: '/home', page: () => HomeScreen()),
          GetPage(name: '/login', page: () => LoginScreen()),
          GetPage(name: '/voice', page: () => VoiceInputScreen()),
          GetPage(name: '/detect', page: () => DetectionResultScreen()),
          GetPage(
              name: '/recommendations', page: () => RecommendationsScreen()),
        ],
      );
    });
  }
}

// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Common Rust Firestore Test',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: InsertCommonRustScreen(),
//     );
//   }
// }

// class FirestoreService {
//   final CollectionReference diseasesCollection =
//       FirebaseFirestore.instance.collection('diseaseDetails');

//   // Function to insert Common Rust data
//   Future<void> insertCommonRustData() async {
//     // Common Rust data
//     List<Map<String, dynamic>> diseasesData = [
//       {
//         "label": "Wheat Brown leaf rust",
//         "english_name": "Brown Leaf Rust",
//         "urdu_name": "گندم کا بھورا پتوں کا زنگ",
//         "cause_en":
//             "Caused by the fungus Puccinia triticina, spreading through windborne spores in warm, moist conditions.",
//         "cause_ur":
//             "پکسی نیا ٹریٹیسینا نامی فنگس کی وجہ سے ہوتا ہے، جو گرم، مرطوب حالات میں ہوا کے ذریعے پھیلنے والے بیضوں سے پھیلتا ہے۔",
//         "symptoms_en":
//             "Brown to orange pustules on leaves, reducing photosynthesis and grain yield. Severe cases cause leaf drying and premature senescence.",
//         "symptoms_ur":
//             "پتوں پر بھورے سے نارنجی پھوڑے، جو فوٹوسنتھیسس اور دانوں کی پیداوار کو کم کرتے ہیں۔ شدید صورتوں میں پتے سوکھ جاتے ہیں اور وقت سے پہلے بڑھاپا آتا ہے۔",
//         "preventions_en":
//             "Plant resistant varieties like PBW 343. Monitor fields during tillering. Remove volunteer wheat. Practice crop rotation.",
//         "preventions_ur":
//             "پی بی ڈبلیو 343 جیسی مزاحمتی اقسام لگائیں۔ ٹیلرنگ کے دوران کھیتوں کی نگرانی کریں۔ خود رو گندم ہٹائیں۔ فصل کی گردش کریں۔",
//         "organic_cure_en":
//             "Apply sulfur-based biofungicides or neem extracts. Remove infected debris. Use compost teas to boost plant immunity.",
//         "organic_cure_ur":
//             "گندھک پر مبنی بائیو فنجیسائیڈز یا نیم کے عرق لگائیں۔ متاثرہ ملبہ ہٹائیں۔ پودوں کی قوت مدافعت بڑھانے کے لیے کمپوسٹ ٹی استعمال کریں۔",
//         "chemical_cure_en":
//             "Spray propiconazole (Tilt®) or tebuconazole (Folicur®) at early pustule formation. Repeat every 10-14 days if conditions favor disease.",
//         "chemical_cure_ur":
//             "پھوڑوں کے ابتدائی بننے پر پروپیکونازول (ٹلٹ®) یا ٹیبوکونازول (فولیکر®) چھڑکیں۔ اگر حالات بیماری کے حق میں ہوں تو ہر 10-14 دن بعد دہرائیں۔"
//       },
//     ];

//     try {
//       for (var disease in diseasesData) {
//         await diseasesCollection.doc(disease['label']).set(disease);
//         print('Inserted ${disease['label']} successfully');
//       }
//     } catch (e) {
//       print('Error inserting diseases: $e');
//       throw e;
//     }
//   }
// }

// // Sample UI to test insertion
// class InsertCommonRustScreen extends StatelessWidget {
//   final FirestoreService firestoreService = FirestoreService();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Insert Common Rust Data')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             try {
//               await firestoreService.insertCommonRustData();
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                     content: Text('Common Rust data inserted successfully')),
//               );
//             } catch (e) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Error inserting data: $e')),
//               );
//             }
//           },
//           child: Text('Insert Common Rust to Firestore'),
//         ),
//       ),
//     );
//   }
// }
