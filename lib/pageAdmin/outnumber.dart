import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottotmuutoo/config/config.dart';
import 'package:lottotmuutoo/models/response/jackpotwinGetResponse.dart';
import 'package:lottotmuutoo/pages/login.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class OutnumberPage extends StatefulWidget {
  String email = '';
  List resultRandAll = [];
  List resultFromSelling = [];
  bool acceptNumberJackAll;
  bool acceptNumberFromSelling;

  OutnumberPage({
    super.key,
    required this.email,
    required this.resultRandAll,
    required this.resultFromSelling,
    required this.acceptNumberJackAll,
    required this.acceptNumberFromSelling,
  });

  @override
  State<OutnumberPage> createState() => _OutnumberPageState();
}

class _OutnumberPageState extends State<OutnumberPage> {
  late Future<void> loadData;
  String text = '';
  final box = GetStorage();
  List jackpotwin = [];
  List jackpotwinsell = [];

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];
    var response = await http.get(Uri.parse('$url/lotto/jackpotwin'));
    var results = jackpotwinGetResponseFromJson(response.body);
    var responsesell = await http.get(Uri.parse('$url/lotto/jackpotsell'));
    var resultssell = jackpotwinGetResponseFromJson(responsesell.body);

    setState(() {
      for (var n in results.result) {
        jackpotwin.add(n.number);
      }
      for (var n in resultssell.result) {
        jackpotwinsell.add(n.number);
      }

      if (widget.resultRandAll.isNotEmpty && widget.acceptNumberJackAll) {
        text = 'ยืนยันเลขที่ออก';
      } else if (widget.resultFromSelling.isNotEmpty &&
          widget.acceptNumberFromSelling) {
        text = 'ยืนยันเลขที่ออก';
      } else {
        if (jackpotwin.isNotEmpty) {
          if (jackpotwin.length < 5) {
            text = 'เลขที่ออก';
          } else {
            if (widget.acceptNumberFromSelling && jackpotwinsell.isEmpty) {
              text = 'ยังไม่มีเลขที่ถูกขาย';
            } else {
              text = 'เลขที่ออก';
            }
          }
        } else {
          if (widget.acceptNumberFromSelling && jackpotwinsell.isEmpty) {
            text = 'ยังไม่มีเลขที่ถูกขาย';
          } else {
            text = 'ยังไม่มีเลขที่ประกาศ';
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(
          width,
          width * 0.40,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: height * 0.01,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF29B6F6),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(42),
                bottomRight: Radius.circular(42),
              ),
              boxShadow: [
                BoxShadow(
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: AppBar(
              automaticallyImplyLeading: false,
              shadowColor: Colors.transparent,
              backgroundColor: Colors.transparent,
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
                                widget.email = 'ยังไม่ได้เข้าสู่ระบบ';
                                box.write('login', false);
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          text,
                          style: TextStyle(
                            fontFamily: 'prompt',
                            fontSize: width * 0.1,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            if (widget.resultRandAll.isNotEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03,
                  vertical: height * 0.01,
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffe6e6e6),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            spreadRadius: 0,
                            blurRadius: 2,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      width: width * 0.95,
                      height: height * 0.48,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: height * 0.02,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'ผลฉลากกินแบ่งลอตโต้',
                                  style: TextStyle(
                                    fontFamily: 'prompt',
                                    fontSize: width * 0.07,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  formatCurrentDate(),
                                  style: TextStyle(
                                    fontFamily: 'prompt',
                                    fontSize: width * 0.05,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff9e0000),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xffb3e5fc),
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: const [
                                      BoxShadow(
                                        spreadRadius: 0,
                                        blurRadius: 2,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  width: width * 0.4,
                                  child: Center(
                                    child: Text(
                                      widget.resultRandAll[0],
                                      style: TextStyle(
                                        fontFamily: 'prompt',
                                        fontSize: width * 0.07,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff9e0000),
                                        letterSpacing: width * 0.016,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.008),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'รางวัลที่ 1',
                                  style: TextStyle(
                                    fontFamily: 'prompt',
                                    fontSize: width * 0.045,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xffb3e5fc),
                                        borderRadius: BorderRadius.circular(18),
                                        boxShadow: const [
                                          BoxShadow(
                                            spreadRadius: 0,
                                            blurRadius: 2,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      width: width * 0.4,
                                      child: Center(
                                        child: Text(
                                          widget.resultRandAll[1],
                                          style: TextStyle(
                                            fontFamily: 'prompt',
                                            fontSize: width * 0.065,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            letterSpacing: width * 0.016,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: height * 0.008),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'รางวัลที่ 2',
                                          style: TextStyle(
                                            fontFamily: 'prompt',
                                            fontSize: width * 0.045,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xffb3e5fc),
                                        borderRadius: BorderRadius.circular(18),
                                        boxShadow: const [
                                          BoxShadow(
                                            spreadRadius: 0,
                                            blurRadius: 2,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      width: width * 0.4,
                                      child: Center(
                                        child: Text(
                                          widget.resultRandAll[2],
                                          style: TextStyle(
                                            fontFamily: 'prompt',
                                            fontSize: width * 0.065,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            letterSpacing: width * 0.016,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: height * 0.008),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'รางวัลที่ 3',
                                          style: TextStyle(
                                            fontFamily: 'prompt',
                                            fontSize: width * 0.045,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xffb3e5fc),
                                        borderRadius: BorderRadius.circular(18),
                                        boxShadow: const [
                                          BoxShadow(
                                            spreadRadius: 0,
                                            blurRadius: 2,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      width: width * 0.4,
                                      child: Center(
                                        child: Text(
                                          widget.resultRandAll[3],
                                          style: TextStyle(
                                            fontFamily: 'prompt',
                                            fontSize: width * 0.065,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            letterSpacing: width * 0.016,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: height * 0.008),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'รางวัลที่ 4',
                                          style: TextStyle(
                                            fontFamily: 'prompt',
                                            fontSize: width * 0.045,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xffb3e5fc),
                                        borderRadius: BorderRadius.circular(18),
                                        boxShadow: const [
                                          BoxShadow(
                                            spreadRadius: 0,
                                            blurRadius: 2,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      width: width * 0.4,
                                      child: Center(
                                        child: Text(
                                          widget.resultRandAll[4],
                                          style: TextStyle(
                                            fontFamily: 'prompt',
                                            fontSize: width * 0.065,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            letterSpacing: width * 0.016,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: height * 0.008),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'รางวัลที่ 5',
                                          style: TextStyle(
                                            fontFamily: 'prompt',
                                            fontSize: width * 0.045,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    if (widget.acceptNumberJackAll)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              confirmNumRand();
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(
                                width * 0.4,
                                height * 0.06,
                              ),
                              backgroundColor: const Color(0xff0288d1),
                              elevation: 3, //เงาล่าง
                              shadowColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: Text(
                              "ยืนยันเลขที่ออก",
                              style: TextStyle(
                                fontFamily: 'prompt',
                                fontWeight: FontWeight.w500,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            } else if (widget.resultFromSelling.isNotEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03,
                  vertical: height * 0.01,
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffe6e6e6),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            spreadRadius: 0,
                            blurRadius: 2,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      width: width * 0.95,
                      height: height * 0.48,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: height * 0.02,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'ผลฉลากกินแบ่งลอตโต้',
                                  style: TextStyle(
                                    fontFamily: 'prompt',
                                    fontSize: width * 0.07,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  formatCurrentDate(),
                                  style: TextStyle(
                                    fontFamily: 'prompt',
                                    fontSize: width * 0.05,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff9e0000),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xffb3e5fc),
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: const [
                                      BoxShadow(
                                        spreadRadius: 0,
                                        blurRadius: 2,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  width: width * 0.4,
                                  child: Center(
                                    child: Text(
                                      getJackpotNumber(0),
                                      style: TextStyle(
                                        fontFamily: 'prompt',
                                        fontSize: width * 0.07,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff9e0000),
                                        letterSpacing: width * 0.016,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.008),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'รางวัลที่ 1',
                                  style: TextStyle(
                                    fontFamily: 'prompt',
                                    fontSize: width * 0.045,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xffb3e5fc),
                                        borderRadius: BorderRadius.circular(18),
                                        boxShadow: const [
                                          BoxShadow(
                                            spreadRadius: 0,
                                            blurRadius: 2,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      width: width * 0.4,
                                      child: Center(
                                        child: Text(
                                          getJackpotNumber(1),
                                          style: TextStyle(
                                            fontFamily: 'prompt',
                                            fontSize: width * 0.065,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            letterSpacing: width * 0.016,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: height * 0.008),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'รางวัลที่ 2',
                                          style: TextStyle(
                                            fontFamily: 'prompt',
                                            fontSize: width * 0.045,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xffb3e5fc),
                                        borderRadius: BorderRadius.circular(18),
                                        boxShadow: const [
                                          BoxShadow(
                                            spreadRadius: 0,
                                            blurRadius: 2,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      width: width * 0.4,
                                      child: Center(
                                        child: Text(
                                          getJackpotNumber(2),
                                          style: TextStyle(
                                            fontFamily: 'prompt',
                                            fontSize: width * 0.065,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            letterSpacing: width * 0.016,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: height * 0.008),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'รางวัลที่ 3',
                                          style: TextStyle(
                                            fontFamily: 'prompt',
                                            fontSize: width * 0.045,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xffb3e5fc),
                                        borderRadius: BorderRadius.circular(18),
                                        boxShadow: const [
                                          BoxShadow(
                                            spreadRadius: 0,
                                            blurRadius: 2,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      width: width * 0.4,
                                      child: Center(
                                        child: Text(
                                          getJackpotNumber(3),
                                          style: TextStyle(
                                            fontFamily: 'prompt',
                                            fontSize: width * 0.065,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            letterSpacing: width * 0.016,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: height * 0.008),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'รางวัลที่ 4',
                                          style: TextStyle(
                                            fontFamily: 'prompt',
                                            fontSize: width * 0.045,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xffb3e5fc),
                                        borderRadius: BorderRadius.circular(18),
                                        boxShadow: const [
                                          BoxShadow(
                                            spreadRadius: 0,
                                            blurRadius: 2,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      width: width * 0.4,
                                      child: Center(
                                        child: Text(
                                          getJackpotNumber(4),
                                          style: TextStyle(
                                            fontFamily: 'prompt',
                                            fontSize: width * 0.065,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            letterSpacing: width * 0.016,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: height * 0.008),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'รางวัลที่ 5',
                                          style: TextStyle(
                                            fontFamily: 'prompt',
                                            fontSize: width * 0.045,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    if (widget.acceptNumberFromSelling)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              confirmNumRand();
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(
                                width * 0.4,
                                height * 0.06,
                              ),
                              backgroundColor: const Color(0xff0288d1),
                              elevation: 3, //เงาล่าง
                              shadowColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: Text(
                              "ยืนยันเลขที่ออก",
                              style: TextStyle(
                                fontFamily: 'prompt',
                                fontWeight: FontWeight.w500,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            } else {
              if (jackpotwin.isNotEmpty) {
                if (jackpotwin.length < 5) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.03,
                      vertical: height * 0.01,
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffe6e6e6),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: const [
                              BoxShadow(
                                spreadRadius: 0,
                                blurRadius: 2,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          width: width * 0.95,
                          height: height * 0.48,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: height * 0.02,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'ผลฉลากกินแบ่งลอตโต้',
                                      style: TextStyle(
                                        fontFamily: 'prompt',
                                        fontSize: width * 0.07,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      formatCurrentDate(),
                                      style: TextStyle(
                                        fontFamily: 'prompt',
                                        fontSize: width * 0.05,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff9e0000),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: height * 0.02),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xffb3e5fc),
                                        borderRadius: BorderRadius.circular(18),
                                        boxShadow: const [
                                          BoxShadow(
                                            spreadRadius: 0,
                                            blurRadius: 2,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      width: width * 0.4,
                                      child: Center(
                                        child: Text(
                                          getJackpotSellNumber(0),
                                          style: TextStyle(
                                            fontFamily: 'prompt',
                                            fontSize: width * 0.065,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xff9e0000),
                                            letterSpacing: width * 0.016,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: height * 0.008),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'รางวัลที่ 1',
                                      style: TextStyle(
                                        fontFamily: 'prompt',
                                        fontSize: width * 0.045,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: height * 0.02),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xffb3e5fc),
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            boxShadow: const [
                                              BoxShadow(
                                                spreadRadius: 0,
                                                blurRadius: 2,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          width: width * 0.4,
                                          child: Center(
                                            child: Text(
                                              getJackpotSellNumber(1),
                                              style: TextStyle(
                                                fontFamily: 'prompt',
                                                fontSize: width * 0.065,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                                letterSpacing: width * 0.016,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: height * 0.008),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'รางวัลที่ 2',
                                              style: TextStyle(
                                                fontFamily: 'prompt',
                                                fontSize: width * 0.045,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xffb3e5fc),
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            boxShadow: const [
                                              BoxShadow(
                                                spreadRadius: 0,
                                                blurRadius: 2,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          width: width * 0.4,
                                          child: Center(
                                            child: Text(
                                              getJackpotSellNumber(2),
                                              style: TextStyle(
                                                fontFamily: 'prompt',
                                                fontSize: width * 0.065,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                                letterSpacing: width * 0.016,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: height * 0.008),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'รางวัลที่ 3',
                                              style: TextStyle(
                                                fontFamily: 'prompt',
                                                fontSize: width * 0.045,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: height * 0.02),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xffb3e5fc),
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            boxShadow: const [
                                              BoxShadow(
                                                spreadRadius: 0,
                                                blurRadius: 2,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          width: width * 0.4,
                                          child: Center(
                                            child: Text(
                                              getJackpotSellNumber(3),
                                              style: TextStyle(
                                                fontFamily: 'prompt',
                                                fontSize: width * 0.065,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                                letterSpacing: width * 0.016,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: height * 0.008),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'รางวัลที่ 4',
                                              style: TextStyle(
                                                fontFamily: 'prompt',
                                                fontSize: width * 0.045,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xffb3e5fc),
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            boxShadow: const [
                                              BoxShadow(
                                                spreadRadius: 0,
                                                blurRadius: 2,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          width: width * 0.4,
                                          child: Center(
                                            child: Text(
                                              getJackpotSellNumber(4),
                                              style: TextStyle(
                                                fontFamily: 'prompt',
                                                fontSize: width * 0.065,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                                letterSpacing: width * 0.016,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: height * 0.008),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'รางวัลที่ 5',
                                              style: TextStyle(
                                                fontFamily: 'prompt',
                                                fontSize: width * 0.045,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                      ],
                    ),
                  );
                } else {
                  if (widget.acceptNumberFromSelling &&
                      jackpotwinsell.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.03,
                        vertical: height * 0.01,
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xffe6e6e6),
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: const [
                                BoxShadow(
                                  spreadRadius: 0,
                                  blurRadius: 2,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            width: width * 0.95,
                            height: height * 0.48,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: height * 0.02,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'ผลฉลากกินแบ่งลอตโต้',
                                        style: TextStyle(
                                          fontFamily: 'prompt',
                                          fontSize: width * 0.07,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        formatCurrentDate(),
                                        style: TextStyle(
                                          fontFamily: 'prompt',
                                          fontSize: width * 0.05,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff9e0000),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height * 0.02),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xffb3e5fc),
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          boxShadow: const [
                                            BoxShadow(
                                              spreadRadius: 0,
                                              blurRadius: 2,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        width: width * 0.4,
                                        child: Center(
                                          child: Text(
                                            'XXXXXX',
                                            style: TextStyle(
                                              fontFamily: 'prompt',
                                              fontSize: width * 0.07,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xff9e0000),
                                              letterSpacing: width * 0.012,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height * 0.008),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'รางวัลที่ 1',
                                        style: TextStyle(
                                          fontFamily: 'prompt',
                                          fontSize: width * 0.045,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height * 0.02),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xffb3e5fc),
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              boxShadow: const [
                                                BoxShadow(
                                                  spreadRadius: 0,
                                                  blurRadius: 2,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            width: width * 0.4,
                                            child: Center(
                                              child: Text(
                                                'XXXXXX',
                                                style: TextStyle(
                                                  fontFamily: 'prompt',
                                                  fontSize: width * 0.065,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  letterSpacing: width * 0.012,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: height * 0.008),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'รางวัลที่ 2',
                                                style: TextStyle(
                                                  fontFamily: 'prompt',
                                                  fontSize: width * 0.045,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xffb3e5fc),
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              boxShadow: const [
                                                BoxShadow(
                                                  spreadRadius: 0,
                                                  blurRadius: 2,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            width: width * 0.4,
                                            child: Center(
                                              child: Text(
                                                'XXXXXX',
                                                style: TextStyle(
                                                  fontFamily: 'prompt',
                                                  fontSize: width * 0.065,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  letterSpacing: width * 0.012,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: height * 0.008),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'รางวัลที่ 3',
                                                style: TextStyle(
                                                  fontFamily: 'prompt',
                                                  fontSize: width * 0.045,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height * 0.02),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xffb3e5fc),
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              boxShadow: const [
                                                BoxShadow(
                                                  spreadRadius: 0,
                                                  blurRadius: 2,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            width: width * 0.4,
                                            child: Center(
                                              child: Text(
                                                'XXXXXX',
                                                style: TextStyle(
                                                  fontFamily: 'prompt',
                                                  fontSize: width * 0.065,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  letterSpacing: width * 0.012,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: height * 0.008),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'รางวัลที่ 4',
                                                style: TextStyle(
                                                  fontFamily: 'prompt',
                                                  fontSize: width * 0.045,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xffb3e5fc),
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              boxShadow: const [
                                                BoxShadow(
                                                  spreadRadius: 0,
                                                  blurRadius: 2,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            width: width * 0.4,
                                            child: Center(
                                              child: Text(
                                                'XXXXXX',
                                                style: TextStyle(
                                                  fontFamily: 'prompt',
                                                  fontSize: width * 0.065,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  letterSpacing: width * 0.012,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: height * 0.008),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'รางวัลที่ 5',
                                                style: TextStyle(
                                                  fontFamily: 'prompt',
                                                  fontSize: width * 0.045,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "ออกรางวัลยังไม่ได้.",
                                style: TextStyle(
                                  fontFamily: 'prompt',
                                  fontWeight: FontWeight.w500,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05,
                                  color: const Color.fromARGB(255, 255, 0, 0),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.03,
                        vertical: height * 0.01,
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xffe6e6e6),
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: const [
                                BoxShadow(
                                  spreadRadius: 0,
                                  blurRadius: 2,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            width: width * 0.95,
                            height: height * 0.48,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: height * 0.02,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'ผลฉลากกินแบ่งลอตโต้',
                                        style: TextStyle(
                                          fontFamily: 'prompt',
                                          fontSize: width * 0.07,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        formatCurrentDate(),
                                        style: TextStyle(
                                          fontFamily: 'prompt',
                                          fontSize: width * 0.05,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff9e0000),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height * 0.02),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xffb3e5fc),
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          boxShadow: const [
                                            BoxShadow(
                                              spreadRadius: 0,
                                              blurRadius: 2,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        width: width * 0.4,
                                        child: Center(
                                          child: Text(
                                            jackpotwin[0],
                                            style: TextStyle(
                                              fontFamily: 'prompt',
                                              fontSize: width * 0.065,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xff9e0000),
                                              letterSpacing: width * 0.016,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height * 0.008),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'รางวัลที่ 1',
                                        style: TextStyle(
                                          fontFamily: 'prompt',
                                          fontSize: width * 0.045,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height * 0.02),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xffb3e5fc),
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              boxShadow: const [
                                                BoxShadow(
                                                  spreadRadius: 0,
                                                  blurRadius: 2,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            width: width * 0.4,
                                            child: Center(
                                              child: Text(
                                                jackpotwin[1],
                                                style: TextStyle(
                                                  fontFamily: 'prompt',
                                                  fontSize: width * 0.065,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  letterSpacing: width * 0.016,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: height * 0.008),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'รางวัลที่ 2',
                                                style: TextStyle(
                                                  fontFamily: 'prompt',
                                                  fontSize: width * 0.045,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xffb3e5fc),
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              boxShadow: const [
                                                BoxShadow(
                                                  spreadRadius: 0,
                                                  blurRadius: 2,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            width: width * 0.4,
                                            child: Center(
                                              child: Text(
                                                jackpotwin[2],
                                                style: TextStyle(
                                                  fontFamily: 'prompt',
                                                  fontSize: width * 0.065,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  letterSpacing: width * 0.016,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: height * 0.008),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'รางวัลที่ 3',
                                                style: TextStyle(
                                                  fontFamily: 'prompt',
                                                  fontSize: width * 0.045,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height * 0.02),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xffb3e5fc),
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              boxShadow: const [
                                                BoxShadow(
                                                  spreadRadius: 0,
                                                  blurRadius: 2,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            width: width * 0.4,
                                            child: Center(
                                              child: Text(
                                                jackpotwin[3],
                                                style: TextStyle(
                                                  fontFamily: 'prompt',
                                                  fontSize: width * 0.065,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  letterSpacing: width * 0.016,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: height * 0.008),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'รางวัลที่ 4',
                                                style: TextStyle(
                                                  fontFamily: 'prompt',
                                                  fontSize: width * 0.045,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xffb3e5fc),
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              boxShadow: const [
                                                BoxShadow(
                                                  spreadRadius: 0,
                                                  blurRadius: 2,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            width: width * 0.4,
                                            child: Center(
                                              child: Text(
                                                jackpotwin[4],
                                                style: TextStyle(
                                                  fontFamily: 'prompt',
                                                  fontSize: width * 0.065,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  letterSpacing: width * 0.016,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: height * 0.008),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'รางวัลที่ 5',
                                                style: TextStyle(
                                                  fontFamily: 'prompt',
                                                  fontSize: width * 0.045,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                        ],
                      ),
                    );
                  }
                }
              } else if (jackpotwinsell.isNotEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.03,
                    vertical: height * 0.01,
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffe6e6e6),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: const [
                            BoxShadow(
                              spreadRadius: 0,
                              blurRadius: 2,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        width: width * 0.95,
                        height: height * 0.48,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: height * 0.02,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'ผลฉลากกินแบ่งลอตโต้',
                                    style: TextStyle(
                                      fontFamily: 'prompt',
                                      fontSize: width * 0.07,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    formatCurrentDate(),
                                    style: TextStyle(
                                      fontFamily: 'prompt',
                                      fontSize: width * 0.05,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xff9e0000),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 0.02),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xffb3e5fc),
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: const [
                                        BoxShadow(
                                          spreadRadius: 0,
                                          blurRadius: 2,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    width: width * 0.4,
                                    child: Center(
                                      child: Text(
                                        getJackpotFromSellingNumber(0),
                                        style: TextStyle(
                                          fontFamily: 'prompt',
                                          fontSize: width * 0.065,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff9e0000),
                                          letterSpacing: width * 0.016,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 0.008),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'รางวัลที่ 1',
                                    style: TextStyle(
                                      fontFamily: 'prompt',
                                      fontSize: width * 0.045,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 0.02),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xffb3e5fc),
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          boxShadow: const [
                                            BoxShadow(
                                              spreadRadius: 0,
                                              blurRadius: 2,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        width: width * 0.4,
                                        child: Center(
                                          child: Text(
                                            getJackpotFromSellingNumber(1),
                                            style: TextStyle(
                                              fontFamily: 'prompt',
                                              fontSize: width * 0.065,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              letterSpacing: width * 0.016,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: height * 0.008),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'รางวัลที่ 2',
                                            style: TextStyle(
                                              fontFamily: 'prompt',
                                              fontSize: width * 0.045,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xffb3e5fc),
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          boxShadow: const [
                                            BoxShadow(
                                              spreadRadius: 0,
                                              blurRadius: 2,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        width: width * 0.4,
                                        child: Center(
                                          child: Text(
                                            getJackpotFromSellingNumber(2),
                                            style: TextStyle(
                                              fontFamily: 'prompt',
                                              fontSize: width * 0.065,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              letterSpacing: width * 0.016,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: height * 0.008),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'รางวัลที่ 3',
                                            style: TextStyle(
                                              fontFamily: 'prompt',
                                              fontSize: width * 0.045,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 0.02),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xffb3e5fc),
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          boxShadow: const [
                                            BoxShadow(
                                              spreadRadius: 0,
                                              blurRadius: 2,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        width: width * 0.4,
                                        child: Center(
                                          child: Text(
                                            getJackpotFromSellingNumber(3),
                                            style: TextStyle(
                                              fontFamily: 'prompt',
                                              fontSize: width * 0.065,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              letterSpacing: width * 0.016,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: height * 0.008),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'รางวัลที่ 4',
                                            style: TextStyle(
                                              fontFamily: 'prompt',
                                              fontSize: width * 0.045,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xffb3e5fc),
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          boxShadow: const [
                                            BoxShadow(
                                              spreadRadius: 0,
                                              blurRadius: 2,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        width: width * 0.4,
                                        child: Center(
                                          child: Text(
                                            getJackpotFromSellingNumber(4),
                                            style: TextStyle(
                                              fontFamily: 'prompt',
                                              fontSize: width * 0.065,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              letterSpacing: width * 0.016,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: height * 0.008),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'รางวัลที่ 5',
                                            style: TextStyle(
                                              fontFamily: 'prompt',
                                              fontSize: width * 0.045,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                    ],
                  ),
                );
              } else {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.03,
                    vertical: height * 0.01,
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffe6e6e6),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: const [
                            BoxShadow(
                              spreadRadius: 0,
                              blurRadius: 2,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        width: width * 0.95,
                        height: height * 0.48,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: height * 0.02,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'ผลฉลากกินแบ่งลอตโต้',
                                    style: TextStyle(
                                      fontFamily: 'prompt',
                                      fontSize: width * 0.07,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    formatCurrentDate(),
                                    style: TextStyle(
                                      fontFamily: 'prompt',
                                      fontSize: width * 0.05,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xff9e0000),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 0.02),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xffb3e5fc),
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: const [
                                        BoxShadow(
                                          spreadRadius: 0,
                                          blurRadius: 2,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    width: width * 0.4,
                                    child: Center(
                                      child: Text(
                                        'XXXXXX',
                                        style: TextStyle(
                                          fontFamily: 'prompt',
                                          fontSize: width * 0.07,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff9e0000),
                                          letterSpacing: width * 0.012,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 0.008),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'รางวัลที่ 1',
                                    style: TextStyle(
                                      fontFamily: 'prompt',
                                      fontSize: width * 0.045,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 0.02),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xffb3e5fc),
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          boxShadow: const [
                                            BoxShadow(
                                              spreadRadius: 0,
                                              blurRadius: 2,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        width: width * 0.4,
                                        child: Center(
                                          child: Text(
                                            'XXXXXX',
                                            style: TextStyle(
                                              fontFamily: 'prompt',
                                              fontSize: width * 0.065,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              letterSpacing: width * 0.012,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: height * 0.008),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'รางวัลที่ 2',
                                            style: TextStyle(
                                              fontFamily: 'prompt',
                                              fontSize: width * 0.045,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xffb3e5fc),
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          boxShadow: const [
                                            BoxShadow(
                                              spreadRadius: 0,
                                              blurRadius: 2,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        width: width * 0.4,
                                        child: Center(
                                          child: Text(
                                            'XXXXXX',
                                            style: TextStyle(
                                              fontFamily: 'prompt',
                                              fontSize: width * 0.065,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              letterSpacing: width * 0.012,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: height * 0.008),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'รางวัลที่ 3',
                                            style: TextStyle(
                                              fontFamily: 'prompt',
                                              fontSize: width * 0.045,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 0.02),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xffb3e5fc),
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          boxShadow: const [
                                            BoxShadow(
                                              spreadRadius: 0,
                                              blurRadius: 2,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        width: width * 0.4,
                                        child: Center(
                                          child: Text(
                                            'XXXXXX',
                                            style: TextStyle(
                                              fontFamily: 'prompt',
                                              fontSize: width * 0.065,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              letterSpacing: width * 0.012,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: height * 0.008),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'รางวัลที่ 4',
                                            style: TextStyle(
                                              fontFamily: 'prompt',
                                              fontSize: width * 0.045,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xffb3e5fc),
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          boxShadow: const [
                                            BoxShadow(
                                              spreadRadius: 0,
                                              blurRadius: 2,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        width: width * 0.4,
                                        child: Center(
                                          child: Text(
                                            'XXXXXX',
                                            style: TextStyle(
                                              fontFamily: 'prompt',
                                              fontSize: width * 0.065,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              letterSpacing: width * 0.012,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: height * 0.008),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'รางวัลที่ 5',
                                            style: TextStyle(
                                              fontFamily: 'prompt',
                                              fontSize: width * 0.045,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            }
          }
        },
      ),
    );
  }

  String getJackpotNumber(int index) {
    return widget.resultFromSelling.isNotEmpty &&
            index < widget.resultFromSelling.length
        ? widget.resultFromSelling[index] ?? 'XXXXXX'
        : 'XXXXXX';
  }

  String getJackpotSellNumber(int index) {
    return jackpotwin.isNotEmpty && index < jackpotwin.length
        ? jackpotwin[index]
        : 'XXXXXX';
  }

  String getJackpotFromSellingNumber(int index) {
    return widget.resultFromSelling.isNotEmpty &&
            index < widget.resultFromSelling.length
        ? widget.resultFromSelling[index] ?? 'XXXXXX'
        : 'XXXXXX';
  }

  void confirmNumRand() {
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
                  'ยืนยันเลขชุดนี้?',
                  style: TextStyle(
                    fontFamily: 'prompt',
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                  ),
                ),
              ),
              Center(
                child: Text(
                  'หากท่านประกาศรางวัลไปแล้ว\nรางวัลก่อนหน้าจะถูกรีเซ็ต!',
                  style: TextStyle(
                    fontFamily: 'prompt',
                    fontSize: MediaQuery.of(context).size.width * 0.035,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: confirmLotto,
                    style: ElevatedButton.styleFrom(
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

  Future<void> confirmLotto() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];
    var numbers = widget.resultRandAll;
    var numberssell = widget.resultFromSelling;

    Navigator.pop(context);
    if (widget.acceptNumberJackAll) {
      await http.put(
        Uri.parse('$url/lotto/jackpotall'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"numbers": numbers}),
      );
      setState(() {
        text = 'เลขที่ออก';
        widget.acceptNumberJackAll = false;
      });
    } else if (widget.acceptNumberFromSelling) {
      await http.put(
        Uri.parse('$url/lotto/jackpotsell'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"numbers": numberssell}),
      );
      setState(() {
        text = 'เลขที่ออก';
        widget.acceptNumberFromSelling = false;
      });
    }
  }

  String formatCurrentDate() {
    // ใช้วันที่และเวลาปัจจุบัน
    DateTime dateTime = DateTime.now();

    // เพิ่มเวลาชดเชย 7 ชั่วโมง สำหรับเขตเวลา UTC+7 (ประเทศไทย)
    DateTime adjustedDateTime = dateTime.add(const Duration(hours: 7));

    // กำหนดรูปแบบวันที่และเวลาที่ต้องการ (เช่น 07 ส.ค. 2567 - 00:00)
    var thaiDateFormat = DateFormat('dd MMMM yyyy', 'th_TH');

    // จัดรูปแบบวันที่และเวลาตาม Locale ของภาษาไทย
    var formattedDate = thaiDateFormat.format(adjustedDateTime);

    // แปลง ค.ศ. เป็น พ.ศ.
    String yearInBuddhistEra = (adjustedDateTime.year + 543).toString();
    formattedDate = formattedDate.replaceFirst(
        adjustedDateTime.year.toString(), yearInBuddhistEra);

    return formattedDate;
  }
}
