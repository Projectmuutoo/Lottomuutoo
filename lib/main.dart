import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottotmuutoo/pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LOTTOTMUUTOO',
      theme: ThemeData(useMaterial3: false),
      home: HomePage(email: 'ยังไม่ได้เข้าสู่ระบบ'),
    );
  }
}
