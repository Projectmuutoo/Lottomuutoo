import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottotmuutoo/config/config.dart';
import 'package:lottotmuutoo/models/response/LottoGetResponse.dart';
import 'package:lottotmuutoo/pages/login.dart';
import 'package:lottotmuutoo/pages/widgets/drawer.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  String email = '';
  HomePage({
    super.key,
    required this.email,
  });

  @override
  State<HomePage> createState() => _MainPageState();
}

class _MainPageState extends State<HomePage> {
  String text = 'หวยเด็ดมาแรง!';
  late Future<void> loadData;
  List<String> lottots = [];
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;
  List filteredLottots = [];
  List filteredLottotsGrid = [];
  bool dataLoaded = false;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      6,
      (index) => TextEditingController(),
    );
    focusNodes = List.generate(
      6,
      (index) => FocusNode(),
    );
    loadData = loadDataAsync().then((_) {
      _updateFilteredLottots();
      dataLoaded = true;
    });
  }

  // GPTTTTTTTTTgooooo
  @override
  void dispose() {
    controllers.forEach((controller) => controller.dispose());
    focusNodes.forEach((focusNode) => focusNode.dispose());
    super.dispose();
  }

  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];
    var response = await http.get(Uri.parse('$url/lotto'));
    var results = lottoPostReqFromJson(response.body);
    List<LottoPostReqResult> lottot = results.result;

    // แปลง `List<LottoPostReqResult>` เป็น `List<String>`
    setState(() {
      lottots = lottot.map((item) => item.number.toString()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(
          width,
          width * 0.30,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: height * 0.01,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF29B6F6),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(42),
                bottomRight: Radius.circular(42),
              ),
              boxShadow: [
                BoxShadow(
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: AppBar(
              automaticallyImplyLeading: false,
              shadowColor: Colors.transparent,
              backgroundColor: Colors.transparent,
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
        selectedPage: 0,
      ),
      body: FutureBuilder(
          future: loadData,
          builder: (context, snapshot) {
            if (widget.email == 'ยังไม่ได้เข้าสู่ระบบ') {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: height * 0.02,
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFE6E6E6),
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
                        width: width * 0.95,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.03,
                            vertical: height * 0.01,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: width * 0.02,
                                ),
                                child: Text(
                                  "ค้นหาเลขดัง!",
                                  style: TextStyle(
                                    fontSize: width * 0.055,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'prompt',
                                    color: const Color(0xffE73E3E),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: width * 0.02,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "งวดวันที่ 1 สิงหาคม 2567",
                                      style: TextStyle(
                                        fontSize: width * 0.04,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'prompt',
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        for (var controller in controllers) {
                                          controller.clear();
                                        }
                                        setState(() {});
                                      },
                                      style: TextButton.styleFrom(
                                        overlayColor:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        fixedSize: Size(
                                          width * 0.16,
                                          width * 0.08,
                                        ),
                                      ),
                                      child: Text(
                                        'ล้างค่า',
                                        style: TextStyle(
                                          fontSize: width * 0.045,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'prompt',
                                          decoration: TextDecoration.underline,
                                          decorationColor:
                                              const Color(0xffE73E3E),
                                          decorationThickness: 1,
                                          color: const Color(0xffE73E3E),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              LayoutBuilder(
                                builder: (BuildContext context,
                                    BoxConstraints constraints) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: List.generate(
                                      controllers.length,
                                      (index) => Container(
                                        width: constraints.maxWidth * 0.12,
                                        height: constraints.maxWidth * 0.16,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: const [
                                            BoxShadow(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                            BoxShadow(
                                              color: Color(0xffb8b8b8),
                                              blurRadius: 1,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: TextField(
                                            controller: controllers[index],
                                            focusNode: focusNodes[index],
                                            keyboardType: TextInputType.number,
                                            cursorColor: Colors.transparent,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  1),
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            onChanged: (value) =>
                                                _onChanged(value, index),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.zero,
                                              hintStyle: TextStyle(
                                                fontFamily: 'prompt',
                                                fontWeight: FontWeight.w500,
                                                fontSize:
                                                    constraints.maxWidth * 0.1,
                                                color: const Color.fromARGB(
                                                    162, 0, 0, 0),
                                              ),
                                            ),
                                            style: TextStyle(
                                              fontFamily: 'prompt',
                                              fontSize:
                                                  constraints.maxWidth * 0.1,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: height * 0.02,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        _updateFilteredLottots(randomCount: 1);

                                        setState(() {
                                          if (filteredLottots.isEmpty) {
                                            text = 'ไม่พบลอตโต้!';
                                          } else {
                                            text = 'ผลการสุ่มตัวเลข';
                                          }
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: Size.fromHeight(
                                          height * 0.06,
                                        ),
                                        backgroundColor:
                                            const Color(0xff32abed),
                                        elevation: 3,
                                        shadowColor:
                                            Colors.black.withOpacity(1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: Text(
                                        "สุ่มตัวเลข",
                                        style: TextStyle(
                                          fontFamily: 'prompt',
                                          fontSize: width * 0.045,
                                          fontWeight: FontWeight.w400,
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        _updateFilteredLottots();
                                        setState(() {
                                          filteredLottots.clear();
                                          if (filteredLottotsGrid.isEmpty) {
                                            text = 'ไม่พบลอตโต้!';
                                          } else {
                                            text = 'ผลการค้นหา';
                                          }
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: Size(
                                          width * 0.3,
                                          height * 0.06,
                                        ),
                                        backgroundColor:
                                            const Color(0xff0288d1),
                                        elevation: 3,
                                        shadowColor:
                                            Colors.black.withOpacity(1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: Text(
                                        "ค้นหา",
                                        style: TextStyle(
                                            fontFamily: 'prompt',
                                            fontSize: width * 0.045,
                                            fontWeight: FontWeight.w400,
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: height * 0.008,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              text,
                              style: TextStyle(
                                fontFamily: 'prompt',
                                fontSize: width * 0.05,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //if แยกแสดงผลเฉยๆ
                      if (filteredLottots.isNotEmpty)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: filteredLottots
                                .map(
                                  (number) => Stack(
                                    children: [
                                      InkWell(
                                        onTap: goLogin,
                                        child: Image.asset(
                                          'assets/images/lottot.png',
                                          width: width * 0.95,
                                        ),
                                      ),
                                      Positioned(
                                        top: height * 0.01,
                                        left: width * 0.53,
                                        right: 0,
                                        child: Center(
                                          child: Text(
                                            number,
                                            style: TextStyle(
                                              fontSize: width * 0.07,
                                              fontFamily: 'prompt',
                                              fontWeight: FontWeight.w500,
                                              color: const Color.fromARGB(
                                                  255, 0, 0, 0),
                                              letterSpacing: width * 0.01,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        )
                      // ถ้าหากว่า filteredLottotsGrid ผลการค้นหามีใบเดียว
                      else if (filteredLottotsGrid.length == 1)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: filteredLottotsGrid
                                .map(
                                  (number) => Stack(
                                    children: [
                                      InkWell(
                                        onTap: goLogin,
                                        child: Image.asset(
                                          'assets/images/lottot.png',
                                          width: width * 0.95,
                                        ),
                                      ),
                                      Positioned(
                                        top: height * 0.01,
                                        left: width * 0.53,
                                        right: 0,
                                        child: Center(
                                          child: Text(
                                            number,
                                            style: TextStyle(
                                              fontSize: width * 0.07,
                                              fontFamily: 'prompt',
                                              fontWeight: FontWeight.w500,
                                              color: const Color.fromARGB(
                                                  255, 0, 0, 0),
                                              letterSpacing: width * 0.01,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        )
                      else
                        Column(
                          children: [
                            Wrap(
                              spacing: width * 0.01, // Horizontal spacing
                              runSpacing: height * 0.01, // Vertical spacing
                              children: filteredLottotsGrid.map((number) {
                                return SizedBox(
                                  width: width * 0.45, // Column width
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          InkWell(
                                            onTap: goLogin,
                                            child: Image.asset(
                                              'assets/images/lottotsmallcart.png',
                                              width: width * 0.45,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            top: height * 0.014,
                                            left: width * 0.075,
                                            right: 0,
                                            child: Center(
                                              child: Text(
                                                number,
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
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        )
                    ],
                  ),
                ),
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
                  padding: EdgeInsets.only(
                    top: height * 0.02,
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFE6E6E6),
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
                        width: width * 0.95,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.03,
                            vertical: height * 0.01,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: width * 0.02,
                                ),
                                child: Text(
                                  "ค้นหาเลขดัง!",
                                  style: TextStyle(
                                    fontSize: width * 0.055,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'prompt',
                                    color: const Color(0xffE73E3E),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: width * 0.02,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "งวดวันที่ 1 สิงหาคม 2567",
                                      style: TextStyle(
                                        fontSize: width * 0.04,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'prompt',
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        for (var controller in controllers) {
                                          controller.clear();
                                        }
                                        setState(() {});
                                      },
                                      style: TextButton.styleFrom(
                                        overlayColor:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        fixedSize: Size(
                                          width * 0.16,
                                          width * 0.08,
                                        ),
                                      ),
                                      child: Text(
                                        'ล้างค่า',
                                        style: TextStyle(
                                          fontSize: width * 0.045,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'prompt',
                                          decoration: TextDecoration.underline,
                                          decorationColor:
                                              const Color(0xffE73E3E),
                                          decorationThickness: 1,
                                          color: const Color(0xffE73E3E),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              LayoutBuilder(
                                builder: (BuildContext context,
                                    BoxConstraints constraints) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: List.generate(
                                      controllers.length,
                                      (index) => Container(
                                        width: constraints.maxWidth * 0.12,
                                        height: constraints.maxWidth * 0.16,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: const [
                                            BoxShadow(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                            BoxShadow(
                                              color: Color(0xffb8b8b8),
                                              blurRadius: 1,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: TextField(
                                            controller: controllers[index],
                                            focusNode: focusNodes[index],
                                            keyboardType: TextInputType.number,
                                            cursorColor: Colors.transparent,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  1),
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            onChanged: (value) =>
                                                _onChanged(value, index),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.zero,
                                              hintStyle: TextStyle(
                                                fontFamily: 'prompt',
                                                fontWeight: FontWeight.w500,
                                                fontSize:
                                                    constraints.maxWidth * 0.1,
                                                color: const Color.fromARGB(
                                                    162, 0, 0, 0),
                                              ),
                                            ),
                                            style: TextStyle(
                                              fontFamily: 'prompt',
                                              fontSize:
                                                  constraints.maxWidth * 0.1,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: height * 0.02,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        _updateFilteredLottots(randomCount: 1);

                                        setState(() {
                                          if (filteredLottots.isEmpty) {
                                            text = 'ไม่พบลอตโต้!';
                                          } else {
                                            text = 'ผลการสุ่มตัวเลข';
                                          }
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: Size.fromHeight(
                                          height * 0.06,
                                        ),
                                        backgroundColor:
                                            const Color(0xff32abed),
                                        elevation: 3,
                                        shadowColor:
                                            Colors.black.withOpacity(1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: Text(
                                        "สุ่มตัวเลข",
                                        style: TextStyle(
                                          fontFamily: 'prompt',
                                          fontSize: width * 0.045,
                                          fontWeight: FontWeight.w400,
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        _updateFilteredLottots();
                                        setState(() {
                                          filteredLottots.clear();
                                          if (filteredLottotsGrid.isEmpty) {
                                            text = 'ไม่พบลอตโต้!';
                                          } else {
                                            text = 'ผลการค้นหา';
                                          }
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: Size(
                                          width * 0.3,
                                          height * 0.06,
                                        ),
                                        backgroundColor:
                                            const Color(0xff0288d1),
                                        elevation: 3,
                                        shadowColor:
                                            Colors.black.withOpacity(1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: Text(
                                        "ค้นหา",
                                        style: TextStyle(
                                            fontFamily: 'prompt',
                                            fontSize: width * 0.045,
                                            fontWeight: FontWeight.w400,
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: height * 0.008,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              text,
                              style: TextStyle(
                                fontFamily: 'prompt',
                                fontSize: width * 0.05,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //if แยกแสดงผลเฉยๆ
                      if (filteredLottots.isNotEmpty)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: filteredLottots
                                .map(
                                  (number) => Stack(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          print(number);
                                        },
                                        child: Image.asset(
                                          'assets/images/lottot.png',
                                          width: width * 0.95,
                                        ),
                                      ),
                                      Positioned(
                                        top: height * 0.01,
                                        left: width * 0.53,
                                        right: 0,
                                        child: Center(
                                          child: Text(
                                            number,
                                            style: TextStyle(
                                              fontSize: width * 0.07,
                                              fontFamily: 'prompt',
                                              fontWeight: FontWeight.w500,
                                              color: const Color.fromARGB(
                                                  255, 0, 0, 0),
                                              letterSpacing: width * 0.01,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        )
                      // ถ้าหากว่า filteredLottotsGrid ผลการค้นหามีใบเดียว
                      else if (filteredLottotsGrid.length == 1)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: filteredLottotsGrid
                                .map(
                                  (number) => Stack(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          print(number);
                                        },
                                        child: Image.asset(
                                          'assets/images/lottot.png',
                                          width: width * 0.95,
                                        ),
                                      ),
                                      Positioned(
                                        top: height * 0.01,
                                        left: width * 0.53,
                                        right: 0,
                                        child: Center(
                                          child: Text(
                                            number,
                                            style: TextStyle(
                                              fontSize: width * 0.07,
                                              fontFamily: 'prompt',
                                              fontWeight: FontWeight.w500,
                                              color: const Color.fromARGB(
                                                  255, 0, 0, 0),
                                              letterSpacing: width * 0.01,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        )
                      else
                        Column(
                          children: [
                            Wrap(
                              spacing: width * 0.01, // Horizontal spacing
                              runSpacing: height * 0.01, // Vertical spacing
                              children: filteredLottotsGrid.map((number) {
                                return SizedBox(
                                  width: width * 0.45, // Column width
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              print(number);
                                            },
                                            child: Image.asset(
                                              'assets/images/lottotsmallcart.png',
                                              width: width * 0.45,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            top: height * 0.014,
                                            left: width * 0.075,
                                            right: 0,
                                            child: Center(
                                              child: Text(
                                                number,
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
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        )
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }

  List<String> getRandomElements(List<String> list, int n) {
    list.shuffle(); // สุ่มลำดับของรายการ
    return list.take(n).toList(); // ดึงข้อมูลตามจำนวนที่ต้องการ
  }

  void _updateFilteredLottots({int? randomCount}) {
    List<String?> filters = controllers
        .map(
            (controller) => controller.text.isNotEmpty ? controller.text : null)
        .toList();
    if (randomCount != null) {
      // สุ่มตัวเลขตามจำนวนที่ระบุ
      filteredLottots = getRandomElements(lottots, randomCount);
    } else if (filters.every((filter) => filter == null)) {
      // แสดงรายการสุ่มเมื่อยังไม่มีการป้อนข้อมูล
      filteredLottots = lottots.take(10).toList();
    } else {
      filteredLottotsGrid = filterData(lottots, filters);
    }

    setState(() {});
  }

  // ฟังก์ชันเพื่อกรองข้อมูล
  List<String> filterData(List<String> data, List<String?> filters) {
    if (filters.isEmpty) return data;

    return data.where((number) {
      // ตรวจสอบว่าข้อมูลที่ป้อนมีความยาวอย่างน้อยเท่ากับจำนวนหลักที่กำลังตรวจสอบ
      for (int i = 0; i < filters.length; i++) {
        if (filters[i] != null) {
          if (number.length >= filters.length - i &&
              number[number.length - (filters.length - i)] != filters[i]) {
            return false;
          }
        }
      }
      return true;
    }).toList();
  }

  void _onChanged(String value, int index) {
    if (value.length == 1) {
      if (index < controllers.length - 1) {
        FocusScope.of(context).requestFocus(focusNodes[index + 1]);
      } else {
        // Handle the logic for the last field if needed
        // For example, you might want to update some state here
      }
    }
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
                'assets/images/warning.png',
                width: MediaQuery.of(context).size.width * 0.16,
                height: MediaQuery.of(context).size.width * 0.16,
                fit: BoxFit.cover,
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.04),
              Center(
                child: Text(
                  'เข้าสู่ระบบ?',
                  style: TextStyle(
                    fontFamily: 'prompt',
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                  ),
                ),
              ),
              Center(
                child: Text(
                  'คุณต้องเข้าสู่ระบบก่อน!',
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
