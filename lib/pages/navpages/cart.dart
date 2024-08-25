import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottotmuutoo/config/config.dart';
import 'package:lottotmuutoo/models/response/BasketUserResponse.dart';
import 'package:lottotmuutoo/models/response/UserGetBasKetEmailResponse.dart';
import 'package:lottotmuutoo/models/response/UserGetBasketResponse.dart';
import 'package:lottotmuutoo/models/response/UserGetEmailResponse.dart';
import 'package:lottotmuutoo/models/response/UserIdxGetResponse.dart';
import 'package:lottotmuutoo/pages/login.dart';
import 'package:lottotmuutoo/pages/widgets/drawer.dart';
import 'package:http/http.dart' as http;

class CartPage extends StatefulWidget {
  String email = '';
  CartPage({
    super.key,
    required this.email,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late UserIdxGetResponse user;
  late BasketUserResponse basket;
  late Future<void> loadData;
  final box = GetStorage();
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
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];
    var res = await http.get(Uri.parse('$url/user/${widget.email}'));
    // log(res.body);
    user = userIdxGetResponseFromJson(res.body);
    // log(user.result[0].uid.toString());
    var res1 = await http.get(Uri.parse('$url/basket/${user.result[0].uid}'));
    basket = basketUserResponseFromJson(res1.body);
    log(basket.result[0].number);
    log(basket.result[0].bid.toString());
  }

  bool _isChecked = false; // ประกาศตัวแปรสำหรับ Checkbox

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
          width * 0.30, //////////////
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
        email: widget.email,
        selectedPage: 4,
      ),

      body: FutureBuilder(
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
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: SizedBox(
                    width: 370,
                    height: 700,
                    child: Card(
                      color: const Color(0xFFD9D9D9), // สีเทาของการ์ดใหญ่
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 8.0, // เงาที่ขอบการ์ด
                      shadowColor: Colors.grey[600],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              "รายการลอตโต้",
                              style: TextStyle(
                                fontSize: width * 0.045,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Expanded(
                            child: basket.result.isEmpty
                                ? const Center(
                                    child: Text(
                                      'ยังไม่มีลอตโต้ในตะกร้า',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: basket.result
                                        .length, // จำนวนรายการจาก response
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width * 0.025),
                                        child: SizedBox(
                                          width: 380, // กำหนดความกว้างของการ์ด
                                          height: 70, // กำหนดความสูงของการ์ด
                                          child: Card(
                                            color: const Color(0xFFB4B4B4),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            elevation:
                                                3.0, // เพิ่มความหนาของเงา
                                            shadowColor:
                                                Colors.black, // สีของเงา
                                            margin: EdgeInsets.symmetric(
                                                vertical: height * 0.006),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: width * 0.016),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    basket.result[index].number,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '100.00 บาท',
                                                        style: TextStyle(
                                                            fontSize:
                                                                width * 0.038,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Container(
                                                        height: 50,
                                                        width: 1.5,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 0, 0, 0),
                                                      ),
                                                      IconButton(
                                                        icon: const Icon(
                                                          Icons.close,
                                                          color: Colors.red,
                                                          size: 30.0,
                                                        ),
                                                        onPressed: () {
                                                          deletelist(basket
                                                              .result[index]
                                                              .bid);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                                top: 30, bottom: 10, left: 10, right: 10),
                            child: SizedBox(
                              height: 1.5,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: SizedBox(
                              height: 150,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF63030),
                                  borderRadius: BorderRadius.circular(15.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      spreadRadius: 0,
                                      blurRadius: 4,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'จำนวน', // จำนวนรายการ
                                            style: TextStyle(
                                              fontSize: width * 0.045,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                          Text(
                                            '${basket.result.length} ใบ',
                                            style: TextStyle(
                                              fontSize: width * 0.045,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'ยอดรวมทั้งหมด',
                                          style: TextStyle(
                                            fontSize: width * 0.050,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          '${(basket.result.length * 100).toStringAsFixed(2)} บาท',
                                          style: TextStyle(
                                            fontSize: width * 0.065,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(30),
                            child: SizedBox(
                              height: 1.5,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 18),
                            child: Text(
                              'ช่องทางชำระเงิน',
                              style: TextStyle(
                                fontSize: width * 0.040,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 120, top: 10, bottom: 10),
                            child: SizedBox(
                              height: 60, // ขนาดความสูงของการ์ด
                              child: Card(
                                elevation: 2.0, // ลดความหนาของเงา
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8.0), // ลดความโค้งมนของการ์ด
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8.0), // ลดการเยื้องด้านใน
                                  leading: const Icon(
                                    Icons.wallet_travel,
                                    size: 24.0, // ขนาดไอคอนเล็กลง
                                  ),
                                  title: const Text(
                                    'ใช้กระเป๋าตัง',
                                    style: TextStyle(
                                      fontSize: 14, // ขนาดข้อความเล็กลง
                                      fontWeight: FontWeight
                                          .normal, // น้ำหนักของข้อความ
                                    ),
                                  ),
                                  trailing: Checkbox(
                                    value: _isChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _isChecked = value ?? false;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 70, right: 70, bottom: 20),
                            child: SizedBox(
                              height: 50, // ปรับความสูงของปุ่ม
                              child: ElevatedButton(
                                onPressed: _isChecked
                                    ? () async {
                                        if (basket.result.isNotEmpty) {
                                          // สร้างอาร์เรย์ของ lid โดยรวม bLid จากทุกๆ รายการใน basket.result
                                          List<int> lidArray = basket.result
                                              .map((item) => item
                                                  .bLid) // ใช้ item.bLid แทน basket.result[0].bLid
                                              .toList();
                                          await insertOrder(lidArray);
                                        }
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFC91A1A),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  elevation: 5,
                                  shadowColor: Colors.black
                                      .withOpacity(0.3), // เงาของปุ่ม
                                ),
                                child: const Text(
                                  'ยืนยัน',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        },
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

  void deletelist(int bid) async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];
    var res = await http.delete(Uri.parse('$url/basket/$bid'));
    if (res.statusCode == 200) {
      setState(() {
        basket.result.removeWhere((item) => item.bid == bid);
      });
    } else {
      log('ลบรายการล้มเหลว');
    }
  }

  Future<void> insertOrder(List<int> lidArray) async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];

    int totalAmount = basket.result.length * 100;
    int userMoney = user.result[0].money;
    if (userMoney >= totalAmount) {
      // Insert Order
      int bUid = basket.result.isNotEmpty ? basket.result[0].bUid : 0;
      var order = {
        "list_uid": bUid,
        "list_lid": lidArray,
      };
      String requestBody = json.encode(order);

      try {
        var response = await http.post(
          Uri.parse('$url/order'),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: requestBody,
        );
        if (response.statusCode == 201) {
          log('Order placed successfully: ${response.body}');
        } else {
          log('Failed to place order: ${response.reasonPhrase}');
        }
      } catch (e) {
        log('Error occurred while placing order: $e');
      }

      // Update Money
      int remainingMoney = userMoney - totalAmount;
      log('Remaining money to update: $remainingMoney');

      var updatedMoneyJson = {
        "email": user.result[0].email,
        "money": remainingMoney
      };

      try {
        var res1 = await http.put(
          Uri.parse('$url/user/money'),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: jsonEncode(updatedMoneyJson),
        );
        var result = jsonDecode(res1.body);
        log('Server response after money update: ${result['message']}');
      } catch (err) {
        log(err.toString());
      }

      // Delete lotto
      var res = await http
          .delete(Uri.parse('$url/basket/user/${user.result[0].uid}'));
      if (res.statusCode == 200) {
        log('Successfully deleted basket: ${res.body}');
      } else {
        log('Failed to delete basket: ${res.statusCode} - ${res.reasonPhrase}');
      }

      //Insert money
      var data = {
        'm_uid': user.result[0].uid,
        'money': remainingMoney,
        'type': 2,
      };

      // แปลงข้อมูลเป็น JSON
      String requestBody2 = json.encode(data);

      try {
        // ส่งข้อมูลไปยังเซิร์ฟเวอร์
        var response = await http.post(
          Uri.parse('$url/money/add'),
          headers: {
            'Content-Type': 'application/json; charset=utf-8',
          },
          body: requestBody2,
        );

        // ตรวจสอบสถานะการตอบกลับ
        if (response.statusCode == 200) {
          // การตอบกลับที่สำเร็จ
          log('Data inserted successfully: ${response.body}');
        } else {
          // การตอบกลับที่ล้มเหลว
          log('Failed to insert data: ${response.statusCode} - ${response.reasonPhrase}');
        }
      } catch (e) {
        // ข้อผิดพลาดในกรณีที่เกิด exception
        log('Error occurred: $e');
      }

      // Refresh the page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CartPage(email: widget.email)),
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(
              child: Text(
                'ซื้อลอตโต้เสร็จสิ้น',
                style: TextStyle(
                  fontSize: 18, // ขนาดฟอนต์ที่ใหญ่ขึ้น
                  fontWeight: FontWeight.bold, // ข้อความหนาขึ้น
                ),
                textAlign: TextAlign.center, // ให้ข้อความอยู่กลาง
              ),
            ),
            content: const Text(
              'รายการของคุณได้ถูกจัดการเรียบร้อยแล้ว',
              style: TextStyle(
                fontSize: 16, // ขนาดฟอนต์ที่ใหญ่ขึ้น
              ),
              textAlign: TextAlign.center, // ให้ข้อความอยู่กลาง
            ),
            actions: <Widget>[
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(
                      MediaQuery.of(context).size.width * 0.25,
                      MediaQuery.of(context).size.height * 0.04,
                    ),
                    backgroundColor: const Color(0xff0288d1),
                    elevation: 3, // เงาล่าง
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    "ปิด",
                    style: TextStyle(
                      fontFamily: 'prompt',
                      fontWeight: FontWeight.w500,
                      fontSize: MediaQuery.of(context).size.width * 0.042,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(
              child: Text(
                'ไม่สามารถซื้อลอตโต้',
                style: TextStyle(
                  fontSize: 18, // ขนาดฟอนต์ที่ใหญ่ขึ้น
                  fontWeight: FontWeight.bold, // ข้อความหนาขึ้น
                ),
                textAlign: TextAlign.center, // ให้ข้อความอยู่กลาง
              ),
            ),
            content: const Text(
              'ยอดเงินในเป๋าตังของท่านไม่เพียงพอ กรุณาเติมเงินเพื่อซื้อลอตโต้อีกครั้ง',
              style: TextStyle(
                fontSize: 16, // ขนาดฟอนต์ที่ใหญ่ขึ้น
              ),
              textAlign: TextAlign.center, // ให้ข้อความอยู่กลาง
            ),
            actions: <Widget>[
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(
                      MediaQuery.of(context).size.width * 0.25,
                      MediaQuery.of(context).size.height * 0.04,
                    ),
                    backgroundColor: const Color(0xff0288d1),
                    elevation: 3, // เงาล่าง
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
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }
}
