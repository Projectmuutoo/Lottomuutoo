import 'package:flutter/material.dart';
import 'package:lottotmuutoo/config/config.dart';
import 'package:lottotmuutoo/models/response/jackpotwinGetResponse.dart';
import 'package:lottotmuutoo/pages/widgets/drawer.dart';
import 'package:http/http.dart' as http;

class CheckresultsPage extends StatefulWidget {
  String email = '';
  CheckresultsPage({
    super.key,
    required this.email,
  });

  @override
  State<CheckresultsPage> createState() => _CheckresultsPageState();
}

class _CheckresultsPageState extends State<CheckresultsPage> {
  late Future<void> loadData;
  List jackpotwin = [];

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

    setState(() {
      for (var n in results.result) {
        jackpotwin.add(n.number);
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
        if (widget.email == 'ยังไม่ได้เข้าสู่ระบบ') {
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
                                'ยังไม่ประกาศรางวัล',
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
                                '16 สิงหาคม 2567',
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
            ),
          );
        } else {
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
                                'ประกาศรางวัล',
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
                                '16 สิงหาคม 2567',
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
                  SizedBox(
                    height: height * 0.02,
                  ),
                  if (jackpotwin.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // confirmNumRand();
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
                            "ตรวจผลรางวัล",
                            style: TextStyle(
                              fontFamily: 'prompt',
                              fontWeight: FontWeight.w500,
                              fontSize: width * 0.045,
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  String getJackpotWinNumber(int index) {
    return jackpotwin.isNotEmpty && index < jackpotwin.length
        ? jackpotwin[index]
        : 'XXXXXX';
  }
}
