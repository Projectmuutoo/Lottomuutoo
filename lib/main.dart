import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottotmuutoo/pages/navpages/navbarpages.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await GetStorage.init();
  // เรียกใช้ initializeDateFormatting เพื่อโหลดข้อมูล Locale ไทยแล้นนนน
  initializeDateFormatting().then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LOTTOTMUUTOO',
      theme: ThemeData(useMaterial3: false),
      home: NavbarPage(
        email: 'ยังไม่ได้เข้าสู่ระบบ',
        selectedPage: 0,
      ),
    );
  }
}
