import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottotmuutoo/config/config.dart';
import 'package:lottotmuutoo/models/response/UserIdxGetResponse.dart';
import 'package:http/http.dart' as http;
import 'package:lottotmuutoo/pages/navpages/profile.dart';
import 'package:lottotmuutoo/pages/widgets/drawer.dart';

class EditProfile extends StatefulWidget {
  final String email;
  const EditProfile({super.key, required this.email});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late String url;
  late Future<void> loadData;
  late UserIdxGetResponse user;

  TextEditingController nameCtl = TextEditingController();
  TextEditingController nicknameCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();
  TextEditingController genderCtl = TextEditingController();
  TextEditingController birthdayCtl = TextEditingController();

  String gender = 'ชาย';

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  DateTime? selectedDate;

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        birthdayCtl.text =
            "${picked.day}/${picked.month}/${picked.year}"; // อัพเดทค่าใน brithdayCtl
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
                          'แก้ไขข้อมูลส่วนตัว',
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
        selectedPage: 5,
      ),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (widget.email == 'ยังไม่ได้เข้าสู่ระบบ') {
            return Container(
              child: const Text('ยังไม่ได้เข้าสู่ระบบ'),
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
            return ListView(
              children: [
                Row(
                  //โชว์ ชื่อ กับ รห้ส
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 350,
                      height: 150,
                      child: Card(
                        color: const Color(0xFF29B6F6),
                        elevation: 8,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 35),
                              child: Text(user.result[0].name,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20)),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 15),
                                  child: Text("รหัสสมาชิก : ",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 25,
                                  ),
                                  child: Text(user.result[0].uid.toString(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ), //สิ้นสุดโชว์ ชื่อ กับ รห้ส
                const Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            "ข้อมูลส่วนตัว",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: Row(
                    children: [
                      const Text(
                        "ชื่อ-นามสกุล",
                        style: TextStyle(fontSize: 13),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10, left: 10),
                            child: SizedBox(
                              width: 300,
                              height: 35,
                              child: TextField(
                                controller: nameCtl,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 14),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: const BorderSide(
                                      color: Colors.blue,
                                      width: 2.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: SizedBox(
                    height: 0.5,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Text(
                          "ชื่อเล่น",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      SizedBox(
                        width: 125,
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            height: 35,
                            child: TextField(
                              controller: nicknameCtl,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(
                                    color: Colors.blue,
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 10, right: 5),
                        child: Text(
                          "เบอร์โทร",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      SizedBox(
                        width: 125,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            height: 35,
                            child: TextField(
                              controller: phoneCtl,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 13),
                              inputFormatters: [
                                FilteringTextInputFormatter
                                    .digitsOnly, // รับเฉพาะตัวเลข
                                LengthLimitingTextInputFormatter(
                                    10), // จำกัดจำนวนตัวเลขเป็น 10 หลัก
                              ],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(
                                    color: Colors.blue,
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                                counterText: "", // ซ่อนข้อความเคาน์เตอร์
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: SizedBox(
                    height: 0.5,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "ว/ด/ป/เกิด",
                        style: TextStyle(fontSize: 13),
                      ),
                      SizedBox(
                        width: 150,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 0, left: 5),
                            child: GestureDetector(
                              onTap: () => _selectDate(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey, width: 1.0),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_today,
                                        color: Colors.grey),
                                    const SizedBox(width: 8),
                                    Text(
                                      birthdayCtl.text.isNotEmpty
                                          ? birthdayCtl.text
                                          : " ",
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Text(
                          "เพศ",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      SizedBox(
                        width: 90, // กำหนดความกว้างตามต้องการ
                        child: DropdownButton<String>(
                          value: gender.isNotEmpty ? gender : 'ชาย',
                          items: <String>['ชาย', 'หญิง', 'อื่นๆ']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Center(
                                // จัดตำแหน่งข้อความตรงกลาง
                                child: Text(
                                  value,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              gender = newValue!;
                            });
                          },
                          isExpanded: true,
                          underline: const SizedBox(),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: SizedBox(
                    height: 0.5,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "อีเมล",
                      style: TextStyle(fontSize: 13),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Text(user.result[0].email,
                          style: const TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: SizedBox(
                    height: 0.5,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 100, left: 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FilledButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfilePage(email: widget.email),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(100, 40),
                          backgroundColor:
                              const Color.fromARGB(255, 180, 180, 180),
                          foregroundColor: Colors.white,
                          elevation: 8,
                          shadowColor: Colors.black.withOpacity(0.10),
                        ),
                        child: const Text('ยกเลิก'),
                      ),
                      FilledButton(
                          onPressed: update,
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(100, 40),
                            backgroundColor:
                                const Color.fromARGB(255, 33, 150, 243),
                            foregroundColor: Colors.white,
                            elevation: 5,
                            shadowColor: Colors.black,
                          ),
                          child: const Text('ยืนยัน')),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];
    var res = await http.get(Uri.parse('$url/user/${widget.email}'));
    log(res.body);
    user = userIdxGetResponseFromJson(res.body);
    var useridx = user.result;

    if (useridx.isNotEmpty) {
      setState(() {
        nameCtl.text = useridx[0].name;
        nicknameCtl.text = useridx[0].nickname;
        phoneCtl.text = useridx[0].phone;
        emailCtl.text = useridx[0].email;
        genderCtl.text = useridx[0].gender;
        birthdayCtl.text = useridx[0].birth;
        selectedDate = DateTime.tryParse(useridx[0].birth) ??
            DateTime.now(); // กำหนด selectedDate จาก birth
      });
      log(useridx[0].name);
      log(useridx[0].email);
    }
  }

  void update() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];
    var json = {
      "name": nameCtl.text,
      "nickname": nicknameCtl.text,
      "email": emailCtl.text,
      "gender": gender,
      "birth": birthdayCtl.text,
      "phone": phoneCtl.text,
    };
    try {
      var res = await http.put(Uri.parse('$url/user/edit?${widget.email}'),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: jsonEncode(json));
      log(res.body);
      var result = jsonDecode(res.body);
      log(result['message']);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('สำเร็จ'),
          content: const Text('บันทึกข้อมูลเรียบร้อย'),
          actions: [
            FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(email: widget.email),
                    ),
                  );
                },
                child: const Text('ปิด'))
          ],
        ),
      );
    } catch (err) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('ผิดพลาด'),
          content: Text('บันทึกข้อมูลไม่สำเร็จ $err'),
          actions: [
            FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('ปิด'))
          ],
        ),
      );
    }
  }
}
