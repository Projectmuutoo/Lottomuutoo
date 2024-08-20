import 'package:flutter/material.dart';
import 'package:lottotmuutoo/config/config.dart';
import 'package:lottotmuutoo/models/request/UserRegisterPost.dart';
import 'package:lottotmuutoo/models/response/UserRegisterPostResponse.dart';
import 'package:lottotmuutoo/pages/login.dart';
import 'package:http/http.dart' as http;
import 'package:lottotmuutoo/pages/widgets/drawer.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isTyping = false;
  bool _isCheckedPassword = true;
  bool _isCheckedPassword2 = true;

  TextEditingController nameCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();
  TextEditingController passwordCheckCtl = TextEditingController();
  TextEditingController moneyCtl = TextEditingController();

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
          width * 0.25, ////////////////
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: height * 0.02,
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
      drawer: DrawerPage(email: 'ยังไม่ได้เข้าสู่ระบบ'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: width * 0.06,
            right: width * 0.06,
            top: height * 0.01,
          ),
          child: Column(
            children: [
              Text(
                'เป็นสมาชิกลอตโต้',
                style: TextStyle(
                  fontFamily: 'prompt',
                  fontSize: width * 0.075,
                  fontWeight: FontWeight.w600,
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
                      "ชื่อ-สกุล",
                      style: TextStyle(
                        fontFamily: 'prompt',
                        fontSize: width * 0.04,
                      ),
                    ),
                    Text(
                      " *",
                      style: TextStyle(
                        fontFamily: 'prompt',
                        fontSize: width * 0.04,
                        color: Colors.red,
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
                  controller: nameCtl,
                  keyboardType: TextInputType.name,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: _isTyping ? '' : 'ป้อนชื่อ-นามสกุลของคุณ',
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
                height: height * 0.01,
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
                    Text(
                      " *",
                      style: TextStyle(
                        fontFamily: 'prompt',
                        fontSize: width * 0.04,
                        color: Colors.red,
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
                  controller: emailCtl,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: _isTyping ? '' : 'ป้อนอีเมลของคุณ',
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
                height: height * 0.01,
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
                        fontSize: width * 0.04,
                      ),
                    ),
                    Text(
                      " *",
                      style: TextStyle(
                        fontFamily: 'prompt',
                        fontSize: width * 0.04,
                        color: Colors.red,
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
                  controller: passwordCtl,
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
                    hintText: _isTyping ? '' : 'ป้อนรหัสผ่านของคุณ',
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
                height: height * 0.01,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: width * 0.04,
                  bottom: height * 0.003,
                ),
                child: Row(
                  children: [
                    Text(
                      "ยืนยันรหัสผ่าน",
                      style: TextStyle(
                        fontFamily: 'prompt',
                        fontSize: width * 0.04,
                      ),
                    ),
                    Text(
                      " *",
                      style: TextStyle(
                        fontFamily: 'prompt',
                        fontSize: width * 0.04,
                        color: Colors.red,
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
                  controller: passwordCheckCtl,
                  obscureText: _isCheckedPassword2,
                  keyboardType: TextInputType.visiblePassword,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      iconSize: height * 0.03,
                      icon: Icon(
                        _isCheckedPassword2
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isCheckedPassword2 = !_isCheckedPassword2;
                        });
                      },
                    ),
                    hintText: _isTyping ? '' : 'ป้อนยืนยันรหัสผ่านของคุณ',
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
                height: height * 0.01,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: width * 0.04,
                  bottom: height * 0.003,
                ),
                child: Row(
                  children: [
                    Text(
                      "ระบุจำนวนเงิน",
                      style: TextStyle(
                        fontFamily: 'prompt',
                        fontSize: width * 0.04,
                      ),
                    ),
                    Text(
                      " *",
                      style: TextStyle(
                        fontFamily: 'prompt',
                        fontSize: width * 0.04,
                        color: Colors.red,
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
                  controller: moneyCtl,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: _isTyping ? '' : 'ป้อนจำนวนเงินของคุณ (บาท)',
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
                height: height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: register,
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
                      "สมัครสมาชิก",
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
              SizedBox(
                height: height * 0.035,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      right: width * 0.01,
                    ),
                    child: Text(
                      "มีบัญชีอยู่แล้ว?",
                      style: TextStyle(
                        fontFamily: 'prompt',
                        fontWeight: FontWeight.w400,
                        fontSize: width * 0.04,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: login,
                    child: SizedBox(
                      child: Text(
                        "เข้าสู่ระบบ",
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
    );
  }

  void login() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  void register() async {
    if (nameCtl.text.isNotEmpty &&
        emailCtl.text.isNotEmpty &&
        passwordCtl.text.isNotEmpty &&
        passwordCheckCtl.text.isNotEmpty &&
        moneyCtl.text.isNotEmpty) {
      if (emailCtl.text.contains('@') && emailCtl.text.contains('.')) {
        if (passwordCtl.text == passwordCheckCtl.text) {
          UserRegisterPost userRegister = UserRegisterPost(
            name: nameCtl.text,
            email: emailCtl.text,
            password: passwordCtl.text,
            money: int.parse(moneyCtl.text),
          );
          var config = await Configuration.getConfig();
          var url = config['apiEndpoint'];
          http
              .post(
            Uri.parse("$url/user/register"),
            headers: {"Content-Type": "application/json; charset=utf-8"},
            body: userRegisterPostToJson(userRegister),
          )
              .then((value) {
            UserRegisterPostResponse userRegisterRes =
                userRegisterPostResponseFromJson(value.body);
            if (userRegisterRes.response == true) {
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
                          'assets/images/success.png',
                          width: MediaQuery.of(context).size.width * 0.16,
                          height: MediaQuery.of(context).size.width * 0.16,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.width * 0.04),
                        Center(
                          child: Text(
                            'สมัครสมาชิกสำเร็จ!',
                            style: TextStyle(
                              fontFamily: 'prompt',
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.width * 0.02),
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
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.042,
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                        SizedBox(
                            height: MediaQuery.of(context).size.width * 0.04),
                        Center(
                          child: Text(
                            'อีเมลนี้ไม่สามารถใช้งานได้!',
                            style: TextStyle(
                              fontFamily: 'prompt',
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.width * 0.02),
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
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.042,
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
                      SizedBox(
                          height: MediaQuery.of(context).size.width * 0.04),
                      Center(
                        child: Text(
                          'เซิฟเวอร์ไม่พร้อมใช้งาน!!',
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
                        'รหัสผ่านของคุณไม่ตรงกัน!',
                        style: TextStyle(
                          fontFamily: 'prompt',
                          fontSize: MediaQuery.of(context).size.width * 0.048,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'โปรดตรวจสอบรหัสผ่านของท่านอีกครั้ง.',
                        style: TextStyle(
                          fontFamily: 'prompt',
                          fontSize: MediaQuery.of(context).size.width * 0.03,
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
                      'อีเมลของคุณไม่ถูกต้อง!',
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
                    'ไม่สามารถสมัครสมาชิกได้!',
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
}
