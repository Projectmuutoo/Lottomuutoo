import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottotmuutoo/config/config.dart';
import 'package:lottotmuutoo/models/response/BasketUserResponse.dart';
import 'package:lottotmuutoo/models/response/UserIdxGetResponse.dart';
import 'package:http/http.dart' as http;
import 'package:lottotmuutoo/pages/login.dart';
import 'package:lottotmuutoo/pages/widgets/drawer.dart';

class ProfilePage extends StatefulWidget {
  final String email;
  final StreamController<int> basketCountController;

  const ProfilePage({
    super.key,
    required this.email,
    required this.basketCountController,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String url;
  late Future<void> loadData;
  late UserIdxGetResponse user;
  late BasketUserResponse basket;

  TextEditingController nameCtl = TextEditingController();
  TextEditingController nicknameCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();
  TextEditingController genderCtl = TextEditingController();
  TextEditingController birthdayCtl = TextEditingController();

  bool change = false;
  bool isLoading = false;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        birthdayCtl.text =
            "${picked.day}/${picked.month}/${picked.year}"; // อัพเดทค่าใน brithdayCtl
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ใช้ width สำหรับ horizontal
    // left/right
    double width = MediaQuery.of(context).size.width;
    // ใช้ height สำหรับ vertical
    // top/bottom
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      //PreferredSize กำหนดขนาด AppBar กำหนดเป็น 25% ของ width ของหน้าจอ * 0.25
      appBar: PreferredSize(
        preferredSize: Size(
          width,
          width * 0.40, //////////////
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: height * 0.01,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF29B6F6), //สีฟ้าที่เรารัก
              borderRadius: BorderRadius.only(
                //border
                bottomLeft: Radius.circular(42),
                bottomRight: Radius.circular(42),
              ),
              boxShadow: [
                BoxShadow(
                  //มันคือเงาข้างล่างจ่ะ 3 อันนี้ลองปรับเล่นเองงนะจ่ะ
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: AppBar(
              automaticallyImplyLeading: false,
              shadowColor: Colors
                  .transparent, //ถ้าไม่มีอันนี้เราก็ไม่มีขอบ border ล่างสีฟ้านั้น
              backgroundColor: Colors
                  .transparent, //ถ้าไม่มีอันนี้เราก็ไม่มีขอบ border ล่างสีฟ้านั้น
              flexibleSpace: Padding(
                padding: EdgeInsets.only(
                  top: height * 0.06,
                  left: width * 0.04,
                  right: width * 0.06,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: width * 0.2,
                          fit: BoxFit.cover,
                          color: Colors.white,
                        ),
                        Builder(
                          builder: (BuildContext context) {
                            return InkWell(
                              onTap: () {
                                Scaffold.of(context).openDrawer();
                              },
                              child: Icon(
                                Icons.menu,
                                size: width * 0.075,
                                color: Colors.black,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ข้อมูลส่วนตัว',
                          style: TextStyle(
                            fontFamily: 'prompt',
                            fontSize: width * 0.1,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      drawer: DrawerPage(
        email: widget.email,
        selectedPage: 5,
      ),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (widget.email == 'ยังไม่ได้เข้าสู่ระบบ') {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.6,
                  child: Center(
                    child: InkWell(
                      onTap: goLogin,
                      child: Container(
                        width: width * 0.8,
                        height: height * 0.08,
                        decoration: const BoxDecoration(
                          color: Color(0xfffef3c7),
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 0,
                              blurRadius: 2,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'คุณยังไม่ได้เข้าสู่ระบบ',
                              style: TextStyle(
                                fontFamily: 'prompt',
                                fontSize: width * 0.05,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            if (snapshot.connectionState != ConnectionState.done) {
              return Container(
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  top: height * 0.02,
                ),
                child: Column(
                  children: [
                    Container(
                      width: width * 0.90,
                      padding: EdgeInsets.symmetric(
                        vertical: height * 0.035,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFF29b6f6),
                        borderRadius: BorderRadius.all(
                          Radius.circular(18),
                        ),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 0,
                            blurRadius: 2,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            user.result[0].name,
                            style: TextStyle(
                              fontFamily: 'prompt',
                              fontSize: width * 0.06,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: height * 0.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "รหัสสมาชิก: ${user.result[0].uid.toString()}",
                                style: TextStyle(
                                  fontFamily: 'prompt',
                                  fontSize: width * 0.05,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!change)
                          Text(
                            "ข้อมูลส่วนตัว",
                            style: TextStyle(
                              fontFamily: 'prompt',
                              fontSize: width * 0.06,
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        if (change)
                          Text(
                            "แก้ไขข้อมูลส่วนตัว",
                            style: TextStyle(
                              fontFamily: 'prompt',
                              fontSize: width * 0.06,
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    Container(
                      width: width * 0.90,
                      padding: EdgeInsets.symmetric(
                        vertical: height * 0.01,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "ชื่อ-นามสกุล",
                                style: TextStyle(
                                  fontFamily: 'prompt',
                                  fontSize: width * 0.04,
                                  color: const Color(0xff828282),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(width: width * 0.02),
                              if (change)
                                TextField(
                                  controller: nameCtl,
                                  keyboardType: TextInputType.text,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    constraints: BoxConstraints(
                                      maxHeight: height * 0.035,
                                      maxWidth: width * 0.6,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: width * 0.04,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(width: 1),
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontFamily: 'prompt',
                                    fontSize: width * 0.04,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              if (!change)
                                TextField(
                                  controller: nameCtl,
                                  keyboardType: TextInputType.text,
                                  enabled: false,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    constraints: BoxConstraints(
                                      maxHeight: height * 0.035,
                                      maxWidth: width * 0.6,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: width * 0.04,
                                    ),
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontFamily: 'prompt',
                                    fontSize: width * 0.04,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: height * 0.01),
                          Container(
                            height: height * 0.001,
                            color: Colors.grey,
                          ),
                          SizedBox(height: height * 0.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "ชื่อเล่น",
                                style: TextStyle(
                                  fontFamily: 'prompt',
                                  fontSize: width * 0.04,
                                  color: const Color(0xff828282),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(width: width * 0.02),
                              if (change)
                                TextField(
                                  controller: nicknameCtl,
                                  keyboardType: TextInputType.text,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    constraints: BoxConstraints(
                                      maxHeight: height * 0.035,
                                      maxWidth: width * 0.25,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: width * 0.04,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(width: 1),
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontFamily: 'prompt',
                                    fontSize: width * 0.04,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              if (!change)
                                TextField(
                                  controller: nicknameCtl,
                                  keyboardType: TextInputType.text,
                                  enabled: false,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    constraints: BoxConstraints(
                                      maxHeight: height * 0.035,
                                      maxWidth: width * 0.25,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: width * 0.04,
                                    ),
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontFamily: 'prompt',
                                    fontSize: width * 0.04,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              SizedBox(width: width * 0.02),
                              Text(
                                "เบอร์โทร",
                                style: TextStyle(
                                  fontFamily: 'prompt',
                                  fontSize: width * 0.04,
                                  color: const Color(0xff828282),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(width: width * 0.02),
                              if (change)
                                TextField(
                                  controller: phoneCtl,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  decoration: InputDecoration(
                                    constraints: BoxConstraints(
                                      maxHeight: height * 0.035,
                                      maxWidth: width * 0.3,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(width: 1),
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontFamily: 'prompt',
                                    fontSize: width * 0.04,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              if (!change)
                                TextField(
                                  controller: phoneCtl,
                                  keyboardType: TextInputType.number,
                                  enabled: false,
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  decoration: InputDecoration(
                                    constraints: BoxConstraints(
                                      maxHeight: height * 0.035,
                                      maxWidth: width * 0.3,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontFamily: 'prompt',
                                    fontSize: width * 0.04,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: height * 0.01),
                          Container(
                            height: height * 0.001,
                            color: Colors.grey,
                          ),
                          SizedBox(height: height * 0.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "ว/ด/ป/เกิด",
                                    style: TextStyle(
                                      fontFamily: 'prompt',
                                      fontSize: width * 0.04,
                                      color: const Color(0xff828282),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(width: width * 0.02),
                                  if (change)
                                    GestureDetector(
                                      onTap: () => _selectDate(context),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                          border: Border.all(
                                            width: 1,
                                            color: const Color(0xffb8b8b8),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: width * 0.02,
                                            vertical: height * 0.003,
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                birthdayCtl.text.isNotEmpty
                                                    ? birthdayCtl.text
                                                    : " ",
                                                style: TextStyle(
                                                  fontFamily: 'prompt',
                                                  fontSize: width * 0.04,
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              SizedBox(width: width * 0.01),
                                              SvgPicture.string(
                                                '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M7 11h2v2H7zm0 4h2v2H7zm4-4h2v2h-2zm0 4h2v2h-2zm4-4h2v2h-2zm0 4h2v2h-2z"></path><path d="M5 22h14c1.103 0 2-.897 2-2V6c0-1.103-.897-2-2-2h-2V2h-2v2H9V2H7v2H5c-1.103 0-2 .897-2 2v14c0 1.103.897 2 2 2zM19 8l.001 12H5V8h14z"></path></svg>',
                                                width: width * 0.025,
                                                height: height * 0.025,
                                                fit: BoxFit.cover,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (!change)
                                    Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.02,
                                          vertical: height * 0.003,
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              birthdayCtl.text.isNotEmpty
                                                  ? birthdayCtl.text
                                                  : " ",
                                              style: TextStyle(
                                                fontFamily: 'prompt',
                                                fontSize: width * 0.04,
                                                color: const Color.fromARGB(
                                                    255, 0, 0, 0),
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            SizedBox(width: width * 0.01),
                                            SvgPicture.string(
                                              '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M7 11h2v2H7zm0 4h2v2H7zm4-4h2v2h-2zm0 4h2v2h-2zm4-4h2v2h-2zm0 4h2v2h-2z"></path><path d="M5 22h14c1.103 0 2-.897 2-2V6c0-1.103-.897-2-2-2h-2V2h-2v2H9V2H7v2H5c-1.103 0-2 .897-2 2v14c0 1.103.897 2 2 2zM19 8l.001 12H5V8h14z"></path></svg>',
                                              width: width * 0.025,
                                              height: height * 0.025,
                                              fit: BoxFit.cover,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(width: width * 0.02),
                              Row(
                                children: [
                                  Text(
                                    "เพศ",
                                    style: TextStyle(
                                      fontFamily: 'prompt',
                                      fontSize: width * 0.04,
                                      color: const Color(0xff828282),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(width: width * 0.03),
                                  if (change)
                                    Container(
                                      width: width * 0.22,
                                      height: height * 0.035,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                        border: Border.all(width: 0.5),
                                      ),
                                      child: PopupMenuButton<String>(
                                        padding: EdgeInsets.zero,
                                        color: const Color(0xffd2d2d2),
                                        offset: Offset(
                                          width * 0.01,
                                          height * 0.035,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(width: width * 0.03),
                                            Text(
                                              user.result[0].gender != '-'
                                                  ? user.result[0].gender
                                                  : '-',
                                              style: TextStyle(
                                                fontFamily: 'prompt',
                                                fontSize: width * 0.04,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                right: width * 0.02,
                                              ),
                                              child: SvgPicture.string(
                                                '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M16.293 9.293 12 13.586 7.707 9.293l-1.414 1.414L12 16.414l5.707-5.707z"></path></svg>',
                                                width: width * 0.03,
                                                height: height * 0.03,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onSelected: (String newValue) {
                                          setState(() {
                                            user.result[0].gender = newValue;
                                          });
                                        },
                                        itemBuilder: (BuildContext context) {
                                          return <String>[
                                            'ชาย',
                                            'หญิง',
                                            'ไม่ระบุ'
                                          ].map((String value) {
                                            return PopupMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                  fontFamily: 'prompt',
                                                  fontSize: width * 0.04,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            );
                                          }).toList();
                                        },
                                      ),
                                    ),
                                  if (!change)
                                    Container(
                                      width: width * 0.22,
                                      height: height * 0.035,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                      ),
                                      child: PopupMenuButton<String>(
                                        enabled: false,
                                        padding: EdgeInsets.zero,
                                        color: const Color(0xffd2d2d2),
                                        offset: Offset(
                                          width * 0.01,
                                          height * 0.035,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(width: width * 0.03),
                                            Text(
                                              user.result[0].gender != '-'
                                                  ? user.result[0].gender
                                                  : '-',
                                              style: TextStyle(
                                                fontFamily: 'prompt',
                                                fontSize: width * 0.04,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                right: width * 0.02,
                                              ),
                                              child: SvgPicture.string(
                                                '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M16.293 9.293 12 13.586 7.707 9.293l-1.414 1.414L12 16.414l5.707-5.707z"></path></svg>',
                                                width: width * 0.03,
                                                height: height * 0.03,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onSelected: (String newValue) {
                                          setState(() {
                                            user.result[0].gender = newValue;
                                          });
                                        },
                                        itemBuilder: (BuildContext context) {
                                          return <String>[
                                            'ชาย',
                                            'หญิง',
                                            'ไม่ระบุ'
                                          ].map((String value) {
                                            return PopupMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                  fontFamily: 'prompt',
                                                  fontSize: width * 0.04,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            );
                                          }).toList();
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: height * 0.01),
                          Container(
                            height: height * 0.001,
                            color: Colors.grey,
                          ),
                          SizedBox(height: height * 0.01),
                          Row(
                            children: [
                              Text(
                                "อีเมล",
                                style: TextStyle(
                                  fontFamily: 'prompt',
                                  fontSize: width * 0.04,
                                  color: const Color(0xff828282),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(width: width * 0.03),
                              Text(
                                user.result[0].email,
                                style: TextStyle(
                                  fontFamily: 'prompt',
                                  fontSize: width * 0.042,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: height * 0.01),
                          Container(
                            height: height * 0.001,
                            color: Colors.grey,
                          ),
                          SizedBox(height: height * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (!change)
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      change = true;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(
                                      width * 0.25,
                                      height * 0.045,
                                    ),
                                    backgroundColor: const Color(0xff939393),
                                    elevation: 3,
                                    shadowColor: Colors.black.withOpacity(1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    "แก้ไข",
                                    style: TextStyle(
                                      fontFamily: 'prompt',
                                      fontSize: width * 0.045,
                                      fontWeight: FontWeight.w400,
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                    ),
                                  ),
                                ),
                              if (change)
                                ElevatedButton(
                                  onPressed: canCel,
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(
                                      width * 0.25,
                                      height * 0.045,
                                    ),
                                    backgroundColor: const Color(0xff939393),
                                    elevation: 3,
                                    shadowColor: Colors.black.withOpacity(1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    "ยกเลิก",
                                    style: TextStyle(
                                      fontFamily: 'prompt',
                                      fontSize: width * 0.045,
                                      fontWeight: FontWeight.w400,
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                    ),
                                  ),
                                ),
                              if (change) SizedBox(width: width * 0.04),
                              if (change)
                                ElevatedButton(
                                  onPressed: update,
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(
                                      width * 0.25,
                                      height * 0.045,
                                    ),
                                    backgroundColor: const Color(0xff0288d1),
                                    elevation: 3,
                                    shadowColor: Colors.black.withOpacity(1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    "ยืนยัน",
                                    style: TextStyle(
                                      fontFamily: 'prompt',
                                      fontSize: width * 0.045,
                                      fontWeight: FontWeight.w400,
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];
    var res = await http.get(Uri.parse('$url/user/${widget.email}'));
    // log(res.body);
    user = userIdxGetResponseFromJson(res.body);
    var basketRes =
        await http.get(Uri.parse('$url/basket/${user.result[0].uid}'));
    basket = basketUserResponseFromJson(basketRes.body);
    var useridx = user.result;

    if (useridx.isNotEmpty) {
      setState(() {
        nameCtl.text = useridx[0].name;
        nicknameCtl.text = useridx[0].nickname;
        phoneCtl.text = useridx[0].phone;
        emailCtl.text = useridx[0].email;
        genderCtl.text = useridx[0].gender;
        birthdayCtl.text = useridx[0].birth;
        selectedDate = DateTime.tryParse(useridx[0].birth) ??
            DateTime.now(); // กำหนด selectedDate จาก birth
      });
    }
    setState(() {
      widget.basketCountController.add(basket.result.length);
    });
  }

  void update() async {
    setState(() {
      isLoading = true;
    });
    // แสดง Loading Dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        content: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];
    var json = {
      "name": nameCtl.text,
      "nickname": nicknameCtl.text,
      "email": emailCtl.text,
      "gender": user.result[0].gender,
      "birth": birthdayCtl.text,
      "phone": phoneCtl.text,
    };
    try {
      var res = await http.put(Uri.parse('$url/user/edit'),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: jsonEncode(json));
      if (res.statusCode == 201) {
        Navigator.pop(context);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03,
                vertical: MediaQuery.of(context).size.height * 0.02,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/success.png',
                    width: MediaQuery.of(context).size.width * 0.16,
                    height: MediaQuery.of(context).size.width * 0.16,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.04,
                  ),
                  Center(
                    child: Text(
                      'แก้ไขข้อมูลเสร็จสิ้น!',
                      style: TextStyle(
                        fontFamily: 'prompt',
                        fontWeight: FontWeight.w500,
                        fontSize: MediaQuery.of(context).size.width * 0.06,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            change = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(
                            MediaQuery.of(context).size.width * 0.25,
                            MediaQuery.of(context).size.height * 0.04,
                          ),
                          backgroundColor: const Color(0xff0288d1),
                          elevation: 3,
                          shadowColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Text(
                          "ตกลง",
                          style: TextStyle(
                            fontFamily: 'prompt',
                            fontWeight: FontWeight.w500,
                            fontSize: MediaQuery.of(context).size.width * 0.042,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        Navigator.pop(context);
      }
    } catch (err) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.03,
              vertical: MediaQuery.of(context).size.height * 0.02,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/error.png',
                  width: MediaQuery.of(context).size.width * 0.16,
                  height: MediaQuery.of(context).size.width * 0.16,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.04),
                Center(
                  child: Text(
                    'เซิฟเวอร์ไม่พร้อมใช้งาน!!',
                    style: TextStyle(
                      fontFamily: 'prompt',
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(
                      MediaQuery.of(context).size.width * 0.3,
                      MediaQuery.of(context).size.height * 0.04,
                    ),
                    backgroundColor: const Color(0xff0288d1),
                    elevation: 3, //เงาล่าง
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    "ตกลง",
                    style: TextStyle(
                      fontFamily: 'prompt',
                      fontWeight: FontWeight.w500,
                      fontSize: MediaQuery.of(context).size.width * 0.042,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  void goLogin() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        content: Container(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.03,
            vertical: MediaQuery.of(context).size.height * 0.02,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/question.png',
                width: MediaQuery.of(context).size.width * 0.16,
                height: MediaQuery.of(context).size.width * 0.16,
                fit: BoxFit.cover,
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.04),
              Center(
                child: Text(
                  'เข้าสู่ระบบ!',
                  style: TextStyle(
                    fontFamily: 'prompt',
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(
                        MediaQuery.of(context).size.width * 0.25,
                        MediaQuery.of(context).size.height * 0.04,
                      ),
                      backgroundColor: const Color(0xff0288d1),
                      elevation: 3, //เงาล่าง
                      shadowColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      "ตกลง",
                      style: TextStyle(
                        fontFamily: 'prompt',
                        fontWeight: FontWeight.w500,
                        fontSize: MediaQuery.of(context).size.width * 0.042,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(
                        MediaQuery.of(context).size.width * 0.25,
                        MediaQuery.of(context).size.height * 0.04,
                      ),
                      backgroundColor: const Color(0xff969696),
                      elevation: 3, //เงาล่าง
                      shadowColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      "ยกเลิก",
                      style: TextStyle(
                        fontFamily: 'prompt',
                        fontWeight: FontWeight.w500,
                        fontSize: MediaQuery.of(context).size.width * 0.042,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void canCel() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];
    var res = await http.get(Uri.parse('$url/user/${widget.email}'));
    // log(res.body);
    user = userIdxGetResponseFromJson(res.body);

    if (user.response) {
      setState(() {
        change = false;
        nameCtl.text = user.result[0].name;
        nicknameCtl.text = user.result[0].nickname;
        phoneCtl.text = user.result[0].phone;
        emailCtl.text = user.result[0].email;
        genderCtl.text = user.result[0].gender;
        birthdayCtl.text = user.result[0].birth;
        selectedDate =
            DateTime.tryParse(user.result[0].birth) ?? DateTime.now();
      });
    }
  }
}
