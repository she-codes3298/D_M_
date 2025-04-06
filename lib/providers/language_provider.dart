import 'package:flutter/foundation.dart';
import 'package:d_m/services/translation_service.dart';

class LanguageProvider extends ChangeNotifier {
  String _currentLanguage = 'en'; // Default language

  String get currentLanguage => _currentLanguage;

  void setLanguage(String languageCode) {
    _currentLanguage = languageCode;
    TranslationService.setLanguage(languageCode);
    notifyListeners();
  }

  // Added this method to fix the error in TranslatableText widget
  Future<String> translateText(String text) async {
    // Use TranslationService to translate the text
    return await TranslationService.translateText(text, _currentLanguage);
  }
}
