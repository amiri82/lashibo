import "package:flutter/material.dart";
import "package:lashibo/screens/account_page.dart";
import "package:lashibo/screens/home_page.dart";
import "library_page.dart";
import "shop_page.dart";

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.my_library_books_outlined),
            label: "Library",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: "My Account",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store_outlined),
            label: "Shop",
          ),
        ],
      ),
      body: bodyGenerator(currentIndex),
    );
  }
}

bodyGenerator(currentIndex) {
  switch (currentIndex) {
    case 0:
      return HomePage();
    case 1:
      return LibraryPage();
    case 2:
      return AccountPage();
    case 3:
      return ShopPage();
    default:
      return AccountPage();
  }
}
