import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app/routes/app_pages.dart';
import 'app/data/providers/auth_provider.dart';
import 'app/data/translations/app_translations.dart';
import 'app/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  
  final storage = GetStorage();
  final savedLang = storage.read('language') ?? 'en_US';
  Locale locale;
  if (savedLang.contains('_')) {
    final parts = savedLang.split('_');
    locale = Locale(parts[0], parts[1]);
  } else {
    locale = Locale(savedLang);
  }

  runApp(
    GetMaterialApp(
      title: "BoostFundr",
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: locale,
      fallbackLocale: const Locale('en', 'US'),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: BindingsBuilder(() {
        Get.put(AuthProvider());
      }),
      themeMode: ThemeMode.dark,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
    ),
  );
}
