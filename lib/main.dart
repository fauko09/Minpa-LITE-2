import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:minpa_lite/data/datasources/auth_local_datasource.dart';
import 'package:minpa_lite/data/models/responses/user_model.dart';
import 'package:minpa_lite/presentation/auth/splash/splash_page.dart';
import 'package:minpa_lite/presentation/home/home_page.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  // await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: FutureBuilder<UserModel?>(
          future: AuthLocalDatasource().getUserData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                return const HomePage();
              } else {
                return const SplashPage();
              }
            } else {
              return const SplashPage();
            }
          }),
    ),
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
