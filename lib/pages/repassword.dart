import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottotmuutoo/config/config.dart';
import 'package:lottotmuutoo/models/request/resetpasswordPutRequest.dart';
import 'package:lottotmuutoo/models/response/UserGetResponse.dart';
import 'package:lottotmuutoo/models/response/resetpasswordPutResponse.dart';
import 'package:lottotmuutoo/pages/login.dart';
import 'package:lottotmuutoo/pages/widgets/drawer.dart';
import 'package:http/http.dart' as http;

class RepasswordPage extends StatefulWidget {
  const RepasswordPage({super.key});

  @override
  State<RepasswordPage> createState() => _RepasswordPageState();
}

class _RepasswordPageState extends State<RepasswordPage> {
  bool isTyping = false;
  bool isCheck = false;
  bool _isCheckedPassword = true;
  TextEditingController emailCth = TextEditingController();
  TextEditingController passwordNewCth = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ใช้ width สำหรับ horizontal
    // left/right
    double width = MediaQuery.of(context).size.width;
    // ใช้ height สำหรับ vertical
    // top/bottom
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(
          width,
          width * 0.30, ////////////////
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(() => const LoginPage());
                      },
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: width * 0.2,
                        fit: BoxFit.cover,
                        color: Colors.white,
                      ),
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
              ),
            ),
          ),
        ),
      ),
      drawer: DrawerPage(
        email: 'ยังไม่ได้เข้าสู่ระบบ',
        selectedPage: 0,
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: width * 0.06,
          right: width * 0.06,
          top: height * 0.02,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                bottom: height * 0.02,
              ),
              child: Text(
                "รีเซ็ตรหัสผ่าน",
                style: TextStyle(
                  fontFamily: 'prompt',
                  fontWeight: FontWeight.w600,
                  fontSize: width * 0.075,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: width * 0.04,
                bottom: height * 0.003,
              ),
              child: Row(
                children: [
                  Text(
                    "อีเมล",
                    style: TextStyle(
                      fontFamily: 'prompt',
                      fontSize: width * 0.04,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 0, 0, 0),
                    blurRadius: 0.2,
                    spreadRadius: 0.1,
                    offset: Offset(0, -1),
                  ),
                ],
              ),
              child: TextField(
                controller: emailCth,
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: isTyping ? '' : 'ป้อนอีเมลของคุณ',
                  hintStyle: TextStyle(
                    fontFamily: 'prompt',
                    fontWeight: FontWeight.w400,
                    fontSize: width * 0.04,
                    color: const Color.fromARGB(163, 158, 158, 158),
                  ),
                  constraints: BoxConstraints(
                    maxHeight: height * 0.05,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: width * 0.04,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.015,
            ),
            if (isCheck)
              Padding(
                padding: EdgeInsets.only(
                  left: width * 0.04,
                  bottom: height * 0.003,
                ),
                child: Row(
                  children: [
                    Text(
                      "รหัสผ่านใหม่",
                      style: TextStyle(
                        fontFamily: 'prompt',
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                      ),
                    ),
                  ],
                ),
              ),
            if (isCheck)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 0, 0, 0),
                      blurRadius: 0.2,
                      spreadRadius: 0.1,
                      offset: Offset(0, -1),
                    ),
                  ],
                ),
                child: TextField(
                  controller: passwordNewCth,
                  obscureText: _isCheckedPassword,
                  keyboardType: TextInputType.visiblePassword,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      iconSize: height * 0.03,
                      icon: Icon(
                        _isCheckedPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isCheckedPassword = !_isCheckedPassword;
                        });
                      },
                    ),
                    hintText: isTyping ? '' : 'ป้อนรหัสผ่านใหม่ของคุณ',
                    hintStyle: TextStyle(
                      fontFamily: 'prompt',
                      fontWeight: FontWeight.w400,
                      fontSize: width * 0.04,
                      color: const Color.fromARGB(163, 158, 158, 158),
                    ),
                    constraints: BoxConstraints(
                      maxHeight: height * 0.05,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: width * 0.04,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            if (!isCheck)
              Padding(
                padding: EdgeInsets.only(
                  top: height * 0.02,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: checkEmail,
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(
                          width * 0.7,
                          height * 0.05,
                        ),
                        backgroundColor: const Color(0xffd9d9d9),
                        elevation: 3, //เงาล่าง
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24), // มุมโค้งมน
                        ),
                      ),
                      child: Text(
                        "ต่อไป",
                        style: TextStyle(
                          fontFamily: 'prompt',
                          fontWeight: FontWeight.w400,
                          fontSize: width * 0.042,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (isCheck)
              Padding(
                padding: EdgeInsets.only(
                  top: height * 0.02,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: reSetPassword,
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(
                          width * 0.7,
                          height * 0.05,
                        ),
                        backgroundColor: const Color(0xff0088d1),
                        elevation: 3, //เงาล่าง
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24), // มุมโค้งมน
                        ),
                      ),
                      child: Text(
                        "รีเซ็ตรหัสผ่าน",
                        style: TextStyle(
                          fontFamily: 'prompt',
                          fontWeight: FontWeight.w400,
                          fontSize: width * 0.042,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void checkEmail() async {
    if (emailCth.text.isNotEmpty) {
      var config = await Configuration.getConfig();
      var url = config['apiEndpoint'];
      var response = await http.get(Uri.parse("$url/user"));
      var userList = userGetResponseFromJson(response.body);
      List<UserGetResponseResult> listAllUsers = userList.result;
      var checkEmail =
          listAllUsers.any((value) => value.email == emailCth.text);
      if (checkEmail) {
        setState(() {
          isCheck = checkEmail;
        });
      } else {
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
                    'assets/images/warning.png',
                    width: MediaQuery.of(context).size.width * 0.16,
                    height: MediaQuery.of(context).size.width * 0.16,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.04),
                  Center(
                    child: Text(
                      'อีเมลไม่ถูกต้อง',
                      style: TextStyle(
                        fontFamily: 'prompt',
                        fontWeight: FontWeight.w500,
                        fontSize: MediaQuery.of(context).size.width * 0.055,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'โปรดตรวจสอบว่า\nคุณป้อนข้อมูลที่ถูกต้อง',
                      style: TextStyle(
                        fontFamily: 'prompt',
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                      ),
                      textAlign: TextAlign.center,
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
    }
  }

  void reSetPassword() async {
    if (emailCth.text.isNotEmpty && passwordNewCth.text.isNotEmpty) {
      var config = await Configuration.getConfig();
      var url = config['apiEndpoint'];
      ResetpasswordPutRequest req = ResetpasswordPutRequest(
        email: emailCth.text,
        password: passwordNewCth.text,
      );
      var responseRepass = await http.put(
        Uri.parse('$url/user/resetpass'),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: resetpasswordPutRequestToJson(req),
      );
      if (responseRepass.statusCode == 201) {
        ResetpasswordPutResponse res =
            resetpasswordPutResponseFromJson(responseRepass.body);
        if (res.response) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
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
                          height: MediaQuery.of(context).size.width * 0.04),
                      Center(
                        child: Text(
                          'รีเซ็ตรหัสผ่านสำเร็จ!',
                          style: TextStyle(
                            fontFamily: 'prompt',
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.width * 0.02),
                      ElevatedButton(
                        onPressed: () {
                          Get.to(() => const LoginPage());
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
              );
            },
          );
        }
      }
    }
  }
}
