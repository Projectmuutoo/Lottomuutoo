import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottotmuutoo/config/config.dart';
import 'package:lottotmuutoo/models/request/UserGoogleLoginPost.dart';
import 'package:lottotmuutoo/models/response/UserGetResponse.dart';
import 'package:lottotmuutoo/pageAdmin/mainnavbarAdmin.dart';
import 'package:lottotmuutoo/pages/navpages/cart.dart';
import 'package:lottotmuutoo/pages/navpages/checklottot.dart';
import 'package:lottotmuutoo/pages/navpages/checkresults.dart';
import 'package:lottotmuutoo/pages/navpages/home.dart';
import 'package:lottotmuutoo/pages/navpages/order.dart';
import 'package:lottotmuutoo/pages/navpages/profile.dart';
import 'package:lottotmuutoo/pages/navpages/wallet.dart';
import 'package:lottotmuutoo/pages/widgets/drawer.dart';
import 'package:http/http.dart' as http;

class NavbarPage extends StatefulWidget {
  String email = '';
  int selectedPage = 0;
  NavbarPage({
    super.key,
    required this.email,
    required this.selectedPage,
  });

  @override
  State<NavbarPage> createState() => _NavbarPageState();
}

class _NavbarPageState extends State<NavbarPage> {
  final StreamController<int> _basketCountController =
      StreamController<int>.broadcast();
  late Future<void> loadData;
  final box = GetStorage();
  late final List<Widget> pageOptions;
  bool isTyping = false;

  @override
  void initState() {
    pageOptions = [
      HomePage(
        email: widget.email,
        basketCountController: _basketCountController,
      ),
      OrderPage(
        email: widget.email,
        basketCountController: _basketCountController,
      ),
      ChecklottotPage(
        email: widget.email,
        basketCountController: _basketCountController,
      ),
      WalletPage(
        email: widget.email,
        basketCountController: _basketCountController,
      ),
      CartPage(
        email: widget.email,
        basketCountController: _basketCountController,
      ),
      ProfilePage(
        email: widget.email,
        basketCountController: _basketCountController,
      ),
      CheckresultsPage(
        email: widget.email,
        basketCountController: _basketCountController,
      )
    ];
    loadData = _initializeStorage();
    super.initState();
  }

  Future<void> _initializeStorage() async {
    try {
      var config = await Configuration.getConfig();
      var url = config['apiEndpoint'];
      var response = await http.get(Uri.parse("$url/user"));
      var userList = userGetResponseFromJson(response.body);
      List<UserGetResponseResult> listAllUsers = userList.result;

      for (var user in listAllUsers) {
        if (user.email == box.read('email')) {
          if (box.read('login') == true) {
            if (user.uid == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => mainnavbaradminPage(
                    email: user.email,
                    selectedPage: 0,
                    resultRandAll: [],
                    resultFromSelling: [],
                    acceptNumberJackAll: false,
                    acceptNumberFromSelling: false,
                  ),
                ),
              );
            } else {
              setState(() {
                widget.email = box.read('email');
              });
            }
          }
        }
      }
    } catch (e) {
      // Handle errors
      log('Error initializing storage: $e');
    }
  }

  void onItemTapped(int index) {
    setState(() {
      widget.selectedPage = index;
    });
  }

  @override
  void dispose() {
    _basketCountController.close();
    super.dispose();
  }

  // void _updateBasketCount(int count) {
  //   _basketCountController.add(count);
  // }

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

        return Scaffold(
          appBar: null,
          drawer: DrawerPage(
            email: widget.email,
            selectedPage: 0,
          ),
          // ตรวจสอบว่าเป็นหน้าโปรไฟล์หรือหน้าตรวจผลรางวัลหรือไม่
          bottomNavigationBar: widget.selectedPage >= 5
              ? buildBottomNavigationBar() // ถ้าใช่ไม่แสดง BottomNavigationBar
              : BottomNavigationBar(
                  items: [
                    BottomNavigationBarItem(
                      icon: SvgPicture.string(
                        '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M5 22h14a2 2 0 0 0 2-2v-9a1 1 0 0 0-.29-.71l-8-8a1 1 0 0 0-1.41 0l-8 8A1 1 0 0 0 3 11v9a2 2 0 0 0 2 2zm5-2v-5h4v5zm-5-8.59 7-7 7 7V20h-3v-5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v5H5z"></path></svg>',
                        width: width * 0.08,
                        height: width * 0.08,
                        fit: BoxFit.cover,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                      activeIcon: SvgPicture.string(
                        '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M5 22h14a2 2 0 0 0 2-2v-9a1 1 0 0 0-.29-.71l-8-8a1 1 0 0 0-1.41 0l-8 8A1 1 0 0 0 3 11v9a2 2 0 0 0 2 2zm5-2v-5h4v5zm-5-8.59 7-7 7 7V20h-3v-5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v5H5z"></path></svg>',
                        width: width * 0.08,
                        height: width * 0.08,
                        fit: BoxFit.cover,
                        color: const Color(0xff29b6f6),
                      ),
                      label: 'หน้าหลัก',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.string(
                        '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M19.903 8.586a.997.997 0 0 0-.196-.293l-6-6a.997.997 0 0 0-.293-.196c-.03-.014-.062-.022-.094-.033a.991.991 0 0 0-.259-.051C13.04 2.011 13.021 2 13 2H6c-1.103 0-2 .897-2 2v16c0 1.103.897 2 2 2h12c1.103 0 2-.897 2-2V9c0-.021-.011-.04-.013-.062a.952.952 0 0 0-.051-.259c-.01-.032-.019-.063-.033-.093zM16.586 8H14V5.414L16.586 8zM6 20V4h6v5a1 1 0 0 0 1 1h5l.002 10H6z"></path><path d="M8 12h8v2H8zm0 4h8v2H8zm0-8h2v2H8z"></path></svg>',
                        width: width * 0.08,
                        height: width * 0.08,
                        fit: BoxFit.cover,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                      activeIcon: SvgPicture.string(
                        '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M19.903 8.586a.997.997 0 0 0-.196-.293l-6-6a.997.997 0 0 0-.293-.196c-.03-.014-.062-.022-.094-.033a.991.991 0 0 0-.259-.051C13.04 2.011 13.021 2 13 2H6c-1.103 0-2 .897-2 2v16c0 1.103.897 2 2 2h12c1.103 0 2-.897 2-2V9c0-.021-.011-.04-.013-.062a.952.952 0 0 0-.051-.259c-.01-.032-.019-.063-.033-.093zM16.586 8H14V5.414L16.586 8zM6 20V4h6v5a1 1 0 0 0 1 1h5l.002 10H6z"></path><path d="M8 12h8v2H8zm0 4h8v2H8zm0-8h2v2H8z"></path></svg>',
                        width: width * 0.08,
                        height: width * 0.08,
                        fit: BoxFit.cover,
                        color: const Color(0xff29b6f6),
                      ),
                      label: 'คำสั่งซื้อ',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.string(
                        '<svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368"><path d="M400-320q100 0 170-70t70-170q0-100-70-170t-170-70q-100 0-170 70t-70 170q0 100 70 170t170 70Zm-42-98 226-227-57-57-169 170-85-84-57 56 142 142Zm42 178q-134 0-227-93T80-560q0-134 93-227t227-93q134 0 227 93t93 227q0 56-17.5 105.5T653-364l227 228-56 56-228-227q-41 32-90.5 49.5T400-240Zm0-320Z"/></svg>',
                        width: width * 0.08,
                        height: width * 0.08,
                        fit: BoxFit.cover,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                      activeIcon: SvgPicture.string(
                        '<svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368"><path d="M400-320q100 0 170-70t70-170q0-100-70-170t-170-70q-100 0-170 70t-70 170q0 100 70 170t170 70Zm-42-98 226-227-57-57-169 170-85-84-57 56 142 142Zm42 178q-134 0-227-93T80-560q0-134 93-227t227-93q134 0 227 93t93 227q0 56-17.5 105.5T653-364l227 228-56 56-228-227q-41 32-90.5 49.5T400-240Zm0-320Z"/></svg>',
                        width: width * 0.08,
                        height: width * 0.08,
                        fit: BoxFit.cover,
                        color: const Color(0xff29b6f6),
                      ),
                      label: 'ตรวจหวย',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.string(
                        '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M16 12h2v4h-2z"></path><path d="M20 7V5c0-1.103-.897-2-2-2H5C3.346 3 2 4.346 2 6v12c0 2.201 1.794 3 3 3h15c1.103 0 2-.897 2-2V9c0-1.103-.897-2-2-2zM5 5h13v2H5a1.001 1.001 0 0 1 0-2zm15 14H5.012C4.55 18.988 4 18.805 4 18V8.815c.314.113.647.185 1 .185h15v10z"></path></svg>',
                        width: width * 0.08,
                        height: width * 0.08,
                        fit: BoxFit.cover,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                      activeIcon: SvgPicture.string(
                        '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M16 12h2v4h-2z"></path><path d="M20 7V5c0-1.103-.897-2-2-2H5C3.346 3 2 4.346 2 6v12c0 2.201 1.794 3 3 3h15c1.103 0 2-.897 2-2V9c0-1.103-.897-2-2-2zM5 5h13v2H5a1.001 1.001 0 0 1 0-2zm15 14H5.012C4.55 18.988 4 18.805 4 18V8.815c.314.113.647.185 1 .185h15v10z"></path></svg>',
                        width: width * 0.08,
                        height: width * 0.08,
                        fit: BoxFit.cover,
                        color: const Color(0xff29b6f6),
                      ),
                      label: 'เป๋าตัง',
                    ),
                    BottomNavigationBarItem(
                      icon: StreamBuilder<int>(
                        stream: _basketCountController.stream,
                        builder: (context, snapshot) {
                          final count = snapshot.data ?? 0;
                          return Stack(
                            children: [
                              SvgPicture.string(
                                '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M21.822 7.431A1 1 0 0 0 21 7H7.333L6.179 4.23A1.994 1.994 0 0 0 4.333 3H2v2h2.333l4.744 11.385A1 1 0 0 0 10 17h8c.417 0 .79-.259.937-.648l3-8a1 1 0 0 0-.115-.921zM17.307 15h-6.64l-2.5-6h11.39l-2.25 6z"></path><circle cx="10.5" cy="19.5" r="1.5"></circle><circle cx="17.5" cy="19.5" r="1.5"></circle></svg>',
                                width: width * 0.08,
                                height: width * 0.08,
                                fit: BoxFit.cover,
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                              if (count > 0)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xfff62e2e),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        width: width * 0.002,
                                      ),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: width * 0.04,
                                      minHeight: width * 0.04,
                                    ),
                                    child: Center(
                                      child: Text(
                                        count.toString(),
                                        style: TextStyle(
                                          fontFamily: 'prompt',
                                          fontSize: width * 0.032,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      activeIcon: StreamBuilder<int>(
                        stream: _basketCountController.stream,
                        builder: (context, snapshot) {
                          final count = snapshot.data ?? 0;
                          return Stack(
                            children: [
                              SvgPicture.string(
                                '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M21.822 7.431A1 1 0 0 0 21 7H7.333L6.179 4.23A1.994 1.994 0 0 0 4.333 3H2v2h2.333l4.744 11.385A1 1 0 0 0 10 17h8c.417 0 .79-.259.937-.648l3-8a1 1 0 0 0-.115-.921zM17.307 15h-6.64l-2.5-6h11.39l-2.25 6z"></path><circle cx="10.5" cy="19.5" r="1.5"></circle><circle cx="17.5" cy="19.5" r="1.5"></circle></svg>',
                                width: width * 0.08,
                                height: width * 0.08,
                                fit: BoxFit.cover,
                                color: const Color(0xff29b6f6),
                              ),
                              if (count > 0)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xfff62e2e),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        width: width * 0.002,
                                      ),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: width * 0.04,
                                      minHeight: width * 0.04,
                                    ),
                                    child: Center(
                                      child: Text(
                                        count.toString(),
                                        style: TextStyle(
                                          fontFamily: 'prompt',
                                          fontSize: width * 0.032,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      label: 'ตะกร้า',
                    ),
                  ],
                  currentIndex: widget.selectedPage,
                  onTap: onItemTapped,
                  selectedLabelStyle: TextStyle(
                    fontFamily: 'prompt',
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w500,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontFamily: 'prompt',
                    fontSize: width * 0.035,
                    fontWeight: FontWeight.w500,
                  ),
                  backgroundColor: Colors.white,
                  selectedItemColor: const Color(0xff29b6f6),
                  unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
                  type: BottomNavigationBarType.fixed,
                ),

          body: pageOptions[widget.selectedPage],
        );
      },
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.string(
            '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M5 22h14a2 2 0 0 0 2-2v-9a1 1 0 0 0-.29-.71l-8-8a1 1 0 0 0-1.41 0l-8 8A1 1 0 0 0 3 11v9a2 2 0 0 0 2 2zm5-2v-5h4v5zm-5-8.59 7-7 7 7V20h-3v-5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v5H5z"></path></svg>',
            width: MediaQuery.of(context).size.width * 0.08,
            height: MediaQuery.of(context).size.width * 0.08,
            fit: BoxFit.cover,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
          activeIcon: SvgPicture.string(
            '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M5 22h14a2 2 0 0 0 2-2v-9a1 1 0 0 0-.29-.71l-8-8a1 1 0 0 0-1.41 0l-8 8A1 1 0 0 0 3 11v9a2 2 0 0 0 2 2zm5-2v-5h4v5zm-5-8.59 7-7 7 7V20h-3v-5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v5H5z"></path></svg>',
            width: MediaQuery.of(context).size.width * 0.08,
            height: MediaQuery.of(context).size.width * 0.08,
            fit: BoxFit.cover,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          label: 'หน้าหลัก',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.string(
            '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M19.903 8.586a.997.997 0 0 0-.196-.293l-6-6a.997.997 0 0 0-.293-.196c-.03-.014-.062-.022-.094-.033a.991.991 0 0 0-.259-.051C13.04 2.011 13.021 2 13 2H6c-1.103 0-2 .897-2 2v16c0 1.103.897 2 2 2h12c1.103 0 2-.897 2-2V9c0-.021-.011-.04-.013-.062a.952.952 0 0 0-.051-.259c-.01-.032-.019-.063-.033-.093zM16.586 8H14V5.414L16.586 8zM6 20V4h6v5a1 1 0 0 0 1 1h5l.002 10H6z"></path><path d="M8 12h8v2H8zm0 4h8v2H8zm0-8h2v2H8z"></path></svg>',
            width: MediaQuery.of(context).size.width * 0.08,
            height: MediaQuery.of(context).size.width * 0.08,
            fit: BoxFit.cover,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
          activeIcon: SvgPicture.string(
            '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M19.903 8.586a.997.997 0 0 0-.196-.293l-6-6a.997.997 0 0 0-.293-.196c-.03-.014-.062-.022-.094-.033a.991.991 0 0 0-.259-.051C13.04 2.011 13.021 2 13 2H6c-1.103 0-2 .897-2 2v16c0 1.103.897 2 2 2h12c1.103 0 2-.897 2-2V9c0-.021-.011-.04-.013-.062a.952.952 0 0 0-.051-.259c-.01-.032-.019-.063-.033-.093zM16.586 8H14V5.414L16.586 8zM6 20V4h6v5a1 1 0 0 0 1 1h5l.002 10H6z"></path><path d="M8 12h8v2H8zm0 4h8v2H8zm0-8h2v2H8z"></path></svg>',
            width: MediaQuery.of(context).size.width * 0.08,
            height: MediaQuery.of(context).size.width * 0.08,
            fit: BoxFit.cover,
            color: const Color(0xff29b6f6),
          ),
          label: 'คำสั่งซื้อ',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.string(
            '<svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368"><path d="M400-320q100 0 170-70t70-170q0-100-70-170t-170-70q-100 0-170 70t-70 170q0 100 70 170t170 70Zm-42-98 226-227-57-57-169 170-85-84-57 56 142 142Zm42 178q-134 0-227-93T80-560q0-134 93-227t227-93q134 0 227 93t93 227q0 56-17.5 105.5T653-364l227 228-56 56-228-227q-41 32-90.5 49.5T400-240Zm0-320Z"/></svg>',
            width: MediaQuery.of(context).size.width * 0.08,
            height: MediaQuery.of(context).size.width * 0.08,
            fit: BoxFit.cover,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
          activeIcon: SvgPicture.string(
            '<svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368"><path d="M400-320q100 0 170-70t70-170q0-100-70-170t-170-70q-100 0-170 70t-70 170q0 100 70 170t170 70Zm-42-98 226-227-57-57-169 170-85-84-57 56 142 142Zm42 178q-134 0-227-93T80-560q0-134 93-227t227-93q134 0 227 93t93 227q0 56-17.5 105.5T653-364l227 228-56 56-228-227q-41 32-90.5 49.5T400-240Zm0-320Z"/></svg>',
            width: MediaQuery.of(context).size.width * 0.08,
            height: MediaQuery.of(context).size.width * 0.08,
            fit: BoxFit.cover,
            color: const Color(0xff29b6f6),
          ),
          label: 'ตรวจหวย',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.string(
            '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M16 12h2v4h-2z"></path><path d="M20 7V5c0-1.103-.897-2-2-2H5C3.346 3 2 4.346 2 6v12c0 2.201 1.794 3 3 3h15c1.103 0 2-.897 2-2V9c0-1.103-.897-2-2-2zM5 5h13v2H5a1.001 1.001 0 0 1 0-2zm15 14H5.012C4.55 18.988 4 18.805 4 18V8.815c.314.113.647.185 1 .185h15v10z"></path></svg>',
            width: MediaQuery.of(context).size.width * 0.08,
            height: MediaQuery.of(context).size.width * 0.08,
            fit: BoxFit.cover,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
          activeIcon: SvgPicture.string(
            '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M16 12h2v4h-2z"></path><path d="M20 7V5c0-1.103-.897-2-2-2H5C3.346 3 2 4.346 2 6v12c0 2.201 1.794 3 3 3h15c1.103 0 2-.897 2-2V9c0-1.103-.897-2-2-2zM5 5h13v2H5a1.001 1.001 0 0 1 0-2zm15 14H5.012C4.55 18.988 4 18.805 4 18V8.815c.314.113.647.185 1 .185h15v10z"></path></svg>',
            width: MediaQuery.of(context).size.width * 0.08,
            height: MediaQuery.of(context).size.width * 0.08,
            fit: BoxFit.cover,
            color: const Color(0xff29b6f6),
          ),
          label: 'เป๋าตัง',
        ),
        BottomNavigationBarItem(
          icon: StreamBuilder<int>(
            stream: _basketCountController.stream,
            builder: (context, snapshot) {
              final count = snapshot.data ?? 0;
              return Stack(
                children: [
                  SvgPicture.string(
                    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M21.822 7.431A1 1 0 0 0 21 7H7.333L6.179 4.23A1.994 1.994 0 0 0 4.333 3H2v2h2.333l4.744 11.385A1 1 0 0 0 10 17h8c.417 0 .79-.259.937-.648l3-8a1 1 0 0 0-.115-.921zM17.307 15h-6.64l-2.5-6h11.39l-2.25 6z"></path><circle cx="10.5" cy="19.5" r="1.5"></circle><circle cx="17.5" cy="19.5" r="1.5"></circle></svg>',
                    width: MediaQuery.of(context).size.width * 0.08,
                    height: MediaQuery.of(context).size.width * 0.08,
                    fit: BoxFit.cover,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                  if (count > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xfff62e2e),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            width: MediaQuery.of(context).size.width * 0.002,
                          ),
                        ),
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width * 0.04,
                          minHeight: MediaQuery.of(context).size.width * 0.04,
                        ),
                        child: Center(
                          child: Text(
                            count.toString(),
                            style: TextStyle(
                              fontFamily: 'prompt',
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.032,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          activeIcon: StreamBuilder<int>(
            stream: _basketCountController.stream,
            builder: (context, snapshot) {
              final count = snapshot.data ?? 0;
              return Stack(
                children: [
                  SvgPicture.string(
                    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M21.822 7.431A1 1 0 0 0 21 7H7.333L6.179 4.23A1.994 1.994 0 0 0 4.333 3H2v2h2.333l4.744 11.385A1 1 0 0 0 10 17h8c.417 0 .79-.259.937-.648l3-8a1 1 0 0 0-.115-.921zM17.307 15h-6.64l-2.5-6h11.39l-2.25 6z"></path><circle cx="10.5" cy="19.5" r="1.5"></circle><circle cx="17.5" cy="19.5" r="1.5"></circle></svg>',
                    width: MediaQuery.of(context).size.width * 0.08,
                    height: MediaQuery.of(context).size.width * 0.08,
                    fit: BoxFit.cover,
                    color: const Color(0xff29b6f6),
                  ),
                  if (count > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xfff62e2e),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            width: MediaQuery.of(context).size.width * 0.002,
                          ),
                        ),
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width * 0.04,
                          minHeight: MediaQuery.of(context).size.width * 0.04,
                        ),
                        child: Center(
                          child: Text(
                            count.toString(),
                            style: TextStyle(
                              fontFamily: 'prompt',
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.032,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          label: 'ตะกร้า',
        ),
      ],
      currentIndex: 0,
      onTap: onItemTapped,
      selectedLabelStyle: TextStyle(
        fontFamily: 'prompt',
        fontSize: MediaQuery.of(context).size.width * 0.035,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'prompt',
        fontSize: MediaQuery.of(context).size.width * 0.035,
        fontWeight: FontWeight.w500,
      ),
      backgroundColor: Colors.white,
      selectedItemColor: Color.fromARGB(255, 0, 0, 0),
      unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
      type: BottomNavigationBarType.fixed,
    );
  }

  Future<void> updateMoney(String amount) async {
    LoginGoogleReq userLoginReq = LoginGoogleReq(
      email: box.read('email'),
      money: int.parse(amount),
    );
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];
    http
        .put(Uri.parse('$url/user/money'),
            headers: {"Content-Type": "application/json; charset=utf-8"},
            body: loginGoogleReqToJson(userLoginReq))
        .then((value) {
      // log(value.body);
    });
  }
}
