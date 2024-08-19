import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottotmuutoo/pages/home.dart';

class DrawerPage extends StatefulWidget {
  String email = '';
  DrawerPage({super.key, required this.email});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
                  GestureDetector(
                    onTap: () {},
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: width * 0.2,
                      fit: BoxFit.cover,
                      color: const Color(0xFF29B6F6),
                    ),
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
                  Radius.circular(12),
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
                  top: height * 0.012,
                  bottom: height * 0.012,
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
                    builder: (context) => HomePage(email: widget.email),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(width, height * 0.06),
                backgroundColor: const Color(0xFFf0f0f0),
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
                        color: const Color(0xff7f7f7f),
                      ),
                    ),
                    Text(
                      "หน้าหลัก",
                      style: TextStyle(
                        fontFamily: 'prompt',
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
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
}
