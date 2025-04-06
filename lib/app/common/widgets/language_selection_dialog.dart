import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:d_m/providers/language_provider.dart';
import 'package:d_m/services/translation_service.dart';

class LanguageSelectionDialog extends StatelessWidget {
  const LanguageSelectionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);

    return AlertDialog(
      title: const Text('Select Language'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: TranslationService.availableLanguages.length,
          itemBuilder: (context, index) {
            final language = TranslationService.availableLanguages[index];
            return ListTile(
              title: Text(language.name),
              trailing: languageProvider.currentLanguage == language.code
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () {
                TranslationService.setLanguage(language.code);
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
  }
}