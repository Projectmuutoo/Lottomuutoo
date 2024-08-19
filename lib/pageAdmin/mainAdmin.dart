import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottotmuutoo/pages/login.dart';

class MainadminPage extends StatefulWidget {
  String email = '';
  MainadminPage({super.key, required this.email});

  @override
  State<MainadminPage> createState() => _MainadminPageState();
}

class _MainadminPageState extends State<MainadminPage> {
  final box = GetStorage();
  @override
  void initState() {
    super.initState();
    _initializeStorage();
  }

  void _initializeStorage() {
    var loginStatus = box.read('login');
    var storedEmail = box.read('email');

    if (loginStatus != false) {
      setState(() {
        widget.email = storedEmail;
      });
    } else {
      setState(() {
        widget.email = 'ยังไม่ได้เข้าสู่ระบบ';
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
      appBar: PreferredSize(
        preferredSize: Size(
          width,
          width * 0.25, //////////////
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainadminPage(
                              email: widget.email,
                            ),
                          ),
                        );
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
                            widget.email = 'ยังไม่ได้เข้าสู่ระบบ';
                            box.write('login', false);
                            box.write('email', null);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          child: SvgPicture.string(
                            '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M16 13v-2H7V8l-5 4 5 4v-3z"></path><path d="M20 3h-9c-1.103 0-2 .897-2 2v4h2V5h9v14h-9v-4H9v4c0 1.103.897 2 2 2h9c1.103 0 2-.897 2-2V5c0-1.103-.897-2-2-2z"></path></svg>',
                            width: width * 0.08,
                            height: width * 0.08,
                            fit: BoxFit.cover,
                            color: const Color.fromARGB(255, 255, 255, 255),
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
      body: Container(),
    );
  }
}
