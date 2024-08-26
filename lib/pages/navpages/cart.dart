import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottotmuutoo/config/config.dart';
import 'package:lottotmuutoo/models/response/BasketUserResponse.dart';
import 'package:lottotmuutoo/models/response/UserIdxGetResponse.dart';
import 'package:lottotmuutoo/pages/login.dart';
import 'package:lottotmuutoo/pages/widgets/drawer.dart';
import 'package:http/http.dart' as http;

class CartPage extends StatefulWidget {
  String email = '';
  // update ตัวเลข บนตะกร้า
  final Function(int) onBasketUpdated;
  CartPage({
    Key? key,
    required this.email,
    required this.onBasketUpdated,
  }) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late UserIdxGetResponse user;
  late BasketUserResponse basket;
  late Future<void> loadData;
  final box = GetStorage();
  List baskets = [];
  bool _isChecked = false;
  bool isLoading = false;

  @override
  void initState() {
    if (box.read('login') == true) {
      setState(() {
        widget.email = box.read('email');
      });
    }
    super.initState();
    loadData = loadDataAsync();
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
    setState(() {
      for (var i in basket.result) {
        baskets.add(i);
      }
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

            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: height * 0.012,
                horizontal: width * 0.04,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFd9d9d9), // สีพื้นหลัง
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.03,
                        vertical: height * 0.01,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "รายการลอตโต้",
                            style: TextStyle(
                              fontFamily: 'prompt',
                              color: Colors.black,
                              fontSize: width * 0.05,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.28,
                      child: SingleChildScrollView(
                        child: Column(
                          children: baskets.isEmpty
                              ? [
                                  SizedBox(
                                    height: height * 0.25,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'ยังไม่มีลอตโต้ในตะกร้า',
                                          style: TextStyle(
                                            fontFamily: 'prompt',
                                            fontSize: width * 0.05,
                                            fontWeight: FontWeight.w400,
                                            color: const Color.fromARGB(
                                                255, 112, 112, 112),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ]
                              : baskets.map((basket) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.03,
                                      vertical: height * 0.003,
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.03,
                                        vertical: height * 0.004,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: Color(
                                            0xFFb4b4b4), // Background color
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                basket.number,
                                                style: TextStyle(
                                                  fontFamily: 'prompt',
                                                  fontSize: width * 0.05,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '100.00 บาท',
                                                style: TextStyle(
                                                  fontFamily: 'prompt',
                                                  fontSize: width * 0.04,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              SizedBox(width: width * 0.02),
                                              Container(
                                                color: Colors.black,
                                                width: width * 0.004,
                                                height: height * 0.042,
                                              ),
                                              SizedBox(width: width * 0.01),
                                              InkWell(
                                                onTap: () {
                                                  deletelist(basket.bid);
                                                },
                                                child: SvgPicture.string(
                                                  '<svg xmlns="http://www.w3.org/2000/svg" height="40px" viewBox="0 -960 960 960" width="40px" fill="#5f6368"><path d="m251.33-198.29-53.04-53.04L426.96-480 198.29-708.67l53.04-53.04L480-533.04l228.67-228.67 53.04 53.04L533.04-480l228.67 228.67-53.04 53.04L480-426.96 251.33-198.29Z"/></svg>',
                                                  width: width * 0.04,
                                                  height: height * 0.04,
                                                  fit: BoxFit.cover,
                                                  color:
                                                      const Color(0xff9e0000),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                        ),
                      ),
                    ),
                    Container(
                      color: const Color.fromARGB(255, 101, 101, 101),
                      width: width * 0.9,
                      height: height * 0.002,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.04,
                        vertical: height * 0.014,
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFf63030), // สีพื้นหลัง
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 0,
                              blurRadius: 2,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.03,
                            vertical: height * 0.01,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'จำนวน', // จำนวนรายการ
                                    style: TextStyle(
                                      fontFamily: 'prompt',
                                      fontSize: width * 0.048,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${baskets.length} ใบ',
                                    style: TextStyle(
                                      fontFamily: 'prompt',
                                      fontSize: width * 0.048,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'ยอดรวมทั้งหมด',
                                        style: TextStyle(
                                          fontFamily: 'prompt',
                                          fontSize: width * 0.054,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${baskets.length * 100}.00 บาท',
                                        style: TextStyle(
                                          fontFamily: 'prompt',
                                          fontSize: width * 0.065,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: const Color.fromARGB(255, 101, 101, 101),
                      width: width * 0.9,
                      height: height * 0.002,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: height * 0.006,
                        left: width * 0.03,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'ช่องทางชำระเงิน',
                            style: TextStyle(
                              fontFamily: 'prompt',
                              fontSize: width * 0.045,
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: height * 0.006,
                        left: width * 0.03,
                      ),
                      child: Stack(
                        children: [
                          baskets.isEmpty
                              ? Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: null,
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: Size(
                                          MediaQuery.of(context).size.width *
                                              0.42,
                                          MediaQuery.of(context).size.height *
                                              0.08,
                                        ),
                                        backgroundColor: _isChecked
                                            ? const Color(0xff2cb6f6)
                                            : const Color.fromARGB(
                                                255, 255, 255, 255),
                                        elevation: _isChecked ? 0 : 3,
                                        shadowColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          SvgPicture.string(
                                            '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M16 12h2v4h-2z"></path><path d="M20 7V5c0-1.103-.897-2-2-2H5C3.346 3 2 4.346 2 6v12c0 2.201 1.794 3 3 3h15c1.103 0 2-.897 2-2V9c0-1.103-.897-2-2-2zM5 5h13v2H5a1.001 1.001 0 0 1 0-2zm15 14H5.012C4.55 18.988 4 18.805 4 18V8.815c.314.113.647.185 1 .185h15v10z"></path></svg>',
                                            width: width * 0.04,
                                            height: height * 0.04,
                                            fit: BoxFit.cover,
                                          ),
                                          SizedBox(width: width * 0.01),
                                          Text(
                                            'ใช้กระเป๋าตัง',
                                            style: TextStyle(
                                              fontFamily: 'prompt',
                                              fontSize: width * 0.045,
                                              color: const Color.fromARGB(
                                                  255, 0, 0, 0),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _isChecked = !_isChecked;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: Size(
                                          MediaQuery.of(context).size.width *
                                              0.42,
                                          MediaQuery.of(context).size.height *
                                              0.08,
                                        ),
                                        backgroundColor: _isChecked
                                            ? const Color(0xff2cb6f6)
                                            : const Color.fromARGB(
                                                255, 255, 255, 255),
                                        elevation: _isChecked ? 0 : 3,
                                        shadowColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          SvgPicture.string(
                                            '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M16 12h2v4h-2z"></path><path d="M20 7V5c0-1.103-.897-2-2-2H5C3.346 3 2 4.346 2 6v12c0 2.201 1.794 3 3 3h15c1.103 0 2-.897 2-2V9c0-1.103-.897-2-2-2zM5 5h13v2H5a1.001 1.001 0 0 1 0-2zm15 14H5.012C4.55 18.988 4 18.805 4 18V8.815c.314.113.647.185 1 .185h15v10z"></path></svg>',
                                            width: width * 0.04,
                                            height: height * 0.04,
                                            fit: BoxFit.cover,
                                          ),
                                          SizedBox(width: width * 0.01),
                                          Text(
                                            'ใช้กระเป๋าตัง',
                                            style: TextStyle(
                                              fontFamily: 'prompt',
                                              fontSize: width * 0.045,
                                              color: const Color.fromARGB(
                                                  255, 0, 0, 0),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                          Positioned(
                            bottom: height * 0.045,
                            right: width * 0.14,
                            top: 0,
                            left: 0,
                            child: Transform.scale(
                              scale: width * 0.003,
                              child: Checkbox(
                                value: _isChecked,
                                activeColor: Colors.white,
                                checkColor: Colors.black,
                                shape: const CircleBorder(),
                                onChanged: baskets.isEmpty
                                    ? null
                                    : (bool? value) {
                                        setState(() {
                                          _isChecked = value ?? false;
                                        });
                                      },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _isChecked
                              ? () {
                                  if (baskets.isNotEmpty) {
                                    // สร้างอาร์เรย์ของ lid โดยรวม bLid จากทุกๆ รายการใน basket.result
                                    List<int> lidArray = baskets
                                        .map((item) => item.bLid as int)
                                        .toList();
                                    confirm(lidArray);
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.5,
                              MediaQuery.of(context).size.height * 0.05,
                            ),
                            backgroundColor: const Color(0xffc91a1a),
                            elevation: 3, //เงาล่าง
                            shadowColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'ยืนยันชำระ',
                            style: TextStyle(
                              fontFamily: 'prompt',
                              fontSize: width * 0.045,
                              color: baskets.isEmpty || baskets.isNotEmpty
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
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

  void deletelist(int bid) async {
    setState(() {
      isLoading = true;
    });
    // แสดง Loading Dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        content: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];
    var res = await http.delete(Uri.parse('$url/basket/$bid'));
    if (res.statusCode == 200) {
      Navigator.pop(context);
      setState(() {
        baskets.removeWhere((item) => item.bid == bid);
        widget.onBasketUpdated(baskets.length); // เรียก Callback
        isLoading = false;
      });
    } else {
      // log('ลบรายการล้มเหลว');
    }
  }

  void confirm(lidArray) {
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
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.04,
              ),
              Center(
                child: Text(
                  'ยืนยันการชำระเงิน?',
                  style: TextStyle(
                    fontFamily: 'prompt',
                    fontWeight: FontWeight.w500,
                    fontSize: MediaQuery.of(context).size.width * 0.06,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      insertOrder(lidArray);
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(
                        MediaQuery.of(context).size.width * 0.25,
                        MediaQuery.of(context).size.height * 0.04,
                      ),
                      backgroundColor: const Color(0xff0288d1),
                      elevation: 3,
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
                      Navigator.pop(context); // ปิด dialog
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(
                        MediaQuery.of(context).size.width * 0.25,
                        MediaQuery.of(context).size.height * 0.04,
                      ),
                      backgroundColor: const Color(0xff969696),
                      elevation: 3,
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

  Future<void> insertOrder(List<int> lidArray) async {
    setState(() {
      isLoading = true;
    });
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];

    // แสดง Loading Dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        content: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );

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
          // log('Order placed successfully: ${response.body}');
        } else {
          Navigator.pop(context);
          // log('Failed to place order: ${response.reasonPhrase}');
        }
      } catch (e) {
        Navigator.pop(context);
        // log('Error occurred while placing order: $e');
      }

      // Update Money
      int remainingMoney = userMoney - totalAmount;
      // log('Remaining money to update: $remainingMoney');

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

        // var result = jsonDecode(postmoney.body);
        // log('Server response after money update: ${result['message']}');
      } catch (err) {
        Navigator.pop(context);
        // log(err.toString());
      }

      // Delete lotto
      var res = await http
          .delete(Uri.parse('$url/basket/user/${user.result[0].uid}'));
      if (res.statusCode == 200) {
        // log('Successfully deleted basket: ${res.body}');
      } else {
        Navigator.pop(context);
        // log('Failed to delete basket: ${res.statusCode} - ${res.reasonPhrase}');
      }

      //Insert money
      var data = {
        'm_uid': user.result[0].uid,
        'money': totalAmount,
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
        if (response.statusCode == 201) {
          // การตอบกลับที่สำเร็จ
          Navigator.pop(context);
          //success
          showDialog(
            context: context,
            barrierDismissible: false,
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
                      height: MediaQuery.of(context).size.width * 0.04,
                    ),
                    Center(
                      child: Text(
                        'ซื้อลอตโต้เสร็จสิ้น!',
                        style: TextStyle(
                          fontFamily: 'prompt',
                          fontWeight: FontWeight.w500,
                          fontSize: MediaQuery.of(context).size.width * 0.06,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'คุณได้ชำระเงินสำเร็จแล้ว',
                        style: TextStyle(
                          fontFamily: 'prompt',
                          fontWeight: FontWeight.w400,
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (mounted) {
                              Navigator.pop(context); // ปิด Dialog
                              baskets.clear();
                              setState(() {
                                _isChecked = false;
                                // loadData = loadDataAsync();
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.25,
                              MediaQuery.of(context).size.height * 0.04,
                            ),
                            backgroundColor: const Color(0xff0288d1),
                            elevation: 3,
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
                  ],
                ),
              ),
            ),
          );
          // log('Data inserted successfully: ${response.body}');
        } else {
          Navigator.pop(context);
          // การตอบกลับที่ล้มเหลว
          // log('Failed to insert data: ${response.statusCode} - ${response.reasonPhrase}');
        }
      } catch (e) {
        Navigator.pop(context);
        // ข้อผิดพลาดในกรณีที่เกิด exception
        // log('Error occurred: $e');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      Navigator.pop(context);
      showDialog(
        context: context,
        barrierDismissible: false,
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
                  height: MediaQuery.of(context).size.width * 0.04,
                ),
                Center(
                  child: Text(
                    'ยอดเงินไม่เพียงพอ!',
                    style: TextStyle(
                      fontFamily: 'prompt',
                      fontWeight: FontWeight.w500,
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'ไม่สามารถซื้อลอตโต้ได้',
                    style: TextStyle(
                      fontFamily: 'prompt',
                      fontWeight: FontWeight.w400,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (mounted) {
                          Navigator.pop(context); // ปิด Dialog
                          // setState(() {
                          //   loadData = loadDataAsync();
                          // });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(
                          MediaQuery.of(context).size.width * 0.25,
                          MediaQuery.of(context).size.height * 0.04,
                        ),
                        backgroundColor: const Color(0xff0288d1),
                        elevation: 3,
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
              ],
            ),
          ),
        ),
      );
    }
  }
}
