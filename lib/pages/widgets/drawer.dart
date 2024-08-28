import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottotmuutoo/pages/login.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottotmuutoo/pages/navpages/navbarpages.dart';

class DrawerPage extends StatefulWidget {
  String email = '';
  int selectedPage = 0;
  DrawerPage({
    super.key,
    required this.email,
    required this.selectedPage,
  });

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  String colorBack = 'f0f0f0';
  String colorText = '1e1e1e';
  String colorIcon = '7f7f7f';
  String checkLogin = 'ออกจากระบบ';

  String checkIconLogin =
      '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M16 13v-2H7V8l-5 4 5 4v-3z"></path><path d="M20 3h-9c-1.103 0-2 .897-2 2v4h2V5h9v14h-9v-4H9v4c0 1.103.897 2 2 2h9c1.103 0 2-.897 2-2V5c0-1.103-.897-2-2-2z"></path></svg>';
  final box = GetStorage();

  @override
  void initState() {
    if (box.read('login') == true) {
      setState(() {
        widget.email = box.read('email');
      });
    }
    if (widget.email == 'ยังไม่ได้เข้าสู่ระบบ') {
      checkLogin = 'เข้าสู่ระบบ';
      checkIconLogin =
          '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="m13 16 5-4-5-4v3H4v2h9z"></path><path d="M20 3h-9c-1.103 0-2 .897-2 2v4h2V5h9v14h-9v-4H9v4c0 1.103.897 2 2 2h9c1.103 0 2-.897 2-2V5c0-1.103-.897-2-2-2z"></path></svg>';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ใช้ width สำหรับ horizontal
    // left/right
    double width = MediaQuery.of(context).size.width;
    // ใช้ height สำหรับ vertical
    // top/bottom
    double height = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: height * 0.05,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.07,
                vertical: height * 0.01,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: width * 0.2,
                    fit: BoxFit.cover,
                    color: const Color(0xFF29B6F6),
                  ),
                  Builder(builder: (BuildContext context) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: SvgPicture.string(
                        '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="m16.192 6.344-4.243 4.242-4.242-4.242-1.414 1.414L10.535 12l-4.242 4.242 1.414 1.414 4.242-4.242 4.243 4.242 1.414-1.414L13.364 12l4.242-4.242z"></path></svg>',
                        width: width * 0.09,
                        height: width * 0.09,
                        fit: BoxFit.cover,
                      ),
                    );
                  }),
                ],
              ),
            ),
            Container(
              width: width,
              decoration: const BoxDecoration(
                color: Color(0xFF7ad2f9),
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 0,
                    blurRadius: 1,
                    offset: Offset(0, 0.6),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: width * 0.07,
                  right: width * 0.05,
                  top: height * 0.015,
                  bottom: height * 0.015,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'อีเมล',
                      style: TextStyle(
                        fontFamily: 'prompt',
                        fontSize: width * 0.042,
                      ),
                    ),
                    Text(
                      widget.email,
                      style: TextStyle(
                        fontFamily: 'prompt',
                        fontSize: width * 0.036,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * 0.006,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NavbarPage(
                      email: widget.email,
                      selectedPage: 0,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(width, height * 0.06),
                backgroundColor: Color(int.parse('0xff$colorBack')),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: width * 0.02,
                  right: width * 0.05,
                  top: height * 0.012,
                  bottom: height * 0.012,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: width * 0.01,
                      ),
                      child: SvgPicture.string(
                        '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M5 22h14a2 2 0 0 0 2-2v-9a1 1 0 0 0-.29-.71l-8-8a1 1 0 0 0-1.41 0l-8 8A1 1 0 0 0 3 11v9a2 2 0 0 0 2 2zm5-2v-5h4v5zm-5-8.59 7-7 7 7V20h-3v-5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v5H5z"></path></svg>',
                        width: width * 0.08,
                        height: width * 0.08,
                        fit: BoxFit.cover,
                        color: Color(int.parse('0xff$colorIcon')),
                      ),
                    ),
                    Text(
                      "หน้าหลัก",
                      style: TextStyle(
                        fontFamily: 'prompt',
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w400,
                        color: Color(int.parse('0xff$colorText')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * 0.006,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NavbarPage(
                      email: widget.email,
                      selectedPage: 1,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(width, height * 0.06),
                backgroundColor: Color(int.parse('0xff$colorBack')),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: width * 0.02,
                  right: width * 0.05,
                  top: height * 0.012,
                  bottom: height * 0.012,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: width * 0.01,
                      ),
                      child: SvgPicture.string(
                        '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M19.903 8.586a.997.997 0 0 0-.196-.293l-6-6a.997.997 0 0 0-.293-.196c-.03-.014-.062-.022-.094-.033a.991.991 0 0 0-.259-.051C13.04 2.011 13.021 2 13 2H6c-1.103 0-2 .897-2 2v16c0 1.103.897 2 2 2h12c1.103 0 2-.897 2-2V9c0-.021-.011-.04-.013-.062a.952.952 0 0 0-.051-.259c-.01-.032-.019-.063-.033-.093zM16.586 8H14V5.414L16.586 8zM6 20V4h6v5a1 1 0 0 0 1 1h5l.002 10H6z"></path><path d="M8 12h8v2H8zm0 4h8v2H8zm0-8h2v2H8z"></path></svg>',
                        width: width * 0.08,
                        height: width * 0.08,
                        fit: BoxFit.cover,
                        color: Color(int.parse('0xff$colorIcon')),
                      ),
                    ),
                    Text(
                      "คำสั่งซื้อ",
                      style: TextStyle(
                        fontFamily: 'prompt',
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w400,
                        color: Color(int.parse('0xff$colorText')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * 0.006,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NavbarPage(
                      email: widget.email,
                      selectedPage: 5,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(width, height * 0.06),
                backgroundColor: Color(int.parse('0xff$colorBack')),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: width * 0.02,
                  right: width * 0.05,
                  top: height * 0.012,
                  bottom: height * 0.012,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: width * 0.01,
                      ),
                      child: SvgPicture.string(
                        '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M12 2A10.13 10.13 0 0 0 2 12a10 10 0 0 0 4 7.92V20h.1a9.7 9.7 0 0 0 11.8 0h.1v-.08A10 10 0 0 0 22 12 10.13 10.13 0 0 0 12 2zM8.07 18.93A3 3 0 0 1 11 16.57h2a3 3 0 0 1 2.93 2.36 7.75 7.75 0 0 1-7.86 0zm9.54-1.29A5 5 0 0 0 13 14.57h-2a5 5 0 0 0-4.61 3.07A8 8 0 0 1 4 12a8.1 8.1 0 0 1 8-8 8.1 8.1 0 0 1 8 8 8 8 0 0 1-2.39 5.64z"></path><path d="M12 6a3.91 3.91 0 0 0-4 4 3.91 3.91 0 0 0 4 4 3.91 3.91 0 0 0 4-4 3.91 3.91 0 0 0-4-4zm0 6a1.91 1.91 0 0 1-2-2 1.91 1.91 0 0 1 2-2 1.91 1.91 0 0 1 2 2 1.91 1.91 0 0 1-2 2z"></path></svg>',
                        width: width * 0.08,
                        height: width * 0.08,
                        fit: BoxFit.cover,
                        color: Color(int.parse('0xff$colorIcon')),
                      ),
                    ),
                    Text(
                      "โปรไฟล์",
                      style: TextStyle(
                        fontFamily: 'prompt',
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w400,
                        color: Color(int.parse('0xff$colorText')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * 0.006,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NavbarPage(
                      email: widget.email,
                      selectedPage: 2,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(width, height * 0.06),
                backgroundColor: Color(int.parse('0xff$colorBack')),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: width * 0.02,
                  right: width * 0.05,
                  top: height * 0.012,
                  bottom: height * 0.012,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: width * 0.01,
                      ),
                      child: SvgPicture.string(
                        '<svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368"><path d="M400-320q100 0 170-70t70-170q0-100-70-170t-170-70q-100 0-170 70t-70 170q0 100 70 170t170 70Zm-42-98 226-227-57-57-169 170-85-84-57 56 142 142Zm42 178q-134 0-227-93T80-560q0-134 93-227t227-93q134 0 227 93t93 227q0 56-17.5 105.5T653-364l227 228-56 56-228-227q-41 32-90.5 49.5T400-240Zm0-320Z"/></svg>',
                        width: width * 0.08,
                        height: width * 0.08,
                        fit: BoxFit.cover,
                        color: Color(int.parse('0xff$colorIcon')),
                      ),
                    ),
                    Text(
                      "ตรวจลอตโต้",
                      style: TextStyle(
                        fontFamily: 'prompt',
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w400,
                        color: Color(int.parse('0xff$colorText')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * 0.006,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NavbarPage(
                      email: widget.email,
                      selectedPage: 3,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(width, height * 0.06),
                backgroundColor: Color(int.parse('0xff$colorBack')),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: width * 0.02,
                  right: width * 0.05,
                  top: height * 0.012,
                  bottom: height * 0.012,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: width * 0.01,
                      ),
                      child: SvgPicture.string(
                        '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M16 12h2v4h-2z"></path><path d="M20 7V5c0-1.103-.897-2-2-2H5C3.346 3 2 4.346 2 6v12c0 2.201 1.794 3 3 3h15c1.103 0 2-.897 2-2V9c0-1.103-.897-2-2-2zM5 5h13v2H5a1.001 1.001 0 0 1 0-2zm15 14H5.012C4.55 18.988 4 18.805 4 18V8.815c.314.113.647.185 1 .185h15v10z"></path></svg>',
                        width: width * 0.08,
                        height: width * 0.08,
                        fit: BoxFit.cover,
                        color: Color(int.parse('0xff$colorIcon')),
                      ),
                    ),
                    Text(
                      "เป๋าตัง",
                      style: TextStyle(
                        fontFamily: 'prompt',
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w400,
                        color: Color(int.parse('0xff$colorText')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * 0.006,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NavbarPage(
                      email: widget.email,
                      selectedPage: 4,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(width, height * 0.06),
                backgroundColor: Color(int.parse('0xff$colorBack')),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: width * 0.02,
                  right: width * 0.05,
                  top: height * 0.012,
                  bottom: height * 0.012,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: width * 0.01,
                      ),
                      child: SvgPicture.string(
                        '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M21.822 7.431A1 1 0 0 0 21 7H7.333L6.179 4.23A1.994 1.994 0 0 0 4.333 3H2v2h2.333l4.744 11.385A1 1 0 0 0 10 17h8c.417 0 .79-.259.937-.648l3-8a1 1 0 0 0-.115-.921zM17.307 15h-6.64l-2.5-6h11.39l-2.25 6z"></path><circle cx="10.5" cy="19.5" r="1.5"></circle><circle cx="17.5" cy="19.5" r="1.5"></circle></svg>',
                        width: width * 0.08,
                        height: width * 0.08,
                        fit: BoxFit.cover,
                        color: Color(int.parse('0xff$colorIcon')),
                      ),
                    ),
                    Text(
                      "ตะกร้า",
                      style: TextStyle(
                        fontFamily: 'prompt',
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w400,
                        color: Color(int.parse('0xff$colorText')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * 0.006,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NavbarPage(
                      email: widget.email,
                      selectedPage: 6,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(width, height * 0.06),
                backgroundColor: Color(int.parse('0xff$colorBack')),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: width * 0.02,
                  right: width * 0.05,
                  top: height * 0.012,
                  bottom: height * 0.012,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: width * 0.01,
                      ),
                      child: SvgPicture.string(
                        '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M21 4H3a1 1 0 0 0-1 1v14a1 1 0 0 0 1 1h18a1 1 0 0 0 1-1V5a1 1 0 0 0-1-1zm-1 11a3 3 0 0 0-3 3H7a3 3 0 0 0-3-3V9a3 3 0 0 0 3-3h10a3 3 0 0 0 3 3v6z"></path><path d="M12 8c-2.206 0-4 1.794-4 4s1.794 4 4 4 4-1.794 4-4-1.794-4-4-4zm0 6c-1.103 0-2-.897-2-2s.897-2 2-2 2 .897 2 2-.897 2-2 2z"></path></svg>',
                        width: width * 0.08,
                        height: width * 0.08,
                        fit: BoxFit.cover,
                        color: Color(int.parse('0xff$colorIcon')),
                      ),
                    ),
                    Text(
                      "ประกาศรางวัล",
                      style: TextStyle(
                        fontFamily: 'prompt',
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w400,
                        color: Color(int.parse('0xff$colorText')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * 0.006,
            ),
            ElevatedButton(
              onPressed: logout,
              style: ElevatedButton.styleFrom(
                fixedSize: Size(width, height * 0.06),
                backgroundColor: Color(int.parse('0xff$colorBack')),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: width * 0.02,
                  right: width * 0.05,
                  top: height * 0.012,
                  bottom: height * 0.012,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: width * 0.01,
                      ),
                      child: SvgPicture.string(
                        checkIconLogin,
                        width: width * 0.08,
                        height: width * 0.08,
                        fit: BoxFit.cover,
                        color: Color(int.parse('0xff$colorIcon')),
                      ),
                    ),
                    Text(
                      checkLogin,
                      style: TextStyle(
                        fontFamily: 'prompt',
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w400,
                        color: Color(int.parse('0xff$colorText')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> logout() async {
    await GoogleSignIn().signOut();
    if (widget.email == 'ยังไม่ได้เข้าสู่ระบบ') {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
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
                    'คุณแน่ใจใช่หรือไม่ที่จะออกจากระบบ?',
                    style: TextStyle(
                      fontFamily: 'prompt',
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        widget.email = 'ยังไม่ได้เข้าสู่ระบบ';
                        box.write('login', false);
                        if (mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        }
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
  }
}
