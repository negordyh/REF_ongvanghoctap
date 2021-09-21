import 'package:flutter/material.dart';
import 'package:moodle_flutter/utils/l10n.dart';
class LocaleProvider extends ChangeNotifier {
  Locale _locale;
  Locale get locale => _locale;

  void setLocate(Locale locale) {
    if (!L10n.all.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }

  void clearLocate() {
    _locale = null;
    notifyListeners();
  }
}