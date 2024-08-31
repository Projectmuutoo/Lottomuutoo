import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottotmuutoo/config/config.dart';
import 'package:lottotmuutoo/models/request/addToCartPostRequest.dart';
import 'package:lottotmuutoo/models/response/BasketUserResponse.dart';
import 'package:lottotmuutoo/models/response/LottoGetResponse.dart';
import 'package:lottotmuutoo/models/response/UserIdxGetResponse.dart';
import 'package:lottotmuutoo/models/response/addToCartPostResponse.dart';
import 'package:lottotmuutoo/models/response/jackpotwinGetResponse.dart';
import 'package:lottotmuutoo/pages/login.dart';
import 'package:lottotmuutoo/pages/widgets/drawer.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  String email = '';
  final StreamController<int> basketCountController;

  HomePage({
    Key? key,
    required this.email,
    required this.basketCountController,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _MainPageState();
}

class _MainPageState extends State<HomePage> {
  final box = GetStorage();
  String text = 'ลอตโต้มาแรง!';
  late Future<void> loadData;
  List<String> lottots = [];
  List<String> lottotsSell = [];
  List<LottoPostReqResult> lottot = [];
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;
  List filteredLottots = [];
  List filteredLottotsGrid = [];
  bool isLoading = false;
  late BasketUserResponse basket;
  List<String> baskets = [];
  late JackpotwinGetResponse resultststus;

  @override
  void initState() {
    super.initState();

    controllers = List.generate(6, (index) => TextEditingController());
    focusNodes = List.generate(6, (index) => FocusNode());

    if (box.read('login') == true) {
      loadData = loadDataAsync().then((_) {
        _updateFilteredLottots();
      });
      setState(() {
        widget.email = box.read('email');
      });
    } else {
      loadData = loadDataAsyncNoLogin().then((_) {
        _updateFilteredLottots();
      });
    }
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
    var userResponse = await http.get(Uri.parse('$url/user/${widget.email}'));
    var user = userIdxGetResponseFromJson(userResponse.body);
    var basketRes =
        await http.get(Uri.parse('$url/basket/${user.result[0].uid}'));
    basket = basketUserResponseFromJson(basketRes.body);

    var response1 = await http.get(Uri.parse('$url/lotto/jackpotwin'));
    resultststus = jackpotwinGetResponseFromJson(response1.body);
    lottot = results.result;
    setState(() {
      widget.basketCountController.add(basket.result.length);
      lottots = lottot.map((item) => item.toString()).toList();
      for (var i in basket.result) {
        baskets.add(i.number);
      }
    });
  }

  Future<void> loadDataAsyncNoLogin() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];
    var response = await http.get(Uri.parse('$url/lotto'));
    var results = lottoPostReqFromJson(response.body);
    var response1 = await http.get(Uri.parse('$url/lotto/jackpotwin'));
    resultststus = jackpotwinGetResponseFromJson(response1.body);
    lottot = results.result;
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
            if (snapshot.connectionState != ConnectionState.done) {
              return Container(
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (widget.email == 'ยังไม่ได้เข้าสู่ระบบ') {
              if (resultststus.result.isNotEmpty) {
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
                                        "งวดวันที่ ${formatCurrentDate()}",
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'prompt',
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          for (var controller in controllers) {
                                            controller.clear();
                                          }
                                          if (mounted) {
                                            setState(() {});
                                          }
                                        },
                                        style: TextButton.styleFrom(
                                          overlayColor: const Color.fromARGB(
                                              255, 0, 0, 0),
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
                                            decoration:
                                                TextDecoration.underline,
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
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
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
                                              keyboardType:
                                                  TextInputType.number,
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
                                                      constraints.maxWidth *
                                                          0.1,
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
                                          _updateFilteredLottots(
                                              randomCount: 1);
                                          if (mounted) {
                                            setState(() {
                                              if (filteredLottots.isEmpty) {
                                                text = 'ไม่พบลอตโต้!';
                                              } else {
                                                text = 'ผลการสุ่มตัวเลข';
                                              }
                                            });
                                          }
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
                                          if (mounted) {
                                            setState(() {
                                              filteredLottots.clear();
                                              if (filteredLottotsGrid.isEmpty) {
                                                text = 'ไม่พบลอตโต้!';
                                              } else {
                                                text = 'ผลการค้นหา';
                                              }
                                            });
                                          }
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
                        if (filteredLottots.isNotEmpty)
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: filteredLottots
                                  .map(
                                    (number) => Stack(
                                      children: [
                                        Stack(
                                          children: [
                                            ImageFiltered(
                                              imageFilter: ImageFilter.blur(
                                                sigmaX: 2,
                                                sigmaY: 2,
                                              ),
                                              child: ColorFiltered(
                                                colorFilter: ColorFilter.mode(
                                                  Colors.black.withOpacity(0.3),
                                                  BlendMode.srcATop,
                                                ),
                                                child: Image.asset(
                                                  'assets/images/lottot.png',
                                                  width: width * 0.95,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              left: 0,
                                              bottom: 0,
                                              child: Center(
                                                child: SvgPicture.string(
                                                  '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M21 4H3a1 1 0 0 0-1 1v14a1 1 0 0 0 1 1h18a1 1 0 0 0 1-1V5a1 1 0 0 0-1-1zm-1 11a3 3 0 0 0-3 3H7a3 3 0 0 0-3-3V9a3 3 0 0 0 3-3h10a3 3 0 0 0 3 3v6z"></path><path d="M12 8c-2.206 0-4 1.794-4 4s1.794 4 4 4 4-1.794 4-4-1.794-4-4-4zm0 6c-1.103 0-2-.897-2-2s.897-2 2-2 2 .897 2 2-.897 2-2 2z"></path></svg>',
                                                  width: width * 0.1,
                                                  height: height * 0.1,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Positioned(
                                          top: height * 0.01,
                                          left: width * 0.53,
                                          right: 0,
                                          child: Center(
                                              child: ImageFiltered(
                                            imageFilter: ImageFilter.blur(
                                              sigmaX: 3,
                                              sigmaY: 3,
                                            ),
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
                                          )),
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
                                        Stack(
                                          children: [
                                            ImageFiltered(
                                              imageFilter: ImageFilter.blur(
                                                sigmaX: 2,
                                                sigmaY: 2,
                                              ),
                                              child: ColorFiltered(
                                                colorFilter: ColorFilter.mode(
                                                  Colors.black.withOpacity(0.3),
                                                  BlendMode.srcATop,
                                                ),
                                                child: Image.asset(
                                                  'assets/images/lottot.png',
                                                  width: width * 0.95,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              left: 0,
                                              bottom: 0,
                                              child: Center(
                                                child: SvgPicture.string(
                                                  '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M21 4H3a1 1 0 0 0-1 1v14a1 1 0 0 0 1 1h18a1 1 0 0 0 1-1V5a1 1 0 0 0-1-1zm-1 11a3 3 0 0 0-3 3H7a3 3 0 0 0-3-3V9a3 3 0 0 0 3-3h10a3 3 0 0 0 3 3v6z"></path><path d="M12 8c-2.206 0-4 1.794-4 4s1.794 4 4 4 4-1.794 4-4-1.794-4-4-4zm0 6c-1.103 0-2-.897-2-2s.897-2 2-2 2 .897 2 2-.897 2-2 2z"></path></svg>',
                                                  width: width * 0.1,
                                                  height: height * 0.1,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Positioned(
                                          top: height * 0.01,
                                          left: width * 0.53,
                                          right: 0,
                                          child: Center(
                                            child: ImageFiltered(
                                              imageFilter: ImageFilter.blur(
                                                sigmaX: 3,
                                                sigmaY: 3,
                                              ),
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
                                            Stack(
                                              children: [
                                                ImageFiltered(
                                                  imageFilter: ImageFilter.blur(
                                                    sigmaX: 2,
                                                    sigmaY: 2,
                                                  ),
                                                  child: ColorFiltered(
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                      Colors.black
                                                          .withOpacity(0.3),
                                                      BlendMode.srcATop,
                                                    ),
                                                    child: Image.asset(
                                                      'assets/images/lottotsmallcart.png',
                                                      width: width * 0.45,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  left: 0,
                                                  bottom: 0,
                                                  child: Center(
                                                    child: SvgPicture.string(
                                                      '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M21 4H3a1 1 0 0 0-1 1v14a1 1 0 0 0 1 1h18a1 1 0 0 0 1-1V5a1 1 0 0 0-1-1zm-1 11a3 3 0 0 0-3 3H7a3 3 0 0 0-3-3V9a3 3 0 0 0 3-3h10a3 3 0 0 0 3 3v6z"></path><path d="M12 8c-2.206 0-4 1.794-4 4s1.794 4 4 4 4-1.794 4-4-1.794-4-4-4zm0 6c-1.103 0-2-.897-2-2s.897-2 2-2 2 .897 2 2-.897 2-2 2z"></path></svg>',
                                                      width: width * 0.1,
                                                      height: height * 0.1,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Positioned(
                                              top: height * 0.014,
                                              left: width * 0.075,
                                              right: 0,
                                              child: Center(
                                                child: ImageFiltered(
                                                  imageFilter: ImageFilter.blur(
                                                    sigmaX: 3,
                                                    sigmaY: 3,
                                                  ),
                                                  child: Text(
                                                    number,
                                                    style: TextStyle(
                                                      fontSize: width * 0.055,
                                                      fontFamily: 'prompt',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 0, 0, 0),
                                                      letterSpacing:
                                                          width * 0.01,
                                                    ),
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
                                        "งวดวันที่ ${formatCurrentDate()}",
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'prompt',
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          for (var controller in controllers) {
                                            controller.clear();
                                          }
                                          if (mounted) {
                                            setState(() {});
                                          }
                                        },
                                        style: TextButton.styleFrom(
                                          overlayColor: const Color.fromARGB(
                                              255, 0, 0, 0),
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
                                            decoration:
                                                TextDecoration.underline,
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
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
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
                                              keyboardType:
                                                  TextInputType.number,
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
                                                      constraints.maxWidth *
                                                          0.1,
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
                                          _updateFilteredLottots(
                                              randomCount: 1);
                                          if (mounted) {
                                            setState(() {
                                              if (filteredLottots.isEmpty) {
                                                text = 'ไม่พบลอตโต้!';
                                              } else {
                                                text = 'ผลการสุ่มตัวเลข';
                                              }
                                            });
                                          }
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
                                          if (mounted) {
                                            setState(() {
                                              filteredLottots.clear();
                                              if (filteredLottotsGrid.isEmpty) {
                                                text = 'ไม่พบลอตโต้!';
                                              } else {
                                                text = 'ผลการค้นหา';
                                              }
                                            });
                                          }
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
                                            child: InkWell(
                                              onTap: goLogin,
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
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          )
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
                                            'assets/images/lottotsmallcart.png',
                                            width: width * 0.95,
                                          ),
                                        ),
                                        Positioned(
                                          top: height * 0.01,
                                          left: width * 0.53,
                                          right: 0,
                                          child: Center(
                                            child: InkWell(
                                              onTap: goLogin,
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
                                                child: InkWell(
                                                  onTap: goLogin,
                                                  child: Text(
                                                    number,
                                                    style: TextStyle(
                                                      fontSize: width * 0.055,
                                                      fontFamily: 'prompt',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 0, 0, 0),
                                                      letterSpacing:
                                                          width * 0.01,
                                                    ),
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
            } else {
              if (resultststus.result.isNotEmpty) {
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
                                        "งวดวันที่ ${formatCurrentDate()}",
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'prompt',
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          for (var controller in controllers) {
                                            controller.clear();
                                          }
                                          if (mounted) {
                                            setState(() {});
                                          }
                                        },
                                        style: TextButton.styleFrom(
                                          overlayColor: const Color.fromARGB(
                                              255, 0, 0, 0),
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
                                            decoration:
                                                TextDecoration.underline,
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
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
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
                                              keyboardType:
                                                  TextInputType.number,
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
                                                      constraints.maxWidth *
                                                          0.1,
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
                                          _updateFilteredLottots(
                                              randomCount: 1);
                                          if (mounted) {
                                            setState(() {
                                              if (filteredLottots.isEmpty) {
                                                text = 'ไม่พบลอตโต้!';
                                              } else {
                                                text = 'ผลการสุ่มตัวเลข';
                                              }
                                            });
                                          }
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
                                          if (mounted) {
                                            setState(() {
                                              filteredLottots.clear();
                                              if (filteredLottotsGrid.isEmpty) {
                                                text = 'ไม่พบลอตโต้!';
                                              } else {
                                                text = 'ผลการค้นหา';
                                              }
                                            });
                                          }
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
                        if (filteredLottots.isNotEmpty)
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: filteredLottots
                                  .map(
                                    (number) => Stack(
                                      children: [
                                        Stack(
                                          children: [
                                            ImageFiltered(
                                              imageFilter: ImageFilter.blur(
                                                sigmaX: 2,
                                                sigmaY: 2,
                                              ),
                                              child: ColorFiltered(
                                                colorFilter: ColorFilter.mode(
                                                  Colors.black.withOpacity(0.3),
                                                  BlendMode.srcATop,
                                                ),
                                                child: Image.asset(
                                                  'assets/images/lottot.png',
                                                  width: width * 0.95,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              left: 0,
                                              bottom: 0,
                                              child: Center(
                                                child: SvgPicture.string(
                                                  '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M21 4H3a1 1 0 0 0-1 1v14a1 1 0 0 0 1 1h18a1 1 0 0 0 1-1V5a1 1 0 0 0-1-1zm-1 11a3 3 0 0 0-3 3H7a3 3 0 0 0-3-3V9a3 3 0 0 0 3-3h10a3 3 0 0 0 3 3v6z"></path><path d="M12 8c-2.206 0-4 1.794-4 4s1.794 4 4 4 4-1.794 4-4-1.794-4-4-4zm0 6c-1.103 0-2-.897-2-2s.897-2 2-2 2 .897 2 2-.897 2-2 2z"></path></svg>',
                                                  width: width * 0.1,
                                                  height: height * 0.1,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Positioned(
                                          top: height * 0.01,
                                          left: width * 0.53,
                                          right: 0,
                                          child: Center(
                                              child: ImageFiltered(
                                            imageFilter: ImageFilter.blur(
                                              sigmaX: 3,
                                              sigmaY: 3,
                                            ),
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
                                          )),
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
                                        Stack(
                                          children: [
                                            ImageFiltered(
                                              imageFilter: ImageFilter.blur(
                                                sigmaX: 2,
                                                sigmaY: 2,
                                              ),
                                              child: ColorFiltered(
                                                colorFilter: ColorFilter.mode(
                                                  Colors.black.withOpacity(0.3),
                                                  BlendMode.srcATop,
                                                ),
                                                child: Image.asset(
                                                  'assets/images/lottot.png',
                                                  width: width * 0.95,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              left: 0,
                                              bottom: 0,
                                              child: Center(
                                                child: SvgPicture.string(
                                                  '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M21 4H3a1 1 0 0 0-1 1v14a1 1 0 0 0 1 1h18a1 1 0 0 0 1-1V5a1 1 0 0 0-1-1zm-1 11a3 3 0 0 0-3 3H7a3 3 0 0 0-3-3V9a3 3 0 0 0 3-3h10a3 3 0 0 0 3 3v6z"></path><path d="M12 8c-2.206 0-4 1.794-4 4s1.794 4 4 4 4-1.794 4-4-1.794-4-4-4zm0 6c-1.103 0-2-.897-2-2s.897-2 2-2 2 .897 2 2-.897 2-2 2z"></path></svg>',
                                                  width: width * 0.1,
                                                  height: height * 0.1,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Positioned(
                                          top: height * 0.01,
                                          left: width * 0.53,
                                          right: 0,
                                          child: Center(
                                            child: ImageFiltered(
                                              imageFilter: ImageFilter.blur(
                                                sigmaX: 3,
                                                sigmaY: 3,
                                              ),
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
                                            Stack(
                                              children: [
                                                ImageFiltered(
                                                  imageFilter: ImageFilter.blur(
                                                    sigmaX: 2,
                                                    sigmaY: 2,
                                                  ),
                                                  child: ColorFiltered(
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                      Colors.black
                                                          .withOpacity(0.3),
                                                      BlendMode.srcATop,
                                                    ),
                                                    child: Image.asset(
                                                      'assets/images/lottotsmallcart.png',
                                                      width: width * 0.45,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  left: 0,
                                                  bottom: 0,
                                                  child: Center(
                                                    child: SvgPicture.string(
                                                      '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M21 4H3a1 1 0 0 0-1 1v14a1 1 0 0 0 1 1h18a1 1 0 0 0 1-1V5a1 1 0 0 0-1-1zm-1 11a3 3 0 0 0-3 3H7a3 3 0 0 0-3-3V9a3 3 0 0 0 3-3h10a3 3 0 0 0 3 3v6z"></path><path d="M12 8c-2.206 0-4 1.794-4 4s1.794 4 4 4 4-1.794 4-4-1.794-4-4-4zm0 6c-1.103 0-2-.897-2-2s.897-2 2-2 2 .897 2 2-.897 2-2 2z"></path></svg>',
                                                      width: width * 0.1,
                                                      height: height * 0.1,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Positioned(
                                              top: height * 0.014,
                                              left: width * 0.075,
                                              right: 0,
                                              child: Center(
                                                child: ImageFiltered(
                                                  imageFilter: ImageFilter.blur(
                                                    sigmaX: 3,
                                                    sigmaY: 3,
                                                  ),
                                                  child: Text(
                                                    number,
                                                    style: TextStyle(
                                                      fontSize: width * 0.055,
                                                      fontFamily: 'prompt',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 0, 0, 0),
                                                      letterSpacing:
                                                          width * 0.01,
                                                    ),
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
                                        "งวดวันที่ ${formatCurrentDate()}",
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'prompt',
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          for (var controller in controllers) {
                                            controller.clear();
                                          }
                                          if (mounted) {
                                            setState(() {
                                              filteredLottots.clear();
                                              _updateFilteredLottots();
                                            });
                                          }
                                        },
                                        style: TextButton.styleFrom(
                                          overlayColor: const Color.fromARGB(
                                              255, 0, 0, 0),
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
                                            decoration:
                                                TextDecoration.underline,
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
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
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
                                              keyboardType:
                                                  TextInputType.number,
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
                                                      constraints.maxWidth *
                                                          0.1,
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
                                          _updateFilteredLottots(
                                              randomCount: 1);
                                          if (mounted) {
                                            setState(() {
                                              if (filteredLottots.isEmpty) {
                                                text = 'ไม่พบลอตโต้!';
                                              } else {
                                                text = 'ผลการสุ่มตัวเลข';
                                              }
                                            });
                                          }
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
                                          if (mounted) {
                                            setState(() {
                                              filteredLottots.clear();

                                              if (filteredLottotsGrid.isEmpty) {
                                                text = 'ไม่พบลอตโต้!';
                                              } else {
                                                text = 'ผลการค้นหา';
                                              }
                                            });
                                          }
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
                        if (filteredLottots.isNotEmpty)
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: filteredLottots
                                  .map(
                                    (number) => Stack(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            if (!baskets.contains(number)) {
                                              addToCart(number);

                                              if (mounted) {
                                                await loadDataAsync();
                                                Navigator.pop(context);
                                              }
                                            }
                                          },
                                          child: baskets.contains(number)
                                              ? Stack(
                                                  children: [
                                                    ImageFiltered(
                                                      imageFilter:
                                                          ImageFilter.blur(
                                                        sigmaX: 2,
                                                        sigmaY: 2,
                                                      ),
                                                      child: ColorFiltered(
                                                        colorFilter:
                                                            ColorFilter.mode(
                                                          Colors.black
                                                              .withOpacity(0.3),
                                                          BlendMode.srcATop,
                                                        ),
                                                        child: Image.asset(
                                                          'assets/images/lottot.png',
                                                          width: width * 0.95,
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 0,
                                                      right: 0,
                                                      left: 0,
                                                      bottom: 0,
                                                      child: Center(
                                                        child:
                                                            SvgPicture.string(
                                                          '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M21.822 7.431A1 1 0 0 0 21 7H7.333L6.179 4.23A1.994 1.994 0 0 0 4.333 3H2v2h2.333l4.744 11.385A1 1 0 0 0 10 17h8c.417 0 .79-.259.937-.648l3-8a1 1 0 0 0-.115-.921z"></path><circle cx="10.5" cy="19.5" r="1.5"></circle><circle cx="17.5" cy="19.5" r="1.5"></circle></svg>',
                                                          width: width * 0.1,
                                                          height: height * 0.1,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              : Image.asset(
                                                  'assets/images/lottot.png',
                                                  width: width * 0.95,
                                                ),
                                        ),
                                        Positioned(
                                          top: height * 0.01,
                                          left: width * 0.53,
                                          right: 0,
                                          child: Center(
                                            child: baskets.contains(number)
                                                ? ImageFiltered(
                                                    imageFilter:
                                                        ImageFilter.blur(
                                                      sigmaX: 3,
                                                      sigmaY: 3,
                                                    ),
                                                    child: Text(
                                                      number,
                                                      style: TextStyle(
                                                        fontSize: width * 0.07,
                                                        fontFamily: 'prompt',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 0, 0, 0),
                                                        letterSpacing:
                                                            width * 0.01,
                                                      ),
                                                    ),
                                                  )
                                                : InkWell(
                                                    onTap: () async {
                                                      if (!baskets
                                                          .contains(number)) {
                                                        addToCart(number);

                                                        if (mounted) {
                                                          await loadDataAsync();
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      }
                                                    },
                                                    child: Text(
                                                      number,
                                                      style: TextStyle(
                                                        fontSize: width * 0.07,
                                                        fontFamily: 'prompt',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 0, 0, 0),
                                                        letterSpacing:
                                                            width * 0.01,
                                                      ),
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
                                          onTap: () async {
                                            if (!baskets.contains(number)) {
                                              addToCart(number);

                                              if (mounted) {
                                                await loadDataAsync();
                                                Navigator.pop(context);
                                              }
                                            }
                                          },
                                          child: baskets.contains(number)
                                              ? Stack(
                                                  children: [
                                                    ImageFiltered(
                                                      imageFilter:
                                                          ImageFilter.blur(
                                                        sigmaX: 2,
                                                        sigmaY: 2,
                                                      ),
                                                      child: ColorFiltered(
                                                        colorFilter:
                                                            ColorFilter.mode(
                                                          Colors.black
                                                              .withOpacity(0.3),
                                                          BlendMode.srcATop,
                                                        ),
                                                        child: Image.asset(
                                                          'assets/images/lottot.png',
                                                          width: width * 0.95,
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 0,
                                                      right: 0,
                                                      left: 0,
                                                      bottom: 0,
                                                      child: Center(
                                                        child:
                                                            SvgPicture.string(
                                                          '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M21.822 7.431A1 1 0 0 0 21 7H7.333L6.179 4.23A1.994 1.994 0 0 0 4.333 3H2v2h2.333l4.744 11.385A1 1 0 0 0 10 17h8c.417 0 .79-.259.937-.648l3-8a1 1 0 0 0-.115-.921z"></path><circle cx="10.5" cy="19.5" r="1.5"></circle><circle cx="17.5" cy="19.5" r="1.5"></circle></svg>',
                                                          width: width * 0.1,
                                                          height: height * 0.1,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              : Image.asset(
                                                  'assets/images/lottot.png',
                                                  width: width * 0.95,
                                                ),
                                        ),
                                        Positioned(
                                          top: height * 0.01,
                                          left: width * 0.53,
                                          right: 0,
                                          child: Center(
                                            child: baskets.contains(number)
                                                ? ImageFiltered(
                                                    imageFilter:
                                                        ImageFilter.blur(
                                                      sigmaX: 3,
                                                      sigmaY: 3,
                                                    ),
                                                    child: Text(
                                                      number,
                                                      style: TextStyle(
                                                        fontSize: width * 0.07,
                                                        fontFamily: 'prompt',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 0, 0, 0),
                                                        letterSpacing:
                                                            width * 0.01,
                                                      ),
                                                    ),
                                                  )
                                                : InkWell(
                                                    onTap: () async {
                                                      if (!baskets
                                                          .contains(number)) {
                                                        addToCart(number);

                                                        if (mounted) {
                                                          await loadDataAsync();
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      }
                                                    },
                                                    child: Text(
                                                      number,
                                                      style: TextStyle(
                                                        fontSize: width * 0.07,
                                                        fontFamily: 'prompt',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 0, 0, 0),
                                                        letterSpacing:
                                                            width * 0.01,
                                                      ),
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
                                              onTap: () async {
                                                if (!baskets.contains(number)) {
                                                  addToCart(number);

                                                  if (mounted) {
                                                    await loadDataAsync();
                                                    Navigator.pop(context);
                                                  }
                                                }
                                              },
                                              child: baskets.contains(number)
                                                  ? Stack(
                                                      children: [
                                                        ImageFiltered(
                                                          imageFilter:
                                                              ImageFilter.blur(
                                                            sigmaX: 2,
                                                            sigmaY: 2,
                                                          ),
                                                          child: ColorFiltered(
                                                            colorFilter:
                                                                ColorFilter
                                                                    .mode(
                                                              Colors.black
                                                                  .withOpacity(
                                                                      0.3),
                                                              BlendMode.srcATop,
                                                            ),
                                                            child: Image.asset(
                                                              'assets/images/lottotsmallcart.png',
                                                              width:
                                                                  width * 0.45,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: 0,
                                                          right: 0,
                                                          left: 0,
                                                          bottom: 0,
                                                          child: Center(
                                                            child: SvgPicture
                                                                .string(
                                                              '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M21.822 7.431A1 1 0 0 0 21 7H7.333L6.179 4.23A1.994 1.994 0 0 0 4.333 3H2v2h2.333l4.744 11.385A1 1 0 0 0 10 17h8c.417 0 .79-.259.937-.648l3-8a1 1 0 0 0-.115-.921z"></path><circle cx="10.5" cy="19.5" r="1.5"></circle><circle cx="17.5" cy="19.5" r="1.5"></circle></svg>',
                                                              width:
                                                                  width * 0.1,
                                                              height:
                                                                  height * 0.1,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  : Image.asset(
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
                                                child: baskets.contains(number)
                                                    ? ImageFiltered(
                                                        imageFilter:
                                                            ImageFilter.blur(
                                                          sigmaX: 3,
                                                          sigmaY: 3,
                                                        ),
                                                        child: Text(
                                                          number,
                                                          style: TextStyle(
                                                            fontSize:
                                                                width * 0.055,
                                                            fontFamily:
                                                                'prompt',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: const Color
                                                                .fromARGB(
                                                                255, 0, 0, 0),
                                                            letterSpacing:
                                                                width * 0.01,
                                                          ),
                                                        ),
                                                      )
                                                    : InkWell(
                                                        onTap: () async {
                                                          if (!baskets.contains(
                                                              number)) {
                                                            addToCart(number);

                                                            if (mounted) {
                                                              await loadDataAsync();
                                                              Navigator.pop(
                                                                  context);
                                                            }
                                                          }
                                                        },
                                                        child: Text(
                                                          number,
                                                          style: TextStyle(
                                                            fontSize:
                                                                width * 0.055,
                                                            fontFamily:
                                                                'prompt',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: const Color
                                                                .fromARGB(
                                                                255, 0, 0, 0),
                                                            letterSpacing:
                                                                width * 0.01,
                                                          ),
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
            }
          }),
    );
  }

  void addToCart(String number) async {
    // Show loading indicator and dialog
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        content: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      // Fetch configuration and user data
      var config = await Configuration.getConfig();
      var url = config['apiEndpoint'];

      var userResponse = await http.get(Uri.parse('$url/user/${widget.email}'));
      var user = userIdxGetResponseFromJson(userResponse.body);

      for (var j in user.result) {
        for (var i in lottot) {
          if (number == i.number) {
            AddToCartPostRequest addToCartPostReq = AddToCartPostRequest(
              bUid: j.uid,
              bLid: i.lid,
            );

            var postResponse = await http.post(
              Uri.parse("$url/basket"),
              headers: {"Content-Type": "application/json; charset=utf-8"},
              body: addToCartPostRequestToJson(addToCartPostReq),
            );
            if (postResponse.statusCode == 201) {
              AddToCartPostResponse addToCartRes =
                  addToCartPostResponseFromJson(postResponse.body);
              if (addToCartRes.response) {
                var basketRes =
                    await http.get(Uri.parse('$url/basket/${j.uid}'));
                basket = basketUserResponseFromJson(basketRes.body);
                setState(() {
                  widget.basketCountController.add(basket.result.length);
                });
              } else {
                Navigator.pop(context);
              }
            } else {
              Navigator.pop(context);
            }
          }
        }
      }
    } catch (e) {
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
                  'assets/images/error.png',
                  width: MediaQuery.of(context).size.width * 0.16,
                  height: MediaQuery.of(context).size.width * 0.16,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.04),
                Center(
                  child: Text(
                    'เซิฟเวอร์ไม่พร้อมใช้งาน!!',
                    style: TextStyle(
                      fontFamily: 'prompt',
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(
                      MediaQuery.of(context).size.width * 0.3,
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
              ],
            ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  List<String> getRandomElements(List<String> list, int n) {
    list.shuffle(); // สุ่มลำดับของรายการ
    return list.take(n).toList(); // ดึงข้อมูลตามจำนวนที่ต้องการ
  }

  _updateFilteredLottots({int? randomCount}) {
    List<String?> filters = controllers
        .map(
            (controller) => controller.text.isNotEmpty ? controller.text : null)
        .toList();

    if (randomCount != null) {
      List<String> lottotsNumber = [];
      for (var i in lottot) {
        if (i.owner == null) {
          lottotsNumber.add(i.number);
        }
      }
      filteredLottots = getRandomElements(lottotsNumber, randomCount);
    } else if (filters.every((filter) => filter == null)) {
      List<String> lottotsNumber = [];
      for (var i in lottot) {
        if (i.owner == null) {
          lottotsNumber.add(i.number);
        }
      }

      filteredLottots = lottotsNumber.take(10).toList();
    } else {
      List<String> lottotsNumber = [];
      for (var i in lottot) {
        if (i.owner == null) {
          lottotsNumber.add(i.number);
        }
      }
      filteredLottotsGrid = filterData(lottotsNumber, filters);
    }
    if (mounted) {
      setState(() {});
    }
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

  String formatCurrentDate() {
    // ใช้วันที่และเวลาปัจจุบัน
    DateTime dateTime = DateTime.now();

    // เพิ่มเวลาชดเชย 7 ชั่วโมง สำหรับเขตเวลา UTC+7 (ประเทศไทย)
    DateTime adjustedDateTime = dateTime.add(const Duration(hours: 7));

    // กำหนดรูปแบบวันที่และเวลาที่ต้องการ (เช่น 07 ส.ค. 2567 - 00:00)
    var thaiDateFormat = DateFormat('dd MMMM yyyy', 'th_TH');

    // จัดรูปแบบวันที่และเวลาตาม Locale ของภาษาไทย
    var formattedDate = thaiDateFormat.format(adjustedDateTime);

    // แปลง ค.ศ. เป็น พ.ศ.
    String yearInBuddhistEra = (adjustedDateTime.year + 543).toString();
    formattedDate = formattedDate.replaceFirst(
        adjustedDateTime.year.toString(), yearInBuddhistEra);

    return formattedDate;
  }
}
