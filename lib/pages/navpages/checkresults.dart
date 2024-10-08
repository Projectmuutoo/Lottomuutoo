import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
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
  String text = '';
  var fontS = 0.0;
  late BasketUserResponse basket;
  String money = '';

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
          fontS = Get.textTheme.headlineLarge!.fontSize!;
        } else {
          text = 'ยังไม่ประกาศรางวัล';
          fontS = Get.textTheme.headlineMedium!.fontSize!;
        }
      });
    } else {
      var userResponse = await http.get(Uri.parse('$url/user/${widget.email}'));
      var user = userIdxGetResponseFromJson(userResponse.body);
      money = user.result[0].money.toString();
      var basketRes =
          await http.get(Uri.parse('$url/basket/${user.result[0].uid}'));
      basket = basketUserResponseFromJson(basketRes.body);
      setState(() {
        for (var n in results.result) {
          jackpotwin.add(n.number);
        }
        if (jackpotwin.isNotEmpty) {
          text = 'ประกาศรางวัล';
          fontS = Get.textTheme.headlineLarge!.fontSize!;
        } else {
          text = 'ยังไม่ประกาศรางวัล';
          fontS = Get.textTheme.headlineMedium!.fontSize!;
        }
      });
    }
    setState(() {
      widget.basketCountController.add(basket.result.length);
    });
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
                        Row(
                          children: [
                            if (!(widget.email == 'ยังไม่ได้เข้าสู่ระบบ'))
                              Row(
                                children: [
                                  SvgPicture.string(
                                    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M16 12h2v4h-2z"></path><path d="M20 7V5c0-1.103-.897-2-2-2H5C3.346 3 2 4.346 2 6v12c0 2.201 1.794 3 3 3h15c1.103 0 2-.897 2-2V9c0-1.103-.897-2-2-2zM5 5h13v2H5a1.001 1.001 0 0 1 0-2zm15 14H5.012C4.55 18.988 4 18.805 4 18V8.815c.314.113.647.185 1 .185h15v10z"></path></svg>',
                                    width: width * 0.05,
                                    height: width * 0.05,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: width * 0.008),
                                  Text(
                                    money,
                                    style: TextStyle(
                                      fontSize: width * 0.035,
                                      fontFamily: 'prompt',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            SizedBox(width: width * 0.02),
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
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        jackpotwin.isNotEmpty
                            ? Text(
                                'ประกาศรางวัล',
                                style: TextStyle(
                                  fontFamily: 'prompt',
                                  fontSize: fontS,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'ยังไม่ประกาศรางวัล',
                                style: TextStyle(
                                  fontFamily: 'prompt',
                                  fontSize: fontS,
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
            }
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
                                      fontSize: width * 0.065,
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
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
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
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
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
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
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
                                          color: const Color.fromARGB(
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
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
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
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
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
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
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
                                          color: const Color.fromARGB(
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
                ],
              ),
            );
          }),
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
    // DateTime adjustedDateTime = dateTime.add(const Duration(hours: 5));

    // กำหนดรูปแบบวันที่และเวลาที่ต้องการ (เช่น 07 ส.ค. 2567 - 00:00)
    var thaiDateFormat = DateFormat('dd MMMM yyyy', 'th_TH');

    // จัดรูปแบบวันที่และเวลาตาม Locale ของภาษาไทย
    var formattedDate = thaiDateFormat.format(dateTime);

    // แปลง ค.ศ. เป็น พ.ศ.
    String yearInBuddhistEra = (dateTime.year + 543).toString();
    formattedDate =
        formattedDate.replaceFirst(dateTime.year.toString(), yearInBuddhistEra);

    return formattedDate;
  }
}
