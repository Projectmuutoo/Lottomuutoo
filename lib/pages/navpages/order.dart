import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottotmuutoo/config/config.dart';
import 'package:lottotmuutoo/models/response/BasketUserResponse.dart';
import 'package:lottotmuutoo/models/response/GetOrderUidResponse.dart'
    as order_response;
import 'package:lottotmuutoo/models/response/UserGetEmailResponse.dart'
    as user_response;
import 'package:lottotmuutoo/models/response/jackpotwinGetResponse.dart';
import 'package:lottotmuutoo/pages/login.dart';
import 'package:lottotmuutoo/pages/widgets/drawer.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class OrderPage extends StatefulWidget {
  String email = '';
  final StreamController<int> basketCountController;

  OrderPage({
    super.key,
    required this.email,
    required this.basketCountController,
  });

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late Future<void> loadData;
  final box = GetStorage();
  user_response.UserEmailGetRespone? user;
  List<user_response.Result> results = [];
  late String getOrderUidJson;
  List<order_response.Result> _orders = [];
  late JackpotwinGetResponse resultststus;
  int count = 0;
  int countmoney = 0;
  late BasketUserResponse basket;
  String money = '';

  @override
  void initState() {
    if (box.read('login') == true) {
      setState(() {
        widget.email = box.read('email');
      });
    }
    super.initState();
    loadData = loadDataAsync();
    getStatusMessage();
  }

  Future<void> loadDataAsync() async {
    try {
      var config = await Configuration.getConfig();
      var url = config['apiEndpoint'];

      // Fetch user data
      var getuser = await http.get(Uri.parse('$url/user/${widget.email}'));
      if (getuser.statusCode == 200) {
        user = user_response.userEmailGetResponeFromJson(getuser.body);
        money = user!.result[0].money.toString();
        var basketRes =
            await http.get(Uri.parse('$url/basket/${user?.result[0].uid}'));
        basket = basketUserResponseFromJson(basketRes.body);
        results = user?.result ?? [];

        if (results.isNotEmpty) {
          // Fetch order data
          var getorder =
              await http.get(Uri.parse('$url/order/${results[0].uid}'));
          // log(getorder.body);
          if (getorder.statusCode == 200) {
            var getOrderUid = order_response.getOrderUidFromJson(getorder.body);
            // แปลง getOrderUid เป็น JSON และบันทึกข้อมูล
            getOrderUidJson = order_response.getOrderUidToJson(getOrderUid);

            setState(() {
              _orders = getOrderUid.result; // รายการของออเดอร์
            });

            // log('GetOrderUid JSON: $getOrderUidJson');
            count = getOrderUid.result.length;
            countmoney = 100 * getOrderUid.result.length;

            // log('Number of orders: $countmoney'); // ล็อกจำนวนชุดข้อมูล
            // log('Type of getorder: ${getorder.runtimeType}');
          }
        } else {
          log('No results found for the given email.');
        }
      } else {
        log('Failed to fetch user data. Status code: ${getuser.statusCode}');
      }
    } catch (e) {
      log('Error loading data: $e');
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
                        Text(
                          'คำสั่งซื้อ',
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
        selectedPage: 1,
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

            if (_orders.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: height * 0.02,
                      left: width * 0.02,
                      right: width * 0.02,
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xffb4b4b4),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.03,
                          vertical: height * 0.01,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ทั้งหมด $count ใบ',
                              style: TextStyle(
                                fontFamily: 'prompt',
                                fontSize: width * 0.04,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${NumberFormat('#,##0').format(countmoney)}.00 บาท',
                              style: TextStyle(
                                fontFamily: 'prompt',
                                fontSize: width * 0.04,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        width: width * 0.94,
                        color: const Color(0xffd9d9d9),
                        child: Column(
                          children: [
                            for (var order in _orders)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: height * 0.01,
                                      left: width * 0.03,
                                      right: width * 0.03,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          formatDate(order.date.toString()),
                                          style: TextStyle(
                                            fontFamily: 'prompt',
                                            fontSize: width * 0.03,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        if (resultststus.result.isEmpty)
                                          Text(
                                            'ยังไม่ประกาศรางวัล',
                                            style: TextStyle(
                                              color: const Color(0xff0088d1),
                                              fontFamily: 'prompt',
                                              fontSize: width * 0.04,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        if (resultststus.result.isNotEmpty)
                                          Text(
                                            _getStatusMessage(
                                              order.sell,
                                              order.reward,
                                              order.win,
                                            ).toString(),
                                            style: TextStyle(
                                              color: (order.sell != 0 &&
                                                      order.reward == 0 &&
                                                      order.win != 0)
                                                  ? const Color.fromARGB(
                                                      255, 0, 52, 206)
                                                  : (order.sell != 0 &&
                                                          order.reward == 1 &&
                                                          order.win != 0)
                                                      ? const Color.fromARGB(
                                                          255, 0, 164, 5)
                                                      : (order.sell != 0 &&
                                                              order.reward ==
                                                                  0 &&
                                                              order.win == 0)
                                                          ? const Color
                                                              .fromARGB(
                                                              255, 214, 0, 0)
                                                          : const Color
                                                              .fromARGB(
                                                              255, 211, 127, 0),
                                              fontFamily: 'prompt',
                                              fontSize: width * 0.04,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.014,
                                    ),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(12),
                                          bottomRight: Radius.circular(12),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            spreadRadius: 0,
                                            blurRadius: 1,
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: height * 0.065,
                                                color: const Color(0xff4cd5dd),
                                                child: SvgPicture.string(
                                                  '<svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368"><path d="M440-200h80v-40h40q17 0 28.5-11.5T600-280v-120q0-17-11.5-28.5T560-440H440v-40h160v-80h-80v-40h-80v40h-40q-17 0-28.5 11.5T360-520v120q0 17 11.5 28.5T400-360h120v40H360v80h80v40ZM240-80q-33 0-56.5-23.5T160-160v-640q0-33 23.5-56.5T240-880h320l240 240v480q0 33-23.5 56.5T720-80H240Zm280-560v-160H240v640h480v-480H520ZM240-800v160-160 640-640Z"/></svg>',
                                                  width: width * 0.04,
                                                  height: height * 0.04,
                                                ),
                                              ),
                                              SizedBox(width: width * 0.016),
                                              Text(
                                                order.number,
                                                style: TextStyle(
                                                  fontFamily: 'prompt',
                                                  fontSize: width * 0.05,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: width * 0.01,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              right: width * 0.02,
                                            ),
                                            child: Text(
                                              '100.00 บาท',
                                              style: TextStyle(
                                                fontFamily: 'prompt',
                                                fontSize: width * 0.042,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            SizedBox(height: height * 0.01)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: height * 0.6,
                    child: Center(
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
                              'คุณยังไม่มีรายการ',
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
                ],
              );
            }
          }
        },
      ),
    );
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

  getStatusMessage() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];
    var response = await http.get(Uri.parse('$url/lotto/jackpotwin'));
    resultststus = jackpotwinGetResponseFromJson(response.body);
  }

  String _getStatusMessage(int sell, int? reward, int win) {
    if (sell != 0 && reward == 0 && win != 0) {
      return 'ยังไม่ขึ้นเงิน';
    } else if (sell != 0 && reward == 1 && win != 0) {
      return 'ถูกรางวัล';
    } else if (sell != 0 && reward == 0 && win == 0) {
      return 'ไม่ถูกรางวัล';
    } else {
      return 'ไม่ทราบสถานะ';
    }
  }

  String formatDate(String dateString) {
    // แปลงวันที่จาก String เป็น DateTime (ISO 8601)
    DateTime dateTime = DateTime.parse(dateString);

    // เพิ่มเวลาชดเชย 7 ชั่วโมง สำหรับเขตเวลา UTC+7 (ประเทศไทย)
    DateTime adjustedDateTime = dateTime.add(const Duration(hours: 5));

    // กำหนดรูปแบบวันที่และเวลาที่ต้องการ (เช่น 07 ส.ค. 2567 - 00:00)
    var thaiDateFormat = DateFormat('dd MMM yyyy - HH:mm', 'th_TH');

    // จัดรูปแบบวันที่และเวลาตาม Locale ของภาษาไทย
    var formattedDate = thaiDateFormat.format(adjustedDateTime);

    // แปลง ค.ศ. เป็น พ.ศ.
    String yearInBuddhistEra = (adjustedDateTime.year + 543).toString();
    formattedDate = formattedDate.replaceFirst(
        adjustedDateTime.year.toString(), yearInBuddhistEra);

    return formattedDate;
  }
}
