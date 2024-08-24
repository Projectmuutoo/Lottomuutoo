import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottotmuutoo/config/config.dart';
import 'package:lottotmuutoo/models/response/GetOrderUidResponse.dart'
    as order_response;
import 'package:lottotmuutoo/models/response/UserGetEmailResponse.dart'
    as user_response;
import 'package:lottotmuutoo/pages/login.dart';
import 'package:lottotmuutoo/pages/widgets/drawer.dart';
import 'package:http/http.dart' as http;

class OrderPage extends StatefulWidget {
  String email = '';
  OrderPage({super.key, required this.email});

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
  int count = 0;
  int countmoney = 0;

  @override
  void initState() {
    if (box.read('login') == true) {
      setState(() {
        widget.email = box.read('email');
      });
    }
    super.initState();
    loadData = loadDataAsync();
    // Delay checkLogin until after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkLogin();
    });
  }

  Future<void> loadDataAsync() async {
    try {
      var config = await Configuration.getConfig();
      var url = config['apiEndpoint'];

      // Fetch user data
      var getuser = await http.get(Uri.parse('$url/user/${widget.email}'));
      if (getuser.statusCode == 200) {
        user = user_response.userEmailGetResponeFromJson(getuser.body);
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

            log('Number of orders: $countmoney'); // ล็อกจำนวนชุดข้อมูล
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

      body: SingleChildScrollView(
        child: FutureBuilder(
          future: loadData,
          builder: (context, snapshot) {
            if (widget.email == 'ยังไม่ได้เข้าสู่ระบบ') {
              return Container(
                child: const Text('ยังไม่ได้เข้าสู่ระบบ'),
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

              return SizedBox(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text('ทั้งหมด $count ใบ')),
                          Expanded(child: Text('$countmoney.00 บาท')),
                        ],
                      ),
                      for (var order in _orders)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${order.date.substring(0, 10)} - ${order.date.substring(11, 16)}'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: SvgPicture.string(
                                    '<svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368"><path d="M440-200h80v-40h40q17 0 28.5-11.5T600-280v-120q0-17-11.5-28.5T560-440H440v-40h160v-80h-80v-40h-80v40h-40q-17 0-28.5 11.5T360-520v120q0 17 11.5 28.5T400-360h120v40H360v80h80v40ZM240-80q-33 0-56.5-23.5T160-160v-640q0-33 23.5-56.5T240-880h320l240 240v480q0 33-23.5 56.5T720-80H240Zm280-560v-160H240v640h480v-480H520ZM240-800v160-160 640-640Z"/></svg>',
                                    width: width * 0.02,
                                    height: height * 0.04,
                                  ),
                                ),
                                Expanded(
                                  child: Text('${order.number}'),
                                ),
                                const Expanded(
                                  child: Text('100.00 บาท'),
                                ),
                                Expanded(
                                  child: Text(
                                    // Check conditions for reward and win and display appropriate messages
                                    _getStatusMessage(order.reward, order.win),
                                    style: TextStyle(
                                      color:
                                          (order.reward == 0 && order.win != 0)
                                              ? Colors.orange
                                              : (order.reward == 1 &&
                                                      order.win != 0)
                                                  ? Colors.blue
                                                  : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void checkLogin() {
    if (widget.email == 'ยังไม่ได้เข้าสู่ระบบ') {
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
                    'กรุณาล็อคอิน!',
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
  }
}

String _getStatusMessage(int? reward, int win) {
  if (reward == 0 && win == 0) {
    return 'ไม่ถูกรางวัล'; // Not a winner
  } else if (reward == 0 && win != 0) {
    return 'ถูกรางวัลแต่ยังไม่ขึ้นเงิน'; // Won but not yet redeemed
  } else if (reward == 1 && win != 0) {
    return 'ถูกรางวัล'; // Won and redeemed
  } else {
    return 'สถานะไม่ทราบ'; // Unknown status
  }
}
