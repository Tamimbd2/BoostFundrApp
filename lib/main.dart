import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app/routes/app_pages.dart';
import 'app/data/providers/auth_provider.dart';
import 'app/data/translations/app_translations.dart';

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
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        canvasColor: Colors.black,
        textTheme: GoogleFonts.montserratTextTheme(ThemeData.dark().textTheme),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF22C55E),
          surface: Colors.black,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        canvasColor: Colors.black,
        textTheme: GoogleFonts.montserratTextTheme(ThemeData.dark().textTheme),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF22C55E),
          surface: Colors.black,
        ),
        useMaterial3: true,
      ),
    ),
  );
}
