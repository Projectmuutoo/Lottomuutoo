import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottotmuutoo/pages/navpages/navbarpages.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await GetStorage.init();
  await Supabase.initialize(
    url: 'https://qszqgcomisxmxgwemvgx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFzenFnY29taXN4bXhnd2Vtdmd4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjQ3NjU4NDUsImV4cCI6MjA0MDM0MTg0NX0.iLuktVAmm8PrfUpZ1v4yDE2_rNZXt2AIUjHjZ8-LQcs',
  );
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
