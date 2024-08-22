import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottotmuutoo/pageAdmin/mainAdmin.dart';
import 'package:lottotmuutoo/pageAdmin/outnumber.dart';

class mainnavbaradminPage extends StatefulWidget {
  String email = '';
  int selectedPage = 0;
  List resultRandAll = [];
  bool hasRandNum = false;
  bool acceptNumberJackAll = false;
  mainnavbaradminPage({
    super.key,
    required this.email,
    required this.selectedPage,
    required this.resultRandAll,
    required this.hasRandNum,
    required this.acceptNumberJackAll,
  });

  @override
  State<mainnavbaradminPage> createState() => _mainnavbaradminPageState();
}

class _mainnavbaradminPageState extends State<mainnavbaradminPage> {
  final box = GetStorage();
  late final List<Widget> pageOptions;

  @override
  void initState() {
    pageOptions = [
      MainadminPage(
        email: widget.email,
        resultRandAll: widget.resultRandAll,
        acceptNumberJackAll: widget.acceptNumberJackAll,
      ),
      OutnumberPage(
        email: widget.email,
        resultRandAll: widget.resultRandAll,
        hasRandNum: widget.hasRandNum,
        acceptNumberJackAll: widget.acceptNumberJackAll,
      ),
    ];
    super.initState();
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
      appBar: null,
      bottomNavigationBar: BottomNavigationBar(
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
              '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M12 15c-1.84 0-2-.86-2-1H8c0 .92.66 2.55 3 2.92V18h2v-1.08c2-.34 3-1.63 3-2.92 0-1.12-.52-3-4-3-2 0-2-.63-2-1s.7-1 2-1 1.39.64 1.4 1h2A3 3 0 0 0 13 7.12V6h-2v1.09C9 7.42 8 8.71 8 10c0 1.12.52 3 4 3 2 0 2 .68 2 1s-.62 1-2 1z"></path><path d="M5 2H2v2h2v17a1 1 0 0 0 1 1h14a1 1 0 0 0 1-1V4h2V2H5zm13 18H6V4h12z"></path></svg>',
              width: width * 0.08,
              height: width * 0.08,
              fit: BoxFit.cover,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
            activeIcon: SvgPicture.string(
              '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(0, 0, 0, 1);transform: ;msFilter:;"><path d="M12 15c-1.84 0-2-.86-2-1H8c0 .92.66 2.55 3 2.92V18h2v-1.08c2-.34 3-1.63 3-2.92 0-1.12-.52-3-4-3-2 0-2-.63-2-1s.7-1 2-1 1.39.64 1.4 1h2A3 3 0 0 0 13 7.12V6h-2v1.09C9 7.42 8 8.71 8 10c0 1.12.52 3 4 3 2 0 2 .68 2 1s-.62 1-2 1z"></path><path d="M5 2H2v2h2v17a1 1 0 0 0 1 1h14a1 1 0 0 0 1-1V4h2V2H5zm13 18H6V4h12z"></path></svg>',
              width: width * 0.08,
              height: width * 0.08,
              fit: BoxFit.cover,
              color: const Color(0xff29b6f6),
            ),
            label: 'ยืนยันหวยออก',
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
  }

  void onItemTapped(int index) {
    setState(() {
      widget.selectedPage = index;
    });
  }
}
