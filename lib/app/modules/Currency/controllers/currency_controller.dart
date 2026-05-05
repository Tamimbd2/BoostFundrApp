import 'package:get/get.dart';

class CurrencyController extends GetxController {
  final count = 0.obs;
  void increment() => count.value++;
}
