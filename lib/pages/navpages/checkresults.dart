import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottotmuutoo/config/config.dart';
import 'package:lottotmuutoo/models/response/BasketUserResponse.dart';
import 'package:lottotmuutoo/models/response/UserIdxGetResponse.dart';
import 'package:lottotmuutoo/models/response/jackpotwinGetResponse.dart';
import 'package:lottotmuutoo/pages/widgets/drawer.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class CheckresultsPage extends StatefulWidget {
  String email = '';
  final StreamController<int> basketCountController;
  CheckresultsPage({
    super.key,
    required this.email,
    required this.basketCountController,
  });

  @override
  State<CheckresultsPage> createState() => _CheckresultsPageState();
}

class _CheckresultsPageState extends State<CheckresultsPage> {
  late Future<void> loadData;
  List jackpotwin = [];
  String text = 'ยังไม่ประกาศรางวัล';
  late BasketUserResponse basket;

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
    if (widget.email == 'ยังไม่ได้เข้าสู่ระบบ') {
      setState(() {
        for (var n in results.result) {
          jackpotwin.add(n.number);
        }
        if (jackpotwin.isNotEmpty) {
          text = 'ประกาศรางวัล';
        }
        widget.basketCountController.add(basket.result.length);
      });
    } else {
      var userResponse = await http.get(Uri.parse('$url/user/${widget.email}'));
      var user = userIdxGetResponseFromJson(userResponse.body);
      var basketRes =
          await http.get(Uri.parse('$url/basket/${user.result[0].uid}'));
      basket = basketUserResponseFromJson(basketRes.body);
      setState(() {
        for (var n in results.result) {
          jackpotwin.add(n.number);
        }
        if (jackpotwin.isNotEmpty) {
          text = 'ประกาศรางวัล';
        }
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

    return FutureBuilder(
      future: loadData,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

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
                              text,
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
            selectedPage: 6,
          ),
          body: Padding(
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
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: height * 0.02,
                      bottom: height * 0.06,
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
                                  getJackpotWinNumber(0),
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
                                color: const Color.fromARGB(255, 0, 0, 0),
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
                                      getJackpotWinNumber(1),
                                      style: TextStyle(
                                        fontFamily: 'prompt',
                                        fontSize: width * 0.065,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        letterSpacing: width * 0.012,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: height * 0.008),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'รางวัลที่ 2',
                                      style: TextStyle(
                                        fontFamily: 'prompt',
                                        fontSize: width * 0.045,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
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
                                      getJackpotWinNumber(2),
                                      style: TextStyle(
                                        fontFamily: 'prompt',
                                        fontSize: width * 0.065,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        letterSpacing: width * 0.012,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: height * 0.008),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'รางวัลที่ 3',
                                      style: TextStyle(
                                        fontFamily: 'prompt',
                                        fontSize: width * 0.045,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
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
                                      getJackpotWinNumber(3),
                                      style: TextStyle(
                                        fontFamily: 'prompt',
                                        fontSize: width * 0.065,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        letterSpacing: width * 0.012,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: height * 0.008),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'รางวัลที่ 4',
                                      style: TextStyle(
                                        fontFamily: 'prompt',
                                        fontSize: width * 0.045,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
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
                                      getJackpotWinNumber(4),
                                      style: TextStyle(
                                        fontFamily: 'prompt',
                                        fontSize: width * 0.065,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        letterSpacing: width * 0.012,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: height * 0.008),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'รางวัลที่ 5',
                                      style: TextStyle(
                                        fontFamily: 'prompt',
                                        fontSize: width * 0.045,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
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
          ),
        );
      },
    );
  }

  String getJackpotWinNumber(int index) {
    return jackpotwin.isNotEmpty && index < jackpotwin.length
        ? jackpotwin[index]
        : 'XXXXXX';
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
