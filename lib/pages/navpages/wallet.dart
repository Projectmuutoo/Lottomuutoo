import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottotmuutoo/models/response/GetMoneyUidResponse.dart';
import 'package:lottotmuutoo/models/response/UserGetEmailResponse.dart';
import 'package:lottotmuutoo/pages/login.dart';
import 'package:lottotmuutoo/pages/widgets/drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lottotmuutoo/config/config.dart';
import 'package:http/http.dart' as http;

class WalletPage extends StatefulWidget {
  String email = '';
  WalletPage({
    super.key,
    required this.email,
  });

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  late Future<void> loadData;
  UserEmailGetRespone? user;
  List<GetMoneyUid> moneys = [];
  List<Result> results = [];
  final TextEditingController _amountController = TextEditingController();
  final box = GetStorage();
  bool isTyping = false;
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
        selectedPage: 3,
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
                horizontal: width * 0.03,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: height * 0.012,
                    ),
                    child: Text(
                      'ยอดเงินในบัญชีลอตโต้',
                      style: TextStyle(
                        fontSize: width * 0.07,
                        fontFamily: 'prompt',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF29b6f6), // สีพื้นหลัง
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: height * 0.01,
                            left: width * 0.04,
                            right: width * 0.04,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                results.isNotEmpty
                                    ? results[0].name
                                    : 'No Name',
                                style: TextStyle(
                                  fontSize: width * 0.06,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'prompt',
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                              Text(
                                results.isNotEmpty
                                    ? '${results[0].uid}'
                                    : 'No Uid',
                                style: TextStyle(
                                  fontSize: width * 0.04,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'prompt',
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.04,
                          ),
                          child: Text(
                            'ยอดเงินคงเหลือ (บาท)',
                            style: TextStyle(
                              fontSize: width * 0.035,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'prompt',
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.04,
                          ),
                          child: Text(
                            results.isNotEmpty
                                ? '${results[0].money}.00 บาท'
                                : 'No money',
                            style: TextStyle(
                              fontSize: width * 0.06,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'prompt',
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: height * 0.006,
                          ),
                          child: Container(
                            height: height * 0.001,
                            width: width,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.04,
                            right: width * 0.04,
                            bottom: height * 0.01,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'ยอดเงินที่ใช้ได้ (บาท)',
                                style: TextStyle(
                                  fontSize: width * 0.035,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'prompt',
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                              Text(
                                results.isNotEmpty
                                    ? '${results[0].money}.00'
                                    : 'No money',
                                style: TextStyle(
                                  fontSize: width * 0.04,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'prompt',
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.012,
                  ),
                  Container(
                    width: width * 0.95,
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.02,
                      vertical: height * 0.004,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffe6e6e6),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: const [
                        BoxShadow(
                          spreadRadius: 0,
                          blurRadius: 2,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            depositOrwithdrawMoney(true);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 3,
                            backgroundColor: const Color(0xff0288d1),
                            shadowColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            fixedSize: Size.fromHeight(
                              height * 0.05,
                            ),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.string(
                                '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);"><path d="M16 12h2v4h-2z"></path><path d="M20 7V5c0-1.103-.897-2-2-2H5C3.346 3 2 4.346 2 6v12c0 2.201 1.794 3 3 3h15c1.103 0 2-.897 2-2V9c0-1.103-.897-2-2-2zM5 5h13v2H5a1.001 1.001 0 0 1 0-2zm15 14H5.012C4.55 18.988 4 18.805 4 18V8.815c.314.113.647.185 1 .185h15v10z"></path></svg>',
                                width: width * 0.035,
                                height: height * 0.035,
                                fit: BoxFit.cover,
                                color: Colors.white,
                              ),
                              SizedBox(width: width * 0.01),
                              Text(
                                'เติมเงิน',
                                style: TextStyle(
                                  fontSize: width * 0.04,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'prompt',
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            depositOrwithdrawMoney(false);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 3,
                            backgroundColor: const Color(0xff0288d1),
                            shadowColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            fixedSize: Size.fromHeight(
                              height * 0.05,
                            ),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.string(
                                '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);"><path d="M12 15c-1.84 0-2-.86-2-1H8c0 .92.66 2.55 3 2.92V18h2v-1.08c2-.34 3-1.63 3-2.92 0-1.12-.52-3-4-3-2 0-2-.63-2-1s.7-1 2-1 1.39.64 1.4 1h2A3 3 0 0 0 13 7.12V6h-2v1.09C9 7.42 8 8.71 8 10c0 1.12.52 3 4 3 2 0 2 .68 2 1s-.62 1-2 1z"></path><path d="M5 2H2v2h2v17a1 1 0 0 0 1 1h14a1 1 0 0 0 1-1V4h2V2H5zm13 18H6V4h12z"></path></svg>',
                                width: width * 0.035,
                                height: height * 0.035,
                                fit: BoxFit.cover,
                                color: Colors.white,
                              ),
                              SizedBox(width: width * 0.01),
                              Text(
                                'ถอนเงิน',
                                style: TextStyle(
                                  fontSize: width * 0.04,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'prompt',
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.012,
                  ),
                  Container(
                    width: width * 0.95,
                    padding: EdgeInsets.only(
                      left: width * 0.03,
                      right: width * 0.03,
                      top: height * 0.016,
                      bottom: height * 0.006,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xffe6e6e6),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ประวัติการทำรายการ',
                          style: TextStyle(
                            fontSize: width * 0.045,
                            fontFamily: 'prompt',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        color: const Color(0xffe6e6e6),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.02,
                            vertical: height * 0.004,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: moneys.map((money) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: height * 0.006,
                                ),
                                child: Container(
                                  width: double
                                      .infinity, // Ensures the container takes up full width
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.02,
                                    vertical: height * 0.008,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffd9d9d9),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
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
                                          SvgPicture.string(
                                            _getIconForType(money.type),
                                            width: width * 0.03,
                                            height: height * 0.03,
                                          ),
                                          SizedBox(width: width * 0.016),
                                          Text(
                                            _getStatusMessage(
                                              money.type,
                                            ),
                                            style: TextStyle(
                                              fontFamily: 'prompt',
                                              fontSize: width * 0.036,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            _getStatusMessage(
                                              money.type,
                                            ),
                                            style: TextStyle(
                                              fontFamily: 'prompt',
                                              fontSize: width * 0.035,
                                              fontWeight: FontWeight.w500,
                                              color: money.type == 0
                                                  ? const Color(0xff3faa2e)
                                                  : const Color(0xffe73e3e),
                                            ),
                                          ),
                                          Text(
                                            formatDate(money.date.toString()),
                                            style: TextStyle(
                                              fontFamily: 'prompt',
                                              fontSize: width * 0.03,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
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
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void depositOrwithdrawMoney(bool isDeposit) {
    if (isDeposit) {
      // Logic for depositing money
      showDialogMoney(true);
      // print('เติมเงิน');
    } else {
      // Logic for withdrawing money
      showDialogMoney(false);
      // print('ถอนเงิน');
    }
  }

  void showDialogMoney(bool isDeposit) {
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
              Center(
                child: Text(
                  isDeposit ? 'เติมเงิน' : 'ถอนเงิน',
                  style: TextStyle(
                    fontFamily: 'prompt',
                    fontSize: MediaQuery.of(context).size.width * 0.065,
                  ),
                ),
              ),
              Center(
                child: Text(
                  isDeposit
                      ? 'ป้อนจำนวนเงินที่ต้องการเติมเงิน'
                      : 'ป้อนจำนวนเงินที่ต้องการถอนเงิน',
                  style: TextStyle(
                    fontFamily: 'prompt',
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                  ),
                ),
              ),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                cursorColor: const Color.fromARGB(255, 0, 0, 0),
                decoration: InputDecoration(
                  hintText: isTyping ? '' : 'ป้อนจำนวนที่ต้องการ',
                  hintStyle: TextStyle(
                    fontFamily: 'prompt',
                    fontWeight: FontWeight.w400,
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    color: const Color.fromARGB(163, 158, 158, 158),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.04,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(width: 1),
                  ),
                ),
                style: TextStyle(
                  fontFamily: 'prompt',
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      String amount = _amountController.text;
                      if (results.isNotEmpty &&
                          amount != '0' &&
                          amount.isNotEmpty &&
                          RegExp(r'^\d+$').hasMatch(amount)) {
                        updateMoney(isDeposit, amount, widget.email, results);
                        Navigator.pop(context);
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.transparent,
                            content: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.03,
                                vertical:
                                    MediaQuery.of(context).size.height * 0.02,
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
                                    width: MediaQuery.of(context).size.width *
                                        0.16,
                                    height: MediaQuery.of(context).size.width *
                                        0.16,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.04),
                                  Center(
                                    child: Text(
                                      'ไม่สามารถทำรายการได้!',
                                      style: TextStyle(
                                        fontFamily: 'prompt',
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      'โปรดทำรายการใหม่อีกครั้ง.',
                                      style: TextStyle(
                                        fontFamily: 'prompt',
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.04,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.02),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                            MediaQuery.of(context).size.height *
                                                0.04,
                                          ),
                                          backgroundColor:
                                              const Color(0xff0288d1),
                                          elevation: 3, //เงาล่าง
                                          shadowColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                          ),
                                        ),
                                        child: Text(
                                          "ตกลง",
                                          style: TextStyle(
                                            fontFamily: 'prompt',
                                            fontWeight: FontWeight.w500,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.042,
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
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
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(
                        MediaQuery.of(context).size.width * 0.25,
                        MediaQuery.of(context).size.height * 0.04,
                      ),
                      backgroundColor: const Color(0xff0288d1),
                      elevation: 3, // Shadow
                      shadowColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      "ยืนยัน",
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
                      elevation: 3, // Shadow
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

  Future<void> updateMoney(
      bool isDeposit, String amount, String email, List<Result> results) async {
    setState(() {
      isLoading = true;
    });
    final double parsedAmount = double.tryParse(amount) ?? 0.0;
    List<int> uid = results.map((result) => result.uid).toList();
    if (isDeposit) {
      //เติมเงินเด๋อ
      double totalMoney =
          results.fold(0.0, (sum, result) => sum + result.money) + parsedAmount;
      var putbody = {"email": email, "money": totalMoney};
      var postbody = {"m_uid": uid, "money": parsedAmount, "type": 0};
      // log('Depositing $parsedAmount for email: $email for money $uid');
      try {
        var config = await Configuration.getConfig();
        var url = config['apiEndpoint'];
        var response = await http.put(
          Uri.parse('$url/user/money'),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: jsonEncode(putbody),
        );
        if (response.statusCode == 200) {
          //loading
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    if (isLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  ],
                ),
              ),
            ),
          );
          var postmoney = await http.post(
            Uri.parse('$url/money/add'),
            headers: {"Content-Type": "application/json; charset=utf-8"},
            body: jsonEncode(postbody),
          );
          Navigator.pop(context);
          if (postmoney.statusCode == 201) {
            // แสดง Success Dialog
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
                          'เติมเงินสำเร็จ!',
                          style: TextStyle(
                            fontFamily: 'prompt',
                            fontWeight: FontWeight.w500,
                            fontSize: MediaQuery.of(context).size.width * 0.06,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'คุณได้เติมเงิน $amount บาท',
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
                                setState(() {
                                  loadData = loadDataAsync();
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
          }
        }
        // log(response.body);
      } catch (e) {
        log('show dialog');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      //ถอนเงินเด้อ
      // log('Withdrawing $parsedAmount for email: $email');
      double totalMoney =
          results.fold(0.0, (sum, result) => sum + result.money) - parsedAmount;
      var putbody = {"email": email, "money": totalMoney};
      var postbody = {"m_uid": uid, "money": parsedAmount, "type": 1};
      // log('Withdrawing $parsedAmount for email: $email for money $totalMoney');
      try {
        var config = await Configuration.getConfig();
        var url = config['apiEndpoint'];
        var response = await http.put(
          Uri.parse('$url/user/money'),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: jsonEncode(putbody),
        );
        if (response.statusCode == 200) {
          //loading
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    if (isLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  ],
                ),
              ),
            ),
          );
          var postmoney = await http.post(
            Uri.parse('$url/money/add'),
            headers: {"Content-Type": "application/json; charset=utf-8"},
            body: jsonEncode(postbody),
          );
          Navigator.pop(context);
          if (postmoney.statusCode == 201) {
            // แสดง Success Dialog
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
                          'ถอนเงินสำเร็จ!',
                          style: TextStyle(
                            fontFamily: 'prompt',
                            fontWeight: FontWeight.w500,
                            fontSize: MediaQuery.of(context).size.width * 0.06,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'คุณได้ถอนเงิน $amount บาท',
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
                                setState(() {
                                  loadData = loadDataAsync();
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
          }
        }
        // log('${response.body} and ${postmoney.body}');
      } catch (e) {
        log('show dialog');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> loadDataAsync() async {
    try {
      var config = await Configuration.getConfig();
      var url = config['apiEndpoint'];
      var getuser = await http.get(Uri.parse('$url/user/${widget.email}'));
      if (getuser.statusCode == 200) {
        user = userEmailGetResponeFromJson(getuser.body);
        results = user?.result ?? [];
        var getmoney =
            await http.get(Uri.parse('$url/money/${results[0].uid}'));
        if (getmoney.statusCode == 200) {
          moneys = getMoneyUidFromJson(getmoney.body);
          // log(getmoney.body);
        }
      }
    } catch (e) {
      log('Error loading data: $e');
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
}

String _getStatusMessage(int? type) {
  if (type == 0) {
    return 'เติมเงิน';
  } else if (type == 1) {
    return 'ถอนเงิน';
  } else if (type == 2) {
    return 'ซื้อหวย';
  } else {
    return 'ไม่ทราบสถานะ'; // Unknown status
  }
}

String _getIconForType(int? type) {
  switch (type) {
    case 0:
      return '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);"><path d="M16 12h2v4h-2z"></path><path d="M20 7V5c0-1.103-.897-2-2-2H5C3.346 3 2 4.346 2 6v12c0 2.201 1.794 3 3 3h15c1.103 0 2-.897 2-2V9c0-1.103-.897-2-2-2zM5 5h13v2H5a1.001 1.001 0 0 1 0-2zm15 14H5.012C4.55 18.988 4 18.805 4 18V8.815c.314.113.647.185 1 .185h15v10z"></path></svg>';
    case 1:
      return '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);"><path d="M12 15c-1.84 0-2-.86-2-1H8c0 .92.66 2.55 3 2.92V18h2v-1.08c2-.34 3-1.63 3-2.92 0-1.12-.52-3-4-3-2 0-2-.63-2-1s.7-1 2-1 1.39.64 1.4 1h2A3 3 0 0 0 13 7.12V6h-2v1.09C9 7.42 8 8.71 8 10c0 1.12.52 3 4 3 2 0 2 .68 2 1s-.62 1-2 1z"></path><path d="M5 2H2v2h2v17a1 1 0 0 0 1 1h14a1 1 0 0 0 1-1V4h2V2H5zm13 18H6V4h12z"></path></svg>';
    case 2:
      return '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-1 17.93c-4.07-.5-7.43-3.86-7.93-7.93H11v7.93zm0-9.93H4.07c.5-4.07 3.86-7.43 7.93-7.93V10zm2-7.93c4.07.5 7.43 3.86 7.93 7.93H13V2.07zm0 15.86V13h7.93c-.5 4.07-3.86 7.43-7.93 7.93z"></path></svg>';
    default:
      return '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);"><path d="M12 15c-1.84 0-2-.86-2-1H8c0 .92.66 2.55 3 2.92V18h2v-1.08c2-.34 3-1.63 3-2.92 0-1.12-.52-3-4-3-2 0-2-.63-2-1s.7-1 2-1 1.39.64 1.4 1h2A3 3 0 0 0 13 7.12V6h-2v1.09C9 7.42 8 8.71 8 10c0 1.12.52 3 4 3 2 0 2 .68 2 1s-.62 1-2 1z"></path><path d="M5 2H2v2h2v17a1 1 0 0 0 1 1h14a1 1 0 0 0 1-1V4h2V2H5zm13 18H6V4h12z"></path></svg>';
  }
}
