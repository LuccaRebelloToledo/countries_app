import 'package:get/get.dart';

import '../controllers/home.dart';
import '../services/country.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(CountryService()));
  }
}
