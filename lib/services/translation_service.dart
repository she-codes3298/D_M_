import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TranslationService {
  // Replace with your actual Google Cloud API key
  static const String apiKey = 'AIzaSyDnQXHH10udVvYSgSXzYMhNNPOdVBGBnEQ';
  static const String baseUrl = 'https://translation.googleapis.com/language/translate/v2';

  // Cache for translated texts to minimize API calls
  static Map<String, Map<String, String>> _translationCache = {};

  // Available languages
  static final List<LanguageOption> availableLanguages = [
    LanguageOption(code: 'en', name: 'English'),
    LanguageOption(code: 'hi', name: 'Hindi'),
    LanguageOption(code: 'ta', name: 'Tamil'),
    LanguageOption(code: 'te', name: 'Telugu'),
    LanguageOption(code: 'kn', name: 'Kannada'),
    LanguageOption(code: 'ml', name: 'Malayalam'),
    // Other Major Indian Languages
    LanguageOption(code: 'bn', name: 'Bengali'),
    LanguageOption(code: 'mr', name: 'Marathi'),
    LanguageOption(code: 'gu', name: 'Gujarati'),
    LanguageOption(code: 'pa', name: 'Punjabi'),
    LanguageOption(code: 'or', name: 'Odia'),
    LanguageOption(code: 'as', name: 'Assamese'),
    // Add more languages as needed
    // Add more languages as needed
  ];

  // Get current language from SharedPreferences
  static Future<String> getCurrentLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedLanguage') ?? 'en';
  }

  // Save language preference
  static Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', languageCode);
  }

  // Translate text using Google Cloud Translation API
  static Future<String> translateText(String text, String targetLanguage) async {
    // Don't translate if target is English (assuming English is your default language)
    if (targetLanguage == 'en') {
      return text;
    }

    // Check if we have this translation in cache
    if (_translationCache.containsKey(targetLanguage) &&
        _translationCache[targetLanguage]!.containsKey(text)) {
      return _translationCache[targetLanguage]![text]!;
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'q': text,
          'target': targetLanguage,
          'format': 'text'
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final translation = data['data']['translations'][0]['translatedText'];

        // Save to cache
        _translationCache[targetLanguage] ??= {};
        _translationCache[targetLanguage]![text] = translation;

        return translation;
      } else {
        print('Translation API error: ${response.body}');
        return text; // Return original text if translation fails
      }
    } catch (e) {
      print('Translation error: $e');
      return text; // Return original text if translation fails
    }
  }
}

// Language option model
class LanguageOption {
  final String code;
  final String name;

  LanguageOption({required this.code, required this.name});
}