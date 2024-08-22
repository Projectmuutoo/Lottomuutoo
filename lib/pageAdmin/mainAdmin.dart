import 'dart:convert';
import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottotmuutoo/config/config.dart';
import 'package:lottotmuutoo/models/response/LottoGetResponse.dart';
import 'package:lottotmuutoo/pageAdmin/mainnavbarAdmin.dart';
import 'package:lottotmuutoo/pages/login.dart';
import 'package:http/http.dart' as http;

class MainadminPage extends StatefulWidget {
  String email = '';
  int selectedPage = 0;
  List resultRandAll = [];
  bool acceptNumberJackAll;
  MainadminPage({
    super.key,
    required this.email,
    required this.resultRandAll,
    required this.acceptNumberJackAll,
  });

  @override
  State<MainadminPage> createState() => _MainadminPageState();
}

class _MainadminPageState extends State<MainadminPage> {
  final box = GetStorage();
  late Future<void> loadData;
  final List _resultRand = [];
  final List lottot = [];
  bool hasRandNum = false;
  bool acceptNumber100 = false;
  bool acceptNumberJackSell = false;
  bool acceptNumberJackAll = false;

  @override
  void initState() {
    loadData = loadDataAsync();
    super.initState();
  }

  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];
    var response = await http.get(Uri.parse('$url/lotto'));
    var result = lottoPostReqFromJson(response.body);
    List<LottoPostReqResult> lottots = result.result;
    for (var n in lottots) {
      lottot.add(n.number);
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
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: height * 0.01,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: random100,
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(
                          width * 0.4,
                          height * 0.12,
                        ),
                        backgroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        elevation: 3, //เงาล่าง
                        shadowColor: Colors.black.withOpacity(1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: SvgPicture.string(
                              '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M19 3H5c-1.103 0-2 .897-2 2v14c0 1.103.897 2 2 2h14c1.103 0 2-.897 2-2V5c0-1.103-.897-2-2-2zM5 19V5h14l.002 14H5z"></path><circle cx="8" cy="8" r="1.5"></circle><circle cx="12" cy="12" r="1.5"></circle><circle cx="16" cy="16" r="1.5"></circle></svg>',
                              width: width * 0.1,
                              color: const Color(0xff45a85b),
                            ),
                          ),
                          Text(
                            'สุ่มเลขทั้งหมด\n100 ใบ',
                            style: TextStyle(
                              fontFamily: 'prompt',
                              fontSize: width * 0.045,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    ElevatedButton(
                      onPressed: randomFromAll,
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(
                          width * 0.4,
                          height * 0.12,
                        ),
                        backgroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        elevation: 3, //เงาล่าง
                        shadowColor: Colors.black.withOpacity(1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: SvgPicture.string(
                              '<svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368"><path d="M560-160v-80h104L537-367l57-57 126 126v-102h80v240H560Zm-344 0-56-56 504-504H560v-80h240v240h-80v-104L216-160Zm151-377L160-744l56-56 207 207-56 56Z"/></svg>',
                              width: width * 0.1,
                              color: const Color(0xffeda518),
                            ),
                          ),
                          Text(
                            "สุ่มออกรางวัล\nจากทั้งหมด",
                            style: TextStyle(
                              fontFamily: 'prompt',
                              fontSize: width * 0.045,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: resetSystem,
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(
                          width * 0.4,
                          height * 0.12,
                        ),
                        backgroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        elevation: 3, //เงาล่าง
                        shadowColor: Colors.black.withOpacity(1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: SvgPicture.string(
                              '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M12 16c1.671 0 3-1.331 3-3s-1.329-3-3-3-3 1.331-3 3 1.329 3 3 3z"></path><path d="M20.817 11.186a8.94 8.94 0 0 0-1.355-3.219 9.053 9.053 0 0 0-2.43-2.43 8.95 8.95 0 0 0-3.219-1.355 9.028 9.028 0 0 0-1.838-.18V2L8 5l3.975 3V6.002c.484-.002.968.044 1.435.14a6.961 6.961 0 0 1 2.502 1.053 7.005 7.005 0 0 1 1.892 1.892A6.967 6.967 0 0 1 19 13a7.032 7.032 0 0 1-.55 2.725 7.11 7.11 0 0 1-.644 1.188 7.2 7.2 0 0 1-.858 1.039 7.028 7.028 0 0 1-3.536 1.907 7.13 7.13 0 0 1-2.822 0 6.961 6.961 0 0 1-2.503-1.054 7.002 7.002 0 0 1-1.89-1.89A6.996 6.996 0 0 1 5 13H3a9.02 9.02 0 0 0 1.539 5.034 9.096 9.096 0 0 0 2.428 2.428A8.95 8.95 0 0 0 12 22a9.09 9.09 0 0 0 1.814-.183 9.014 9.014 0 0 0 3.218-1.355 8.886 8.886 0 0 0 1.331-1.099 9.228 9.228 0 0 0 1.1-1.332A8.952 8.952 0 0 0 21 13a9.09 9.09 0 0 0-.183-1.814z"></path></svg>',
                              width: width * 0.1,
                              color: const Color(0xffff0000),
                            ),
                          ),
                          Text(
                            "รีเซตระบบใหม่",
                            style: TextStyle(
                              fontFamily: 'prompt',
                              fontSize: width * 0.045,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    ElevatedButton(
                      onPressed: randomFromSelling,
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(
                          width * 0.4,
                          height * 0.12,
                        ),
                        backgroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        elevation: 3, //เงาล่าง
                        shadowColor: Colors.black.withOpacity(1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: SvgPicture.string(
                              '<svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368"><path d="M480-40q-112 0-206-51T120-227v107H40v-240h240v80h-99q48 72 126.5 116T480-120q75 0 140.5-28.5t114-77q48.5-48.5 77-114T840-480h80q0 91-34.5 171T791-169q-60 60-140 94.5T480-40Zm-36-160v-52q-47-11-76.5-40.5T324-370l66-26q12 41 37.5 61.5T486-314q33 0 56.5-15.5T566-378q0-29-24.5-47T454-466q-59-21-86.5-50T340-592q0-41 28.5-74.5T446-710v-50h70v50q36 3 65.5 29t40.5 61l-64 26q-8-23-26-38.5T482-648q-35 0-53.5 15T410-592q0 26 23 41t83 35q72 26 96 61t24 77q0 29-10 51t-26.5 37.5Q583-274 561-264.5T514-250v50h-70ZM40-480q0-91 34.5-171T169-791q60-60 140-94.5T480-920q112 0 206 51t154 136v-107h80v240H680v-80h99q-48-72-126.5-116T480-840q-75 0-140.5 28.5t-114 77q-48.5 48.5-77 114T120-480H40Z"/></svg>',
                              width: width * 0.1,
                              color: const Color(0xffdfcb14),
                            ),
                          ),
                          Text(
                            "สุ่มออกรางวัลจากที่ขายแล้ว",
                            style: TextStyle(
                              fontFamily: 'prompt',
                              fontSize: width * 0.045,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (acceptNumber100)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ผลจากการสุ่มเลขทั้งหมด',
                  style: TextStyle(
                    fontFamily: 'prompt',
                    fontSize: width * 0.05,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  color: const Color.fromARGB(255, 113, 113, 113),
                  width: width * 0.9,
                  height: height * 0.001,
                ),
              ],
            ),
          if (acceptNumber100)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Wrap(
                      spacing: width * 0.01, // Horizontal spacing
                      runSpacing: height * 0.01, // Vertical spacing
                      children: _resultRand.asMap().entries.map((entry) {
                        int index = entry.key;
                        String numRand = entry.value;
                        return SizedBox(
                          width: width * 0.45, // Column width
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Image.asset(
                                    'assets/images/lottotsmall.png',
                                    width: width * 0.45,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: height * 0.014,
                                    left: width * 0.075,
                                    right: 0,
                                    child: Center(
                                      child: Text(
                                        numRand,
                                        style: TextStyle(
                                          fontSize: width * 0.055,
                                          fontFamily: 'prompt',
                                          fontWeight: FontWeight.w500,
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                          letterSpacing: width * 0.01,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: height * 0.004,
                                    left: width * 0.2,
                                    right: 0,
                                    child: Center(
                                      child: Text(
                                        'ใบที่ ${index + 1}', // Display ticket number
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          fontFamily: 'prompt',
                                          fontWeight: FontWeight.w500,
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          if (!acceptNumber100)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ผลจากการยืนยันเลขหวยทั้งหมด',
                  style: TextStyle(
                    fontFamily: 'prompt',
                    fontSize: width * 0.05,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  color: const Color.fromARGB(255, 113, 113, 113),
                  width: width * 0.9,
                  height: height * 0.001,
                ),
              ],
            ),
          if (!acceptNumber100)
            FutureBuilder(
              future: loadData,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  // กรณีที่ข้อมูลยังไม่ถูกโหลด แสดง CircularProgressIndicator
                  return Container(
                    color: Colors.white,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  if (lottot.isEmpty) {
                    // กรณีที่ไม่มีข้อมูลใน lottot แสดงข้อความหรือวิดเจ็ตอื่นๆ
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: width * 0.2,
                            color: Colors.red,
                          ),
                          SizedBox(height: height * 0.02),
                          Text(
                            'ไม่มีข้อมูลในการแสดงผล',
                            style: TextStyle(
                              fontSize: width * 0.05,
                              fontFamily: 'prompt',
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // กรณีที่มีข้อมูลใน lottot แสดงรายการ
                    return Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Wrap(
                              spacing: width * 0.01, // ช่องว่างแนวนอน
                              runSpacing: height * 0.01, // ช่องว่างแนวตั้ง
                              children: lottot.asMap().entries.map((entry) {
                                int index = entry.key;
                                String numRand = entry.value;

                                return SizedBox(
                                  width:
                                      width * 0.45, // ความกว้างของแต่ละคอลัมน์
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          Image.asset(
                                            'assets/images/lottotsmall.png',
                                            width: width * 0.45,
                                            fit: BoxFit.cover,
                                          ),
                                          Positioned(
                                            top: height * 0.014,
                                            left: width * 0.075,
                                            right: 0,
                                            child: Center(
                                              child: Text(
                                                numRand,
                                                style: TextStyle(
                                                  fontSize: width * 0.055,
                                                  fontFamily: 'prompt',
                                                  fontWeight: FontWeight.w500,
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  letterSpacing: width * 0.01,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: height * 0.004,
                                            left: width * 0.2,
                                            right: 0,
                                            child: Center(
                                              child: Text(
                                                'ใบที่ ${index + 1}', // แสดงหมายเลขใบ
                                                style: TextStyle(
                                                  fontSize: width * 0.04,
                                                  fontFamily: 'prompt',
                                                  fontWeight: FontWeight.w500,
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }
              },
            ),
          if (acceptNumber100)
            ElevatedButton(
              onPressed: () {
                confirmNumRand();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff0288d1), // สีพื้นหลังของปุ่ม
                elevation: 0, // ไม่มีเงา
                shadowColor: Colors.transparent, // สีของเงาเป็นโปร่งใส
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(
                "ยืนยันหวยชุดนี้",
                style: TextStyle(
                  fontFamily: 'prompt',
                  fontWeight: FontWeight.w500,
                  fontSize: MediaQuery.of(context).size.width * 0.042,
                  color:
                      const Color.fromARGB(255, 255, 255, 255), // สีของข้อความ
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> resetSystem() async {
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
                  'ต้องการรีเซ็ตขู้อมูล? \n(หากตกลงข้อมูลทั้งหมดจะถูกลบ)',
                  style: TextStyle(
                    fontFamily: 'prompt',
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      var config = await Configuration.getConfig();
                      var url = config['apiEndpoint'];

                      var response = await http.get(Uri.parse('$url/admin'));
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

  Future<void> randomFromSelling() async {
    hasRandNum = true;
    _resultRand.clear();
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];

    var response = await http.get(Uri.parse('$url/lotto/jackpotsell'));
    var result = lottoPostReqFromJson(response.body);
    List<LottoPostReqResult> numsJack = result.result;
    for (var n in numsJack) {
      _resultRand.add(n.number);
    }
    acceptNumber100 = false;
    acceptNumberJackAll = false;
    acceptNumberJackSell = true;

    setState(() {});
  }

  Future<void> randomFromAll() async {
    if (acceptNumberJackAll) {
      widget.resultRandAll.clear();
      var config = await Configuration.getConfig();
      var url = config['apiEndpoint'];

      var response = await http.get(Uri.parse('$url/lotto/jackpotall'));
      var result = lottoPostReqFromJson(response.body);
      List<LottoPostReqResult> numsJack = result.result;
      for (var n in numsJack) {
        widget.resultRandAll.add(n.number);
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => mainnavbaradminPage(
            email: widget.email,
            selectedPage: 1,
            resultRandAll: widget.resultRandAll,
            hasRandNum: true,
            acceptNumberJackAll: true,
          ),
        ),
      );
      setState(() {});
    } else {
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
                    'ต้องการสุ่มเลขใหม่?',
                    style: TextStyle(
                      fontFamily: 'prompt',
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Text(
                    'หากยืนยันข้อมูลเลขที่ออกจะถูกรีเซ็ตใหม่!',
                    style: TextStyle(
                      fontFamily: 'prompt',
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        acceptNumberJackAll = true;
                        randomFromAll();
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

  void random100() {
    if (acceptNumber100 == false) {
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
                    'ต้องการสุ่มตัวเลขชุดใหม่?',
                    style: TextStyle(
                      fontFamily: 'prompt',
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Text(
                    'ข้อมูลหวยชุดเดิมยังอยู่\nหากท่านไม่ได้ยืนยันตัวเลขชุดใหม่',
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
                      onPressed: () {
                        acceptNumber100 = true;
                        random100();
                        Navigator.pop(context);
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
    } else {
      hasRandNum = true;
      _resultRand.clear();
      for (var i = 0; i < 5; i++) {
        String r = Random().nextInt(999999).toString().padLeft(6, '0');
        _resultRand.add(r);
      }

      setState(() {});
    }
  }

  Future<void> confirmLotto() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];
    var numbers = _resultRand;

    if (acceptNumber100) {
      var response = await http.post(Uri.parse('$url/lotto'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"numbers": numbers}));
    }
    setState(() {
      acceptNumber100 = false;
    });
    Navigator.pop(context);
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
                'assets/images/warning.png',
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
}
