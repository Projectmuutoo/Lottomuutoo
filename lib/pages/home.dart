import 'package:flutter/material.dart';
import 'package:lottotmuutoo/pages/login.dart';
import 'package:lottotmuutoo/pages/widgets/drawer.dart';

class HomePage extends StatefulWidget {
  String email = '';
  HomePage({super.key, required this.email});

  @override
  State<HomePage> createState() => _MainPageState();
}

class _MainPageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      //PreferredSize กำหนดขนาด AppBar กำหนดเป็น 25% ของ width ของหน้าจอ * 0.25
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
                            builder: (context) => HomePage(email: widget.email),
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
      drawer: DrawerPage(email: widget.email),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: height * 0.02,
          ),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFE6E6E6), // สีพื้นหลัง
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "งวดวันที่ 1 สิงหาคม 2567",
                              style: TextStyle(
                                fontSize: width * 0.04,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'prompt',
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                overlayColor:
                                    const Color.fromARGB(255, 0, 0, 0),
                                padding:
                                    EdgeInsets.zero, // ลบ padding ภายในปุ่ม
                                minimumSize: Size.zero, // ลบขนาดขั้นต่ำของปุ่ม
                                tapTargetSize: MaterialTapTargetSize
                                    .shrinkWrap, // ลดพื้นที่แตะให้เล็กลง
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
                                      TextDecoration.underline, // เพิ่มเส้นใต้
                                  decorationColor:
                                      const Color(0xffE73E3E), // สีของเส้นใต้
                                  decorationThickness: 1, // ความหนาของเส้นใต้
                                  color: const Color(0xffE73E3E),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          // กำหนดตัวเลขที่จะใช้
                          String numberString = '999999';
                          List<String> numbers = numberString.split('');

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              numbers.length,
                              (index) => Container(
                                width: width * 0.12,
                                height: width * 0.16,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                    BoxShadow(
                                      color: Color(0xffb8b8b8),
                                      blurRadius: 1,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    numbers[index],
                                    style: TextStyle(
                                      fontFamily: 'prompt',
                                      fontSize: width * 0.1,
                                      fontWeight: FontWeight.w500,
                                    ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size.fromHeight(
                                  height * 0.06,
                                ),
                                backgroundColor: const Color(0xff32abed),
                                elevation: 3, //เงาล่าง
                                shadowColor: Colors.black.withOpacity(1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                "สุ่มตัวเลข",
                                style: TextStyle(
                                  fontFamily: 'prompt',
                                  fontSize: width * 0.045,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(
                                  width * 0.3,
                                  height * 0.06,
                                ),
                                backgroundColor: const Color(0xff0288d1),
                                elevation: 3, //เงาล่าง
                                shadowColor: Colors.black.withOpacity(1),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(16), // มุมโค้งมน
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
                  vertical: height * 0.01,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "หวยเด็ดมาแรง!",
                      style: TextStyle(
                        fontFamily: 'prompt',
                        fontSize: width * 0.05,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/lottot.jpg',
                      width: width * 0.95,
                    ),
                    Image.asset(
                      'assets/images/lottot.jpg',
                      width: width * 0.95,
                    ),
                    Image.asset(
                      'assets/images/lottot.jpg',
                      width: width * 0.95,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
