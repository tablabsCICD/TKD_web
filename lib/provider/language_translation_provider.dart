
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tkd_app/util/app_constants.dart';

class LanguageTranslationProvider extends ChangeNotifier {
  final SharedPreferences sharedPreferences;

  LanguageTranslationProvider({required this.sharedPreferences}) {
    _loadCurrentLanguage();
  }

  Locale _locale = Locale(ApiConstant.languages[0].languageCode!, ApiConstant.languages[0].countryCode);
  bool _isLtr = true;
  late int _languageIndex;

  Locale get locale => _locale;
  bool get isLtr => _isLtr;
  int get languageIndex => _languageIndex;

  _loadCurrentLanguage() async {
    _locale = Locale(sharedPreferences.getString(ApiConstant.LANGUAGE_CODE) ?? ApiConstant.languages[0].languageCode!,
        sharedPreferences.getString(ApiConstant.COUNTRY_CODE) ?? ApiConstant.languages[0].countryCode);
    _isLtr = _locale.languageCode != 'ar';
    for(int index=0; index<ApiConstant.languages.length; index++) {
      if(ApiConstant.languages[index].languageCode == locale.languageCode) {
        _languageIndex = index;
        break;
      }
    }
    notifyListeners();
  }

  void setLanguage(Locale locale) {
    _locale = locale;
    _isLtr = _locale.languageCode != 'hi';
    for(int index=0; index<ApiConstant.languages.length; index++) {
      if(ApiConstant.languages[index].languageCode == locale.languageCode) {
        _languageIndex = index;
        break;
      }
    }
    _saveLanguage(_locale);
    notifyListeners();
  }

  _saveLanguage(Locale locale) async {
    sharedPreferences.setString(ApiConstant.LANGUAGE_CODE, locale.languageCode);
    sharedPreferences.setString(ApiConstant.COUNTRY_CODE, locale.countryCode!);
  }
}