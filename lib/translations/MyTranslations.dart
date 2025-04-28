import 'package:get/get.dart';
import 'package:kisankit/translations/en.dart';
import 'package:kisankit/translations/ur.dart';

class MyTranslations extends Translations {
  // Override keys for each supported language
  @override
  Map<String, Map<String, String>> get keys => {
        'en': en,
        'ur': ur,
      };
}
