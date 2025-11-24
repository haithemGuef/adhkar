import 'package:adhkar/adhkar_home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Start extends StatelessWidget {
  const Start({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;

    return Scaffold(
      backgroundColor: const Color(0xff01443D),
      body: Stack(
        children: [
          Container(
            height: screenHeight * 0.55,
            width: screenWidth,
            child: Image.asset(
              "assets/adhkar/splash_secreen.jpg",
            ),
          ),
          Column(
            children: [
              Container(
                height: screenHeight * 0.552,
                width: screenWidth,
              ),
              Container(
                height: screenHeight * 0.448,
                width: screenWidth,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.03),
                    Text(
                      " منصة الأذكار الصباحية والمسائية ",
                      style: TextStyle(
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        
                           height: 1.9,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Text(
                        "منصة متخصصة تتيح لك عيش لحظات روحانية يومية عبر أذكار الصباح والمساء بدقة وانتظام.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "tajawal",
                          fontSize: screenWidth * 0.05,
                          height: 1.6,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff973534),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    MaterialButton(
                      height: screenHeight * 0.06,
                      minWidth: screenWidth * 0.6,
                      color: const Color(0xff01443D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () {
                        Get.to(() => const AdhkarHomePage());
                      },
                      child: Text(
                        "        الأذكــــار        ",
                        style: TextStyle(
                          fontSize: screenWidth * 0.055,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
