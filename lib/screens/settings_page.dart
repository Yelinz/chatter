import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController knownLanguageController = TextEditingController();
  final TextEditingController learningLanguageController = TextEditingController();
  Language? knownLanguage;
  Language? learningLanguage;

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<Language>> knownLanguageEntries =
        <DropdownMenuEntry<Language>>[];
    for (final Language lang in Language.values) {
      knownLanguageEntries.add(DropdownMenuEntry<Language>(
          value: lang, label: lang.name, enabled: lang != learningLanguage));
    }

    final List<DropdownMenuEntry<Language>> learningLanguageEntries =
    <DropdownMenuEntry<Language>>[];
    for (final Language lang in Language.values) {
      learningLanguageEntries.add(DropdownMenuEntry<Language>(
          value: lang, label: lang.translation, enabled: lang != knownLanguage));
    }

    return SafeArea(
        child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DropdownMenu<Language>(
                initialSelection: Language.english,
                controller: knownLanguageController,
                label: const Text('Known Language'),
                dropdownMenuEntries: knownLanguageEntries,
                onSelected: (Language? language) {
                  setState(() {
                    knownLanguage = language;
                  });
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DropdownMenu<Language>(
                initialSelection: Language.german,
                controller: learningLanguageController,
                label: const Text('Learning Language'),
                dropdownMenuEntries: learningLanguageEntries,
                onSelected: (Language? language) {
                  setState(() {
                    learningLanguage = language;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    ));
  }
}

enum Language {
  english("English", "English", "i"),
  german("Deutsch", "German", "e");

  const Language(this.name, this.translation, this.icon);
  final String name;
  final String translation;
  final String icon;
}
