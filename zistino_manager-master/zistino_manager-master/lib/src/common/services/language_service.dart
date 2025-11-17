import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/language/en_us.dart';
import '../constants/language/fa_pe.dart';


class LocalizationService extends Translations {

  static const fallbackLocale =  Locale('en_US');

  static final langs = [
    'English',
    'فارسی',

  ];

  static final locales = [
    const Locale('en_US'),
    const Locale('fa', 'IR'),

  ];

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
          'fa_IR': faFA,

    // 'nl_NL': nlNL,
      };

  void changeLocale(String lang) {
    final locale = _getLocaleFromLanguage(lang);
    Get.updateLocale(locale!); //todo null check
  }

  Locale? _getLocaleFromLanguage(String lang) {
    //todo null check
    for (int i = 0; i < langs.length; i++) {
      if (lang == langs[i]) return locales[i];
    }
    return Get.locale;
  }
}
