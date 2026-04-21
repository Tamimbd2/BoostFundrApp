import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/data/providers/auth_provider.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "BoostFundr",
      debugShowCheckedModeBanner: false,
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
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF22C55E),
          surface: Colors.black,
        ),
        useMaterial3: true,
      ),
    ),
  );
}
