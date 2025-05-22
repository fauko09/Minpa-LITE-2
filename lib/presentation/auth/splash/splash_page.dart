import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:googleapis/forms/v1.dart';
import 'package:minpa_lite/core/utils/color_constans.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Color averageColor(Color a, Color b) {
    return Color.fromARGB(
      ((a.alpha + b.alpha) ~/ 2),
      ((a.red + b.red) ~/ 2),
      ((a.green + b.green) ~/ 2),
      ((a.blue + b.blue) ~/ 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      // backgroundColor: averageColor(ColorConstans.second, ColorConstans.primary),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery.sizeOf(context).height / 2),
          child: Container(
            padding: const EdgeInsets.only(
              top: 30,
            ),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(
                  50,
                ),
                bottomRight: Radius.circular(
                  50,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Minpa Lite 2",
                  style: TextStyle(
                    fontFamily: "sf pro display italic bold",
                    color: ColorConstans.primary,
                    fontSize: 20,
                  ),
                ),
                Text(
                  "Teman pencatat penjualan anda",
                  style: TextStyle(
                    fontFamily: "sf pro display",
                    color: ColorConstans.primary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          )),
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          gradient: ColorConstans.primaryGradient,
        ),
        padding: const EdgeInsets.only(
          bottom: 15,
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "@Fawq Dhakiun",
              style: TextStyle(
                fontFamily: "sf pro display bold",
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
