import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Hello"),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.library_books), label: "Library"),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: "My Account",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.store),
              label: "Shop",
            ),
          ],
        ),
      ),
    );
  }
}
