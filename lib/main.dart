import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bindings/home.dart';
import 'pages/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Rest Countries App',
      debugShowCheckedModeBanner: false,
      locale: const Locale('pt', 'BR'),
      initialBinding: HomeBinding(),
      home: HomePage(),
    );
  }
}
