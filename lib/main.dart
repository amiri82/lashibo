import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lashibo/providers/themedata_provider.dart';
import "screens/login_page.dart";
import 'package:flutter_localizations/flutter_localizations.dart';
import "src/User.dart";

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Iranyekan",
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        fontFamily: "Iranyekan",
        brightness: Brightness.dark,
      ),
      themeMode: ref.watch(themeDataProvider),
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

}
