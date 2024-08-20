import 'package:flutter/material.dart';
import 'package:lottotmuutoo/config/config.dart';
import 'package:lottotmuutoo/pages/login.dart';
import 'package:lottotmuutoo/pages/widgets/drawer.dart';

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
  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];
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

      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (widget.email == 'ยังไม่ได้เข้าสู่ระบบ') {
            return Container(
              child: Text('ยังไม่ได้เข้าสู่ระบบ'),
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
            return Container(
              child: Text('ผลรางวัล'),
            );
          }
        },
      ),
    );
  }
}
