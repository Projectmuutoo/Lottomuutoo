import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottotmuutoo/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:lottotmuutoo/models/request/UserLoginPost.dart';
import 'package:lottotmuutoo/models/request/UserGoogleLoginPost.dart';
import 'package:lottotmuutoo/models/response/UserGetResponse.dart';
import 'package:lottotmuutoo/models/response/UserIdxGetResponse.dart';
import 'package:lottotmuutoo/models/response/UserRegisterPostResponse.dart';
import 'package:lottotmuutoo/pageAdmin/mainnavbarAdmin.dart';
import 'package:lottotmuutoo/pages/navpages/navbarpages.dart';
import 'package:lottotmuutoo/pages/register.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottotmuutoo/pages/repassword.dart';
import 'package:lottotmuutoo/pages/widgets/drawer.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isTyping = false;
  bool _isChecked = false;
  bool _isCheckedPassword = true;
  TextEditingController emailCth = TextEditingController();
  TextEditingController passwordCth = TextEditingController();
  final supabase = Supabase.instance.client;
  bool isLoading = false;

  //เรียกใช้ GetStorage เก็บใน box
  final box = GetStorage();
  @override
  void initState() {
    super.initState();
    _initializeStorage();
    // Firebase.initializeApp();
  }

  void _initializeStorage() async {
    //โหลดข้อมูลที่เราติ๊ก rememberme ไว้
    loadRememberedUser();
  }

  @override
  Widget build(BuildContext context) {
    // ใช้ width สำหรับ horizontal
    // left/right
    double width = MediaQuery.of(context).size.width;
    // ใช้ height สำหรับ vertical
    // top/bottom
    double height = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: false,
      child: Scaffold(
        //PreferredSize กำหนดขนาด AppBar กำหนดเป็น 25% ของ width ของหน้าจอ * 0.25
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
                ),
              ),
            ),
          ),
        ),
        drawer: DrawerPage(
          email: 'ยังไม่ได้เข้าสู่ระบบ',
          selectedPage: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
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
                    "เข้าสู่ระบบลอตโต้",
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
                Padding(
                  padding: EdgeInsets.only(
                    left: width * 0.04,
                    bottom: height * 0.003,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "รหัสผ่าน",
                        style: TextStyle(
                          fontFamily: 'prompt',
                          fontSize: MediaQuery.of(context).size.width * 0.04,
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
                    controller: passwordCth,
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
                      hintText: isTyping ? '' : 'ป้อนรหัสผ่านของคุณ',
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
                Padding(
                  padding: EdgeInsets.only(
                    top: height * 0.01,
                    right: width * 0.03,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(() => const RepasswordPage());
                        },
                        child: SizedBox(
                          child: Text(
                            "ลืมรหัสผ่าน?",
                            style: TextStyle(
                              fontFamily: 'prompt',
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.034,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: width * 0.04,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: Checkbox(
                          activeColor: const Color(0xFF29B6F6),
                          value: _isChecked,
                          onChanged: (bool? value) {
                            rememberme(value);
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: width * 0.02,
                        ),
                        child: InkWell(
                          onTap: () {
                            rememberme(!_isChecked);
                          },
                          child: SizedBox(
                            child: Text(
                              'จดจำฉัน',
                              style: TextStyle(
                                fontFamily: 'prompt',
                                fontSize: width * 0.035,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: height * 0.02,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: login,
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(
                            width * 0.7,
                            height * 0.05,
                          ),
                          backgroundColor: const Color(0xffd9d9d9),
                          elevation: 3, //เงาล่าง
                          shadowColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(24), // มุมโค้งมน
                          ),
                        ),
                        child: Text(
                          "เข้าสู่ระบบ",
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
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: height * 0.035,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '- หรือ -',
                        style: TextStyle(
                          fontFamily: 'prompt',
                          fontWeight: FontWeight.w400,
                          fontSize: width * 0.042,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: loginWithGoogle,
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(
                          width * 0.7,
                          height * 0.05,
                        ),
                        backgroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        elevation: 3, //เงาล่าง
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24), // มุมโค้งมน
                        ),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/googlelogo.png',
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: width * 0.02,
                            ),
                            child: Text(
                              "เข้าสู่ระบบโดย Google",
                              style: TextStyle(
                                fontFamily: 'prompt',
                                fontWeight: FontWeight.w400,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.042,
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: width * 0.01,
                      ),
                      child: Text(
                        "หากคุณไม่มีบัญชี?",
                        style: TextStyle(
                          fontFamily: 'prompt',
                          fontWeight: FontWeight.w400,
                          fontSize: width * 0.04,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: register,
                      child: SizedBox(
                        child: Text(
                          "สมัครสมาชิก",
                          style: TextStyle(
                            fontFamily: 'prompt',
                            fontWeight: FontWeight.w400,
                            fontSize: width * 0.04,
                            color: const Color(0xff4696C1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void rememberme(bool? value) async {
    //ถ้าหากติ๊ก rememberme value = true
    if (value == true) {
      var config = await Configuration.getConfig();
      var url = config['apiEndpoint'];
      var response = await http.get(Uri.parse("$url/user"));

      var userList = userGetResponseFromJson(response.body);
      List<UserGetResponseResult> listAllUsers = userList.result;
      //ลูปเอา email ใน database
      for (var user in listAllUsers) {
        //เช็ค email database กับ emailCth.text
        if (user.email == emailCth.text) {
          //เขียน emailCth.text,passwordCth.text ลง GetStorage
          box.write('login', true);
          box.write('email', emailCth.text);
          box.write('password', passwordCth.text);
          box.write('rememberMe', true);
          break;
        }
      }
      //ถ้าหากติ๊ก rememberme value = false
    } else {
      //ลบ email, password บันทึก rememberMe เป็น false
      box.write('email', 'ยังไม่ได้เข้าสู่ระบบ');
      box.write('password', '');
      box.write('rememberMe', false);
    }

    setState(() {
      _isChecked = value ?? !_isChecked;
    });
  }

  //โหลด
  void loadRememberedUser() {
    String? email = box.read('email');
    String? password = box.read('password');
    bool? rememberMe = box.read('rememberMe');
    //ถ้าหาก rememberMe เป็น true และ email,password ใน GetStorage ไม่ว่าง
    //ขยายความกดติ๊ก rememberMe และมี email,password อยู่ใน GetStorage นั้นแหละ
    if (rememberMe == true && email != null && password != null) {
      //เอา email และ password มาแสดง
      emailCth.text = email;
      passwordCth.text = password;
      setState(() {
        _isChecked = true;
      });
    }
  }

  void login() async {
    if (emailCth.text.isNotEmpty && passwordCth.text.isNotEmpty) {
      UserLoginPost userLoginReq = UserLoginPost(
        email: emailCth.text,
        password: passwordCth.text,
      );
      var config = await Configuration.getConfig();
      var url = config['apiEndpoint'];
      http
          .post(
        Uri.parse("$url/user/login"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: userLoginPostToJson(userLoginReq),
      )
          .then((value) {
        UserRegisterPostResponse userLoginRes =
            userRegisterPostResponseFromJson(value.body);

        if (box.read('rememberMe') == true) {
          box.write('login', true);
          box.write('email', emailCth.text);
          box.write('password', passwordCth.text);
        } else {
          box.write('login', true);
          box.write('email', emailCth.text);
          box.write('password', passwordCth.text);
        }

        if (userLoginRes.response == true) {
          showDialog(
            context: context,
            builder: (context) {
              Future.delayed(const Duration(milliseconds: 500), () async {
                var response = await http.get(Uri.parse("$url/user"));
                var userList = userGetResponseFromJson(response.body);
                List<UserGetResponseResult> listAllUsers = userList.result;
                //ลูปเอา email ใน database
                for (var user in listAllUsers) {
                  //เช็ค email database กับ emailCth.text
                  if (user.email == emailCth.text) {
                    Navigator.of(context).pop();
                    if (user.uid == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => mainnavbaradminPage(
                                  email: user.email,
                                  selectedPage: 0,
                                  resultRandAll: [],
                                  resultFromSelling: [],
                                  acceptNumberJackAll: false,
                                  acceptNumberFromSelling: false,
                                )),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NavbarPage(
                                  email: emailCth.text,
                                  selectedPage: 0,
                                )),
                      );
                    }
                  }
                }
              });
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
                          'เข้าสู่ระบบสำเร็จ!',
                          style: TextStyle(
                            fontFamily: 'prompt',
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'กรุณารอสักครู่...',
                          style: TextStyle(
                            fontFamily: 'prompt',
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
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
                        'อีเมลหรือรหัสผ่าน\nของคุณไม่ถูกต้อง!',
                        style: TextStyle(
                          fontFamily: 'prompt',
                          fontSize: MediaQuery.of(context).size.width * 0.04,
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
      }).catchError((err) {
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
                    'ไม่สามารถเข้าสู่ระบบได้!',
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
  }

  void register() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterPage(),
      ),
    );
  }

  Future loginWithGoogle() async {
    // await GoogleSignIn().signOut();
    /// Web Client ID that you registered with Google Cloud.
    const webClientId =
        '196868691997-u1vsnmcspr23nk13b6ivbf49te07q0kg.apps.googleusercontent.com';

    /// TODO: update the iOS client ID with your own.
    ///
    /// iOS Client ID that you registered with Google Cloud.
    const iosClientId = 'my-ios.apps.googleusercontent.com';

    // Google sign in on Android will work without providing the Android
    // Client ID registered on Google Cloud.

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    final gUser = await googleSignIn.signIn();
    final googleAuth = await gUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    // log(gUser.email);
    LoginGoogleReq userLoginReq = LoginGoogleReq(
      email: gUser.email,
      money: 0,
    );
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];
    http
        .post(Uri.parse('$url/user/login/google'),
            headers: {"Content-Type": "application/json; charset=utf-8"},
            body: loginGoogleReqToJson(userLoginReq))
        .then((value) async {
      UserRegisterPostResponse loginRes =
          userRegisterPostResponseFromJson(value.body);

      // log(loginRes.message);
      if (loginRes.message == 'Login Complete') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => NavbarPage(
                    email: gUser.email,
                    selectedPage: 0,
                  )),
        );
      } else {
        box.write('login', true);
        box.write('email', gUser.email);
      }
    });

    return await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }
}
