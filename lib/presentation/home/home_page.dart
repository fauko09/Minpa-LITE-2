import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minpa_lite/core/utils/color_constans.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstans.primary,
        title: const Text(
          'Penjualan',
          style: TextStyle(
            fontFamily: "sf pro display",
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        foregroundColor: ColorConstans.second,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ColorConstans.primary,
          statusBarIconBrightness: Brightness.light,
        ),
        leading: IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.qr_code_scanner,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        decoration: const BoxDecoration(
          color: Colors.white,
          // gradient: ColorConstans.primaryGradient,
        ),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
