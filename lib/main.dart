import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "screens/login_page.dart";
import 'package:flutter_localizations/flutter_localizations.dart';
import "src/User.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  // ignore: library_private_types_in_public_api
  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  User? currentUser;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Iranyekan",
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        fontFamily: "Iranyekan",
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("fa", "IR"),
        Locale("en", "US"),
      ],
    );
  }

  void changeThemeMode() {
    setState(() {
      _themeMode =
      _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void changeCurrentUser(String username, String emailAddress, int credit,int premiumMonthsLeft){
    currentUser = User(username,emailAddress,credit,premiumMonthsLeft);
  }

  void refreshCredit(){

  }
}
