import 'dart:convert';
import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottotmuutoo/config/config.dart';
import 'package:lottotmuutoo/models/response/LottoGetResponse.dart';
import 'package:lottotmuutoo/pages/login.dart';
import 'package:http/http.dart' as http;

class MainadminPage extends StatefulWidget {
  String email = '';
  MainadminPage({super.key, required this.email});

  @override
  State<MainadminPage> createState() => _MainadminPageState();
}

class _MainadminPageState extends State<MainadminPage> {
  final box = GetStorage();
  final List _resultRand = [];
  bool hasRandNum = false;
  bool acceptNumber100 = false;
  bool acceptNumberJackSell = false;
  bool acceptNumberJackAll = false;

  @override
  void initState() {
    super.initState();
    // _initializeStorage();
  }

  void _initializeStorage() {
    var loginStatus = box.read('login');
    var storedEmail = box.read('email');

    if (loginStatus != false) {
      setState(() {
        widget.email = storedEmail;
      });
    } else {
      setState(() {
        widget.email = 'ยังไม่ได้เข้าสู่ระบบ';
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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(
          width,
          width * 0.25, //////////////
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: height * 0.02,
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainadminPage(
                              email: widget.email,
                            ),
                          ),
                        );
                      },
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: width * 0.2,
                        fit: BoxFit.cover,
                        color: Colors.white,
                      ),
                    ),
                    Builder(
                      builder: (BuildContext context) {
                        return InkWell(
                          onTap: () {
                            widget.email = 'ยังไม่ได้เข้าสู่ระบบ';
                            box.write('login', false);
                            box.write('email', 'ยังไม่ได้เข้าสู่ระบบ');
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
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            onPressed: random100,
                            child: const Text('สุ่มเลขทั้งหมด 100 ใบ',
                                textAlign: TextAlign.center)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            onPressed: randomFromAll,
                            child: const Text('สุ่มรางวัลจากเลขทั้งหมด',
                                textAlign: TextAlign.center)),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            onPressed: resetSystem,
                            child: const Text('รีเซ็ตระบบใหม่',
                                textAlign: TextAlign.center)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            onPressed: randomFromSelling,
                            child: const Text('สุ่มรางวัลจากเลขที่ขายแล้ว',
                                textAlign: TextAlign.center)),
                      ),
                    )
                  ],
                ),
              ],
            ),
            Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ผลจากการสุ่ม',
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                ),
                if (hasRandNum)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: confirmNumRand,
                        child: const Text('TEST'),
                      ),
                    ],
                  ),
              ],
            ),
            if (_resultRand.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: _resultRand.map((numRand) {
                      return Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Image.asset(
                                  'assets/images/lottot.jpg',
                                  width: width * 0.95,
                                  fit: BoxFit.cover,
                                ),
                                Positioned.fill(
                                    child: Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 20.5),
                                    child: Text(
                                      "$numRand",
                                      style: const TextStyle(
                                          fontSize: 35,
                                          backgroundColor: Color.fromARGB(
                                              255, 251, 250, 217)),
                                    ),
                                  ),
                                )),
                              ],
                            ),
                          )
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            if (_resultRand.isEmpty)
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No result',
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  )
                ],
              )
          ],
        ),
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
    // log(response.body);
    var result = lottoPostReqFromJson(response.body);
    List<LottoPostReqResult> numsJack = result.result;
    for (var n in numsJack) {
      _resultRand.add(n.number);
      // log(n.number);
    }
    acceptNumber100 = false;
    acceptNumberJackAll = false;
    acceptNumberJackSell = true;
    setState(() {});
  }

  Future<void> randomFromAll() async {
    hasRandNum = true;
    _resultRand.clear();
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];

    var response = await http.get(Uri.parse('$url/lotto/jackpotall'));
    // log(response.body);
    var result = lottoPostReqFromJson(response.body);
    List<LottoPostReqResult> numsJack = result.result;
    for (var n in numsJack) {
      _resultRand.add(n.number);
      // log(n.number);
    }
    acceptNumber100 = false;
    acceptNumberJackAll = true;
    acceptNumberJackSell = false;
    setState(() {});
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

  Future<void> confirmLotto() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];
    var numbers = _resultRand;

    if (acceptNumber100) {
      var response = await http.post(Uri.parse('$url/lotto'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"numbers": numbers}));
      // log(response.body);
    } else if (acceptNumberJackAll) {
      var response = await http.put(Uri.parse('$url/lotto/jackpotall'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"numbers": numbers}));
      // log(response.body);
    } else if (acceptNumberJackSell) {
      var response = await http.put(Uri.parse('$url/lotto/jackpotsell'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"numbers": numbers}));
      // log(response.body);
    }
    Navigator.pop(context);
  }

  void random100() {
    hasRandNum = true;
    _resultRand.clear();
    for (var i = 0; i < 10; i++) {
      String r = Random().nextInt(999999).toString().padLeft(6, '0');
      _resultRand.add(r);
    }
    acceptNumber100 = true;
    acceptNumberJackAll = false;
    acceptNumberJackSell = false;
    setState(() {});
  }
}
